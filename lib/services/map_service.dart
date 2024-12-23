// map_service.dart

import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Fetch countries collection from Firestore
  Future<List<Map<String, dynamic>>> getCountries() async {
    try {
      // Get all documents from the 'countries' collection
      QuerySnapshot snapshot = await _db.collection('countries').get();

      // Convert documents to a list of maps
      List<Map<String, dynamic>> countries = snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;

        // Return a map with the desired fields
        return {
          'name': data['name'] ?? 'Unknown',
          'id': data['id'] ?? 0,
          'mapsupport': data['mapsupport'] ?? false,
        };
      }).toList();

      return countries;
    } catch (e) {
      print("Error fetching countries: $e");
      throw e;
    }
  }
}
