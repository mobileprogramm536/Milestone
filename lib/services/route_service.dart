import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RouteDetail {
  RouteDetail({this.routecard, this.ownerfollowercount, this.locations});
  int? ownerfollowercount;
  List<dynamic>? locations;
  RouteCard? routecard;
}

class RouteCard {
  RouteCard({
    this.routeOwnerId,
    this.title,
    this.description,
    this.pfpurl,
    this.username,
    this.destinationcount,
    this.liked,
    this.likecount,
    this.category,
  });

  String? routeOwnerId;
  String? title;
  String? description;
  String? pfpurl;
  String? username;
  int? destinationcount;
  bool? liked;
  int? likecount;
  late final String? category;
}

class RouteService {
  final RouteCollection = FirebaseFirestore.instance.collection("routes");
  final UserCollection = FirebaseFirestore.instance.collection("users");
  final UserDetailsCollection =
      FirebaseFirestore.instance.collection("userdetails");

  Future<RouteCard?> getRouteCard(String routeId) async {
    try {
      var docref1 = await RouteCollection.doc(routeId).get();
      if (!docref1.exists) return null;

      RouteCard rc = RouteCard(
        description:
            docref1.data()?["description"] ?? "No description available",
        routeOwnerId: docref1.data()?["routeUser"] ?? "Unknown",
        title: docref1.data()?["routeName"] ?? "Untitled",
        likecount: docref1.data()?["likecount"] ?? 0, // VarsayÄ±lan 0
        destinationcount:
            (docref1.data()?["locations"] as List<dynamic>?)?.length ?? 0,
        category: docref1.data()?["category"] ?? "All",
      );

      var docref2 = await UserCollection.doc(rc.routeOwnerId).get();
      if (docref2.exists) {
        rc.username = docref2.get('name');
        rc.pfpurl = docref2.get('profileImage');
      }

      var querySnapshot = await UserDetailsCollection.where("userId",
              isEqualTo: rc.routeOwnerId)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        var temp = querySnapshot.docs.first.get("likedRoutes") as List<dynamic>;
        rc.liked = temp.contains(routeId);
      } else {
        rc.liked = false;
      }

      return rc;
    } catch (e) {
      print("Error fetching RouteCard: $e");
      return null;
    }
  }

  Future<RouteDetail?> getRouteDetail(String routeId) async {
    try {
      var docref1 = await RouteCollection.doc(routeId).get();
      if (!docref1.exists) return null;

      RouteDetail rd = RouteDetail(
        routecard: await getRouteCard(routeId),
        locations: docref1.get("locations") as List<dynamic>,
      );

      var querySnapshot = await UserDetailsCollection.where("userId",
              isEqualTo: docref1.get("routeUser"))
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        rd.ownerfollowercount =
            (querySnapshot.docs.first.get("followers") as List<dynamic>).length;
      }

      return rd;
    } catch (e) {
      print("Error fetching RouteDetail: $e");
      return null;
    }
  }

  Future<void> createRoute({
    required int likecount,
    required String? routeUser,
    required String routeName,
    required String routeDescription,
    required List<Map<String, dynamic>> locations,
  }) async {
    try {
      await RouteCollection.add({
        'likecount': likecount,
        'routeUser': routeUser,
        'routeName': routeName,
        'description': routeDescription,
        'locations': locations,
        'createdAt': FieldValue.serverTimestamp(),
      });
      print('Route successfully added!');
    } catch (e) {
      print('Error adding route: $e');
    }
  }

  Future<void> saveRoute(String routeId) async {
    try {
      var userID = await AuthService().getUser();
      if (userID == null) throw Exception("User not logged in.");

      var docref1 = await UserDetailsCollection.doc(userID).get();
      Map<String, dynamic> savedRoutes =
          (docref1.data()?['savedRoutes'] ?? {}) as Map<String, dynamic>;

      if (savedRoutes.containsKey(routeId)) {
        // Remove the route from saved routes
        await UserDetailsCollection.doc(userID).update({
          'savedRoutes.$routeId': FieldValue.delete(),
        });
      } else {
        // Add the route with just the category field
        await UserDetailsCollection.doc(userID).update({
          'savedRoutes.$routeId': {
            'category': null,
          },
        });
      }
      print('Route $routeId saved or removed from saved routes.');
    } catch (e) {
      print('Error saving route: $e');
    }
  }

  Future<List<RouteCard>> getRoutesForIcon(String icon) async {
    var userID = await AuthService().getUser();
    List<RouteCard> filteredRoutes = [];

    try {
      QuerySnapshot querySnapshot =
          await RouteCollection.where('routeUser', isNotEqualTo: userID).get();

      for (var doc in querySnapshot.docs) {
        RouteCard route = RouteCard(
          title: doc.get("routeName"),
          description: doc.get("description"),
          category: doc.get("category"), // Ensure 'category' is set for routes
        );

        if (route.category == icon || icon == "All") {
          filteredRoutes.add(route);
        }
      }
    } catch (e) {
      print("Error fetching routes for icon: $e");
    }

    return filteredRoutes;
  }

  Future<List<Map<String, dynamic>>> getSavedRoutes() async {
    try {
      var userID = await AuthService().getUser();
      if (userID == null) return [];

      // Get user's saved routes from userdetails collection
      final userDetailsDoc = await UserDetailsCollection.doc(userID).get();
      Map<String, dynamic> savedRoutes =
          (userDetailsDoc.data()?['savedRoutes'] ?? {}) as Map<String, dynamic>;

      // Fetch complete route documents
      List<Map<String, dynamic>> routes = [];
      for (String routeId in savedRoutes.keys) {
        final routeDoc = await RouteCollection.doc(routeId).get();

        if (routeDoc.exists) {
          Map<String, dynamic> routeData = routeDoc.data() ?? {};
          routeData['routeId'] = routeId;
          routeData['category'] =
              savedRoutes[routeId]['category']; // Include the saved category
          routeData['pfpurl'] = await UserCollection.doc(routeData['routeUser'])
              .get()
              .then((value) => value.get('profileImage'));
          routes.add(routeData);
        }
      }

      return routes;
    } catch (e) {
      print('Error fetching saved routes: $e');
      return [];
    }
  }

  Future<void> updateRouteCategory(String routeId, String newCategory) async {
    try {
      var userID = await AuthService().getUser();
      if (userID == null) throw Exception("User not logged in.");

      // Update the category in the user's saved routes
      await UserDetailsCollection.doc(userID).update({
        'savedRoutes.$routeId.category': newCategory,
      });

      print('Route category updated successfully!');
    } catch (e) {
      print('Error updating route category: $e');
    }
  }

  Future<List<String>> getExploreRoutes() async {
    try {
      var userID = await AuthService().getUser();
      print('Fetched User ID: $userID');

      QuerySnapshot querySnapshot =
          await RouteCollection.where('routeUser', isNotEqualTo: userID).get();
      print('Fetched Docs: ${querySnapshot.docs}');
      return querySnapshot.docs.map((doc) => doc.id).toList();
    } catch (e) {
      print('Error fetching explore routes: $e');
      return [];
    }
  }

  Future<List<String>> getOwnedRoutes() async {
    try {
      var userID = await AuthService().getUser();
      QuerySnapshot querySnapshot =
          await RouteCollection.where('routeUser', isEqualTo: userID).get();
      return querySnapshot.docs.map((doc) => doc.id).toList();
    } catch (e) {
      print('Error fetching owned routes: $e');
      return [];
    }
  }

  Future<void> likeRoute(String routeId, bool alreadyLiked) async {
    try {
      var userID = await AuthService().getUser();
      if (userID == null) throw Exception("User not logged in.");

      var docref1 = await UserDetailsCollection.doc(userID).get();
      var temp = docref1.get('likedRoutes') as List<dynamic>;

      if (temp.contains(routeId)) {
        alreadyLiked = true;
      } else {
        alreadyLiked = false;
      }

      if (alreadyLiked) {
        await RouteCollection.doc(routeId).update({
          'likecount': FieldValue.increment(-1),
        });
        await UserDetailsCollection.doc(userID).update({
          'likedRoutes': FieldValue.arrayRemove([routeId]),
        });
      } else {
        await RouteCollection.doc(routeId).update({
          'likecount': FieldValue.increment(1),
        });
        await UserDetailsCollection.doc(userID).update({
          'likedRoutes': FieldValue.arrayUnion([routeId]),
        });
      }
    } catch (e) {
      print('Error liking route: $e');
    }
  }

  Future<bool> isRouteSaved(String routeId) async {
    var userID = await AuthService().getUser();
    if (userID == null) throw Exception("User not logged in.");
    var docref1 = await UserDetailsCollection.doc(userID).get();
    var savedRoutes = docref1.get('savedRoutes') as Map<String, dynamic>;

    return savedRoutes.containsKey(routeId);
  }

  Future<bool> isRouteLiked(String routeId) async {
    var userID = await AuthService().getUser();
    if (userID == null) throw Exception("User not logged in.");
    var docref1 = await UserDetailsCollection.doc(userID).get();
    var temp = docref1.get('likedRoutes') as List<dynamic>;

    return temp.contains(routeId);
  }
}
