import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../cards/routeCard.dart';

class SavedRoutesPage extends StatefulWidget {
  SavedRoutesPage({super.key});

  @override
  State<SavedRoutesPage> createState() => _SavedRoutesPageState();
}

class _SavedRoutesPageState extends State<SavedRoutesPage> {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Widget _buildRouteList() {
    return StreamBuilder<QuerySnapshot>(
      stream: _db.collection('routes').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text("Error: ${snapshot.error}"));
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text("No routes found"));
        }

        // Firestore verilerini güvenli şekilde işleme
        List<Map<String, dynamic>> routes = snapshot.data!.docs.map((doc) {
          final data = doc.data() as Map<String, dynamic>? ?? {};

          // Her alan için null kontrolü ve tür dönüşümü
          final routeName = data['routeName']?.toString();
          final description = data['description']?.toString();
          final locations = data['locations'];

          return {
            'name': routeName,
            'description': description,
            'locations': locations,
          };
        }).toList();

        return ListView.builder(
          itemCount: routes.length,
          itemBuilder: (context, index) {
            var route = routes[index];

            // Locations verisi
            var location = route['locations'] is List
                ? (route['locations'] as List)
                    .map((e) => e.toString())
                    .join(', ')
                : 'No locations available';

            return ReusableCard(
              profileImageUrl: "a",
              title: route['name'],
              description: route['description'],
              location: location,
              destinationCount: (route['locations'] as List).length,
              likes: 0,
              onProfileTap: () {},
              onLikeTap: () {},
              onCardTap: () {},
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Saved Routes")),
      body: _buildRouteList(),
    );
  }
}
