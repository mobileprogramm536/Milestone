import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'auth_service.dart';

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
        likecount: docref1.data()?["likeCount"] ?? 0, // Varsayılan 0
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
        'likeCount': likecount,
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

      var userDetailsID;
      var querySnapshot =
          await UserDetailsCollection.where("userId", isEqualTo: userID).get();

      if (querySnapshot.docs.isNotEmpty) {
        userDetailsID = querySnapshot.docs.first.id;
      } else {
        throw Exception("User details not found.");
      }

      var docref1 = await UserDetailsCollection.doc(userDetailsID).get();
      var temp = docref1.get('savedRoutes') as List<dynamic>;

      if (temp.contains(routeId)) {
        await UserDetailsCollection.doc(userDetailsID).update({
          'savedRoutes': FieldValue.arrayRemove([routeId]),
        });
      } else {
        await UserDetailsCollection.doc(userDetailsID).update({
          'savedRoutes': FieldValue.arrayUnion([routeId]),
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

  Future<List<String>> getSavedRoutes() async {
    try {
      var userID = await AuthService().getUser();
      var querySnapshot =
          await UserDetailsCollection.where('userId', isEqualTo: userID).get();

      if (querySnapshot.docs.isEmpty) return [];

      var docid = querySnapshot.docs.first.id;
      var docref1 = await UserDetailsCollection.doc(docid).get();
      return List<String>.from(docref1.get('savedRoutes'));
    } catch (e) {
      print('Error fetching saved routes: $e');
      return [];
    }
  }

  Future<void> updateRouteCategory(String routeId, String newCategory) async {
    try {
      // Update the route's category field in Firestore
      await RouteCollection.doc(routeId).update({
        'category':
            newCategory, // Assuming you have a 'category' field in your route document
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

      var userDetailsID;
      var querySnapshot =
          await UserDetailsCollection.where("userId", isEqualTo: userID).get();

      if (querySnapshot.docs.isNotEmpty) {
        userDetailsID = querySnapshot.docs.first.id;
      } else {
        throw Exception("User details not found.");
      }

      var docref1 = await UserDetailsCollection.doc(userDetailsID).get();
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
        await UserDetailsCollection.doc(userDetailsID).update({
          'likedRoutes': FieldValue.arrayRemove([routeId]),
        });
      } else {
        await RouteCollection.doc(routeId).update({
          'likecount': FieldValue.increment(1),
        });
        await UserDetailsCollection.doc(userDetailsID).update({
          'likedRoutes': FieldValue.arrayUnion([routeId]),
        });
      }
    } catch (e) {
      print('Error liking route: $e');
    }
  }
}
