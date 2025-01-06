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
  String selectedCategory = "All";  // Add this to track selected category
  int _selectedIndex = 2;  // 2 for saved routes tab
  List<String> routeIds = [];  // Add this line to store route IDs

  @override
  void initState() {
    super.initState();
    fetchSavedRoutes();
  }

  Future<void> fetchSavedRoutes() async {
    final routeService = RouteService();
    routeIds = await routeService.getSavedRoutes();

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
      selectedCategory = category;  // Update selected category
      if (category == "All") {
        displayedRoutes = List.from(savedRoutes);
      } else {
        displayedRoutes =
            savedRoutes.where((route) => route.category == category).toList();
      }
    });
  }

  void _onNavBarItemSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });
    print('Selected Index: $index');
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;  // Add this for height calculation

    return Scaffold(
      backgroundColor: AppColors.darkgrey1,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Collections Section
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.darkgrey2,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Koleksiyonlarım',
                        style: TextStyle(
                          color: AppColors.white1,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: collectionIcons.map((icon) {
                      return GestureDetector(
                        onTap: () => _filterRoutesByCategory(icon),
                        child: CircleAvatar(
                          radius: 24,
                          backgroundColor: Colors.grey[800],
                          child: Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: icon == selectedCategory
                                  ? Border.all(color: AppColors.yellow1, width: 2)
                                  : null,
                            ),
                            child: Center(
                              child: Text(
                                icon,
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),

            // Routes List
            Expanded(
              child: displayedRoutes.isEmpty
                  ? Center(
                child: Text(
                  'Kaydedilmiş bir rotanız yok',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 16,
                  ),
                ),
              )
                  : ListView.builder(
                itemCount: displayedRoutes.length,
                itemBuilder: (context, index) {
                  final route = displayedRoutes[index];
                  return Container(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.grey[900],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Stack(
                      children: [
                        ListTile(
                          contentPadding: const EdgeInsets.all(12),
                          leading: CircleAvatar(
                            radius: 25,
                            backgroundImage: route.pfpurl!= null
                                ? AssetImage(route.pfpurl!)
                                : null,
                            child: route.pfpurl == null
                                ? const Icon(Icons.person)
                                : null,
                          ),
                          title: Text(
                            route.title ?? "Rota Başlığı",
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                route.description ?? "Açıklama",
                                style: TextStyle(color: Colors.grey[400]),
                              ),
                              const SizedBox(height: 8),
                            ],
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                route.likecount.toString(),
                                style: const TextStyle(color: Colors.white),
                              ),
                              const SizedBox(width: 4),
                              const Icon(
                                Icons.favorite,
                                color: Colors.red,
                              ),
                            ],
                          ),
                        ),
                        Positioned(
                          top: 8,
                          right: 8,
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: Colors.grey[800],
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              route.category ?? "All",
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(right: 8.0, left: 8.0, bottom: 10.0),
        child: Container(
          height: height * 0.08,
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(16.0),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 6.0,
                offset: Offset(0, 6),
              ),
            ],
          ),
          child: CustomNavBar(
            onItemSelected: _onNavBarItemSelected,
            selectedIndex: _selectedIndex,
          ),
        ),
      ),
    );
  }
}