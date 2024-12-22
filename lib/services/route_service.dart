import 'package:cloud_firestore/cloud_firestore.dart';

class RouteService {
  final RouteCollection = FirebaseFirestore.instance.collection("routes");
  final UserCollection = FirebaseFirestore.instance.collection("users");
  final UserDetails = FirebaseFirestore.instance.collection("userdetails");
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;


  // Rota verilerini Firebase Firestore'a gönderme fonksiyonu
  Future<void> createRoute({
    required String routeName,
    required String routeDescription,
    required List<Map<String, dynamic>> locations,
  }) async {
    try {
      // Firestore'da yeni bir rota belgesi oluşturuluyor

      // Firestore'a yeni rota ekleniyor
      await RouteCollection.add({
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


  Future<void> getRouteCredentials ({
    required String routeID,
    required String userID,
}) async{
    try{
      
    }
    catch(e){
      print('Hata olustu: $e');
    }

}

}

