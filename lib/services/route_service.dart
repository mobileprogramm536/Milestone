import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import '../services/auth_service.dart';

class RouteCard {
  RouteCard(
      {this.routeOwnerId,
        this.title,
        this.description,
        this.pfpurl,
        this.username,
        this.destinationcount,
        this.liked,
        this.likecount});

  String? routeOwnerId;
  String? title;
  String? description;
  String? pfpurl;
  String? username;
  int? destinationcount;
  bool? liked;
  int? likecount;
}

class RouteDetail{
  RouteDetail({
    this.routecard,
    this.ownerfollowercount,
    this.locations,
  });
  int? ownerfollowercount;
  List<dynamic>? locations;
  RouteCard? routecard;
}


class RouteService {
  final RouteCollection = FirebaseFirestore.instance.collection("routes");
  final UserCollection = FirebaseFirestore.instance.collection("users");
  final UserDetailsCollection =
  FirebaseFirestore.instance.collection("userdetails");
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<RouteDetail?> getRouteDetail(String routeId) async{
    RouteDetail? rd = RouteDetail();
    try{
      var docref1= await RouteCollection.doc(routeId).get();

      rd.routecard = getRouteCard(routeId) as RouteCard?;
      rd.locations = docref1.get("locations") as List<dynamic>;

      var querySnapshot = await UserDetailsCollection.where("userId",
          isEqualTo: docref1.get("routeUser"))
          .get();

      rd.ownerfollowercount=(querySnapshot.docs.first.get("followers") as List<dynamic>).length;

    }catch(e){}

    return rd;
  }


  Future<RouteCard?> getRouteCard(String routeId) async {
    RouteCard? rc = RouteCard();
    try {
      var docref1 = await RouteCollection.doc(routeId).get();

      if (docref1.exists) {
        rc.description = docref1.get("description");
        rc.routeOwnerId = docref1.get("routeUser");
        rc.title = docref1.get("routeName");
        rc.likecount = docref1.get("likecount");
        rc.destinationcount =
            (docref1.get("locations") as List<dynamic>).length;

        var docref2 = await UserCollection.doc(docref1.get('routeUser')).get();
        if (docref2.exists) {
          rc.username = docref2.get('name');
          rc.pfpurl = docref2.get('profileImage');
        }

        var querySnapshot = await UserDetailsCollection.where("userId",
            isEqualTo: docref1.get("routeUser"))
            .get();

        if (querySnapshot.docs.isNotEmpty) {
          var temp =
          querySnapshot.docs.first.get("likedRoutes") as List<dynamic>;
          rc.liked = temp.contains(routeId);
        } else {
          rc.liked = false;
        }
      }
    } catch (e) {
      print("Error fetching RouteCard: $e");
    }

    return rc;
  }


  // Rota verilerini Firebase Firestore'a gönderme fonksiyonu
  Future<void> createRoute({
    required String? routeUser,
    required String routeName,
    required String routeDescription,
    required List<Map<String, dynamic>> locations,
  }) async {
    try {
      // Firestore'da yeni bir rota belgesi oluşturuluyor

      // Firestore'a yeni rota ekleniyor
      await RouteCollection.add({
        'routeUser': routeUser,
        'routeName': routeName,
        'description': routeDescription,
        'locations': locations,
        'createdAt': FieldValue.serverTimestamp(), // Eklenen zaman damgası
      });
      print('Rota verisi başarılı bir şekilde gönderildi!');
    } catch (e) {
      print('Hata oluştu: $e');
    }
  }

  // Rota Explore Fonksiyonu
  Future<List<String>> getExploreRoutes() async {
    var userID = AuthService().getUser();
    try {
      QuerySnapshot querySnapshot = await RouteCollection
          .where('routeUser', isNotEqualTo: userID)
          .get();

      List<String> documentIds = querySnapshot.docs.map((doc) => doc.id).toList();

      return documentIds;
    } catch (e) {
      print('Error fetching routes: $e');
      return[];
    }
  }

// Sahip olunan rotaları alma fonksiyonu
  Future<List<String>> getOwnedRoutes() async {
    try {
      var userID = AuthService().getUser();

      QuerySnapshot querySnapshot = await RouteCollection
          .where('routeUser', isEqualTo: userID)
          .get();

      List<String> documentIds = querySnapshot.docs.map((doc) => doc.id).toList();

      return documentIds;
    } catch (e) {
      print('Error fetching routes: $e');
      return[];
    }
  }

// Herhangi bir user'in rotalarını alma fonksiyonu
  Future<List<String>> getUserRoutes({
    required String userID,
  }) async {
    try {
      QuerySnapshot querySnapshot = await RouteCollection
          .where('routeUser', isEqualTo: userID)
          .get();

      List<String> documentIds = querySnapshot.docs.map((doc) => doc.id).toList();

      return documentIds;
    } catch (e) {
      print('Error fetching routes: $e');
      return[];
    }
  }
}
