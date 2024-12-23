import 'package:cloud_firestore/cloud_firestore.dart';

class RouteService {
  final RouteCollection = FirebaseFirestore.instance.collection("routes");
  final UserCollection = FirebaseFirestore.instance.collection("users");
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

  // Veritabanındaki rotaları almak için fonksiyon
  Future<List<Map<String, dynamic>>> getRoutes() async {
    try {
      QuerySnapshot querySnapshot = await _firestore.collection('routes').get();
      List<Map<String, dynamic>> routeList = querySnapshot.docs.map((doc) {
        return doc.data() as Map<String, dynamic>;
      }).toList();

      return routeList;
    } catch (e) {
      print('Veriler alınırken hata oluştu: $e');
      return [];
    }
  }
}

Future<Map<String, dynamic>> getRouteCardCredentials(String routeId,
    {required String title}) async {
  try {
    // Firestore instance oluştur
    final firestore = FirebaseFirestore.instance;

    // Firestore'dan belirtilen routeId'ye sahip dokümanı getir
    final docSnapshot = await firestore.collection('routes').doc(routeId).get();

    // Eğer doküman mevcut değilse hata döndür
    if (!docSnapshot.exists) {
      throw Exception("Route not found for id: $routeId");
    }

    // Doküman verilerini al
    final data = docSnapshot.data();

    // Eğer data null ise hata döndür
    if (data == null) {
      throw Exception("No data found in the document");
    }

    // İstenen verileri işle
    final likeCount =
        data['likecount']?.toString() ?? '0'; // likecount'ı stringe çevir
    final owner = data['owner'] ?? ''; // owner string
    final routeDescription =
        data['routedescription'] ?? ''; // routedescription string
    final routeLocation = data['routelocation'] ?? ''; // routelocation string
    final title = data['title'] ?? ''; // title string
    final routeSize =
        (data['route'] as Map?)?.length ?? 0; // route map eleman sayısı

    // Verileri bir map olarak döndür
    return {
      'likeCount': likeCount,
      'owner': owner,
      'routeDescription': routeDescription,
      'routeLocation': routeLocation,
      'title': title,
      'routeSize': routeSize,
    };
  } catch (e) {
    // Hata durumunda loglama yapabilir veya özel hata dönebilirsiniz
    print('Error fetching route credentials: $e');
    rethrow;
  }
}
