import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RouteService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final RouteCollection = FirebaseFirestore.instance.collection("routes");
  final UserCollection = FirebaseFirestore.instance.collection("users");


  Future<Map<String, dynamic>> getRouteCardCredentials(String routeId) async {
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
      final likeCount = data['likecount']?.toString() ?? '0'; // likecount'ı stringe çevir
      final owner = data['owner'] ?? ''; // owner string
      final routeDescription = data['routedescription'] ?? ''; // routedescription string
      final routeLocation = data['routelocation'] ?? ''; // routelocation string
      final title = data['title'] ?? ''; // title string
      final routeSize = (data['route'] as Map?)?.length ?? 0; // route map eleman sayısı

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






}