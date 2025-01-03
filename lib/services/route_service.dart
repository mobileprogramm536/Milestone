import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';


//username str
//title srt ++
//description str ++
//location str AAAAA
//destinationcount ++
//likecount  AAAAA
//liked?
//pfpurl


class RouteCard{
  RouteCard({
    this.location,
    this.title,
    this.description,
    this.pfpurl,
    this.username,
    this.destinationcount,
    this.liked,
    this.likecount
  });

String? location;
String? title;
String? description;
String? pfpurl;
String? username;
int? destinationcount;
bool? liked;
int? likecount;
}

class RouteService {
  final RouteCollection = FirebaseFirestore.instance.collection("routes");
  final UserCollection = FirebaseFirestore.instance.collection("users");
  final UserDetailsCollection = FirebaseFirestore.instance.collection("userdetails");
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;


  Future<RouteCard?> getRouteCard(String routeId) async {
    RouteCard? rc = RouteCard();

    try {
      var docref1 = await RouteCollection.doc(routeId).get();

      if (docref1.exists) {
        rc.description = docref1.get("description");
        rc.location = "buduzelecek";
        rc.title = docref1.get("routeName");
        rc.likecount = 41;
        rc.destinationcount = (docref1.get("locations") as List<dynamic>).length;

        var docref2 = await UserCollection.doc(docref1.get('routeUser')).get();
        if (docref2.exists) {
          rc.username = docref2.get('name');
          rc.pfpurl = docref2.get('profileImage');
        }

        var querySnapshot = await UserDetailsCollection
            .where("userId", isEqualTo: docref1.get("routeUser"))
            .get();

        if (querySnapshot.docs.isNotEmpty) {
          var temp = querySnapshot.docs.first.get("likedRoutes") as List<dynamic>;
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

  Future<void> getExploreRoutes({
    required String userID,
  }) async {
    try{
      RouteCollection
          .where("ownerId", isEqualTo: userID)
          .get()
          .then((querySnapshot) {
        print("Successfully completed");
        for (var docSnapshot in querySnapshot.docs) {
          // Extract specific fields from the document
          var field1 = docSnapshot.get("description"); // Replace with your field names
          var field2 = docSnapshot.get("routeName");

          print('${docSnapshot.id} ==> field1: $field1, field2: $field2');
        }
      })
          .catchError((error) {
        print("Failed to fetch data: $error");
      });
    }
    catch(e){
      print('Hata olustu: $e');
    }
  }

  Future<void> getOwnedRoutes({
    required String routeName,
  }) async {
    try{
      RouteCollection
          .where("routeName", isNotEqualTo: routeName)
          .get()
          .then((querySnapshot) {
        print("Successfully completed");
        for (var docSnapshot in querySnapshot.docs) {
          // Extract specific fields from the document
          var field1 = docSnapshot.get("description"); // Replace with your field names
          var field2 = docSnapshot.get("routeName");
          var locations = docSnapshot.get("locations") as List<dynamic>;
          var field3 = locations.map((location) {
            var name = location["name"] as String;
            var note = location["note"] as String;
            var place = location["place"] as GeoPoint; // Cast explicitly to GeoPoint

            return {
              "name": name,
              "note": note,
              "place": {
                "latitude": place.latitude,
                "longitude": place.longitude
              }
            };
          }).toList();

          print('${docSnapshot.id} ==> field1: $field1, field2: $field2, field3: $field3');
        }
      })
          .catchError((error) {
        print("Failed to fetch data: $error");
      });
    }
    catch(e){
      print('Hata olustu: $e');
    }
  }

}

