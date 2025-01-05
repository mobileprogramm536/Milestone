import 'package:flutter/material.dart';
import '../services/route_service.dart';
import '../theme/colors.dart';
import '../widgets/custom_navbar.dart';

class SavedRoutesPage extends StatefulWidget {
  const SavedRoutesPage({Key? key}) : super(key: key);

  @override
  State<SavedRoutesPage> createState() => _SavedRoutesPageState();
}

class _SavedRoutesPageState extends State<SavedRoutesPage> {
  List<RouteCard> savedRoutes = [];
  List<RouteCard> displayedRoutes = []; // Initially no routes displayed
  List<String> collectionIcons = [
    "All", // Show all saved routes
    "🇩🇪", "🇹🇷", "🇮🇹", "🏛️"
  ];

  @override
  void initState() {
    super.initState();
    fetchSavedRoutes();
  }

  Future<void> fetchSavedRoutes() async {
    final routeService = RouteService();
    List<String> routeIds = await routeService.getSavedRoutes();

    for (var routeId in routeIds) {
      RouteCard? route = await routeService.getRouteCard(routeId);
      if (route != null) {
        setState(() {
          savedRoutes.add(route);
        });
      }
    }

    // Initially, show all routes
    _filterRoutesByCategory("All");
  }

  void _filterRoutesByCategory(String category) {
    setState(() {
      if (category == "All") {
        displayedRoutes = List.from(savedRoutes);
      } else {
        displayedRoutes =
            savedRoutes.where((route) => route.category == category).toList();
      }
    });
  }

  void _showCategoryChangeDialog(RouteCard route) async {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Kategori Seçin"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: collectionIcons.map((icon) {
              return ListTile(
                leading: Text(
                  icon,
                  style: const TextStyle(fontSize: 24),
                ),
                title: Text("Kategori: $icon"),
                onTap: () async {
                  final routeService = RouteService();
                  await routeService.updateRouteCategory(
                      route.routeOwnerId ?? "", icon);

                  setState(() {
                    route.category = icon; // Seçilen kategoriyi güncelle
                  });

                  Navigator.pop(context);
                  _filterRoutesByCategory(icon); // Filtreleme işlemi
                },
              );
            }).toList(),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Kaydedilen Rotalar'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: collectionIcons.map((icon) {
                return GestureDetector(
                  onTap: () => _filterRoutesByCategory(icon),
                  child: CircleAvatar(
                    radius: 30,
                    backgroundColor: AppColors.yellow1,
                    child: Text(
                      icon,
                      style: const TextStyle(fontSize: 24),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          Expanded(
            child: displayedRoutes.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    itemCount: displayedRoutes.length,
                    itemBuilder: (context, index) {
                      final route = displayedRoutes[index];
                      return Card(
                        margin: const EdgeInsets.all(8.0),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundImage: route.pfpurl != null
                                ? NetworkImage(route.pfpurl!)
                                : null,
                            child: route.pfpurl == null
                                ? const Icon(Icons.person)
                                : null,
                          ),
                          title: Text(route.title ?? "Rota Başlığı"),
                          subtitle: Text(
                              "${route.description ?? "Açıklama"}\n${route.destinationcount} destinations - ${route.likecount} likes"),
                          trailing: Icon(
                            route.liked == true
                                ? Icons.favorite
                                : Icons.favorite_border,
                            color: route.liked == true ? Colors.red : null,
                          ),
                          onTap: () {
                            _showCategoryChangeDialog(route);
                          },
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
