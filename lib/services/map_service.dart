import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<String?> _getCurrentUserId() async {
    final user = _auth.currentUser;
    return user?.uid;

    // return 'XBNmdeE7GC2GVJ8jW7Dm';
  }

  Future<List<Map<String, dynamic>>> getVisitedCountries() async {
    try {
      final userId = await _getCurrentUserId();
      if (userId == null) {
        print('User not signed in');
        return [];
      }

      final userDetailsDoc =
          await _firestore.collection('userdetails').doc(userId).get();
      if (userDetailsDoc.exists) {
        final data = userDetailsDoc.data();
        if (data != null && data.containsKey('visitedCountries')) {
          return List<Map<String, dynamic>>.from(data['visitedCountries']);
        }
      }
      return [];
    } catch (e) {
      print('Error fetching visited countries: $e');
      return [];
    }
  }

  Future<void> addVisitedCountry(Map<String, dynamic> countryData) async {
    try {
      final userId = await _getCurrentUserId();
      if (userId == null) {
        print('User not signed in');
        return;
      }

      final userRef = _firestore.collection('userdetails').doc(userId);
      final userDetailsDoc = await userRef.get();

      if (userDetailsDoc.exists) {
        await userRef.update({
          'visitedCountries': FieldValue.arrayUnion([countryData]),
        });
      } else {
        await userRef.set({
          'visitedCountries': [countryData],
          'createdAt': FieldValue.serverTimestamp(),
        }, SetOptions(merge: true));
      }
    } catch (e) {
      print('Error adding visited country: $e');
    }
  }

  Future<void> removeVisitedCountry(String countryCode) async {
    try {
      final userId = await _getCurrentUserId();
      if (userId == null) {
        print('User not signed in');
        return;
      }

      final userRef = _firestore.collection('userdetails').doc(userId);
      final userDetailsDoc = await userRef.get();

      if (userDetailsDoc.exists) {
        final data = userDetailsDoc.data();
        if (data != null && data.containsKey('visitedCountries')) {
          final visitedCountries =
              List<Map<String, dynamic>>.from(data['visitedCountries']);

          // Find the country to remove
          final countryToRemove = visitedCountries.firstWhere(
            (country) => country['code'] == countryCode,
            orElse: () => {},
          );

          if (countryToRemove.isNotEmpty) {
            // Use arrayRemove to remove the specific country
            await userRef.update({
              'visitedCountries': FieldValue.arrayRemove([countryToRemove])
            });
          }
        }
      }
    } catch (e) {
      print('Error removing visited country: $e');
    }
  }
}

