import 'package:flutter/material.dart';
import 'package:milestone/pages/route_detail_page.dart';
import '../services/route_service.dart';
import '../theme/colors.dart';
import '../widgets/custom_navbar.dart';

class SavedRoutesPage extends StatefulWidget {
  const SavedRoutesPage({Key? key}) : super(key: key);

  @override
  State<SavedRoutesPage> createState() => _SavedRoutesPageState();
}

class _SavedRoutesPageState extends State<SavedRoutesPage> {
  List<Map<String, dynamic>> savedRoutes = [];
  List<Map<String, dynamic>> displayedRoutes = [];
  List<String> collectionIcons = [
    "All", // Show all saved routes
    "🏕", // Kamp Çadırı
    "🏞", // Doğa Manzarası
    "🗺", // Harita
    "🧭", // Pusula
  ];

  String selectedCategory = "All"; // Add this to track selected category
  int _selectedIndex = 2; // 2 for saved routes tab
  List<String> routeIds = []; // Add this line to store route IDs

  // Kullanıcı özel kategoriler
  Map<String, List<String>> userCollectionIcons = {};

  @override
  void initState() {
    super.initState();
    fetchSavedRoutes();
  }

  Future<void> fetchSavedRoutes() async {
    final routeService = RouteService();

    List<Map<String, dynamic>> routes = await routeService.getSavedRoutes();

    print('Fetched routes: $routes');

    setState(() {
      savedRoutes = routes;
      _filterRoutesByCategory("All");
    });
  }

  void _filterRoutesByCategory(String category) {
    setState(() {
      selectedCategory = category;
      if (category == "All") {
        displayedRoutes = List.from(savedRoutes);
      } else {
        displayedRoutes = savedRoutes
            .where((route) => route['category'] == category)
            .toList();
      }
    });
  }

  void _addNewCategory() {
    showDialog(
      context: context,
      builder: (context) {
        String newCategory = "";
        return AlertDialog(
          title: const Text("Yeni Kategori Oluştur"),
          content: TextField(
            onChanged: (value) {
              newCategory = value;
            },
            decoration: const InputDecoration(hintText: "Kategori Adı"),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close dialog
              },
              child: const Text("İptal"),
            ),
            TextButton(
              onPressed: () {
                if (newCategory.isNotEmpty) {
                  setState(() {
                    collectionIcons.add(newCategory);
                  });
                }
                Navigator.pop(context); // Close dialog
              },
              child: const Text("Ekle"),
            ),
          ],
        );
      },
    );
  }

  void _addCategoryToRoute(String routeId, String category) async {
    try {
      final routeService = RouteService();
      await routeService.updateRouteCategory(routeId, category);

      // Refresh the routes list to show the updated category
      await fetchSavedRoutes();
    } catch (e) {
      print('Error adding category to route: $e');
      // Optionally show an error message to the user
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Kategori güncellenirken bir hata oluştu')),
      );
    }
  }

  void _removeCategoryFromRoute(String routeId, String category) {
    setState(() {
      userCollectionIcons[category]?.remove(routeId);
      if (userCollectionIcons[category]?.isEmpty ?? false) {
        userCollectionIcons.remove(category);
      }
    });
  }

  Future<void> _showCategorySelectionDialog(String routeId) async {
    String selectedCategory = "All";

    await showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              backgroundColor: AppColors.darkgrey1,
              title: const Text(
                "Kategori Seçin",
                style: TextStyle(color: Colors.white),
              ),
              content: DropdownButton<String>(
                value: selectedCategory,
                dropdownColor: AppColors.darkgrey1,
                style: const TextStyle(color: Colors.white),
                onChanged: (value) {
                  setState(() {
                    selectedCategory = value!;
                  });
                },
                items: collectionIcons.map((icon) {
                  return DropdownMenuItem(
                    value: icon,
                    child: Text(icon),
                  );
                }).toList(),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("İptal",
                      style: TextStyle(color: Colors.white)),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    if (selectedCategory.isNotEmpty) {
                      _addCategoryToRoute(routeId, selectedCategory);
                    }
                  },
                  child:
                      const Text("Ekle", style: TextStyle(color: Colors.white)),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _onNavBarItemSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });
    print('Selected Index: $index');
  }

  @override
  Widget build(BuildContext context) {
    final height =
        MediaQuery.of(context).size.height; // Add this for height calculation

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
                    children: [
                      ...collectionIcons.map((icon) {
                        return GestureDetector(
                          onTap: () => _filterRoutesByCategory(icon),
                          child: CircleAvatar(
                            radius: 24,
                            backgroundColor: Colors.grey[800],
                            child: Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: icon == selectedCategory
                                    ? Border.all(
                                        color: AppColors.yellow1, width: 2)
                                    : null,
                              ),
                              child: Center(
                                child: Text(
                                  icon,
                                  style: const TextStyle(
                                    fontSize: 20,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                      GestureDetector(
                        onTap: _addNewCategory,
                        child: CircleAvatar(
                          radius: 24,
                          backgroundColor: Colors.grey[800],
                          child: const Icon(
                            Icons.add,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
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
                          child: GestureDetector(
                            onLongPress: () =>
                                _showCategorySelectionDialog(route['routeId']),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => RouteDetailPage(
                                      routeId: route['routeId']),
                                ),
                              );
                            },
                            child: Stack(
                              children: [
                                ListTile(
                                  contentPadding: const EdgeInsets.all(12),
                                  leading: CircleAvatar(
                                    radius: 25,
                                    backgroundImage: route['routeUser'] != null
                                        ? AssetImage(route['pfpurl'])
                                        : null,
                                    child: route['pfpurl'] == null
                                        ? const Icon(Icons.person)
                                        : null,
                                  ),
                                  title: Text(
                                    route['routeName'] ?? "Rota Başlığı",
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  subtitle: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        route['description'] ?? "Açıklama",
                                        style:
                                            TextStyle(color: Colors.grey[400]),
                                      ),
                                      const SizedBox(height: 8),
                                    ],
                                  ),
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        (route['likecount'] ?? 0).toString(),
                                        style: const TextStyle(
                                            color: Colors.white),
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
                                  child: route['category'] != null &&
                                          route['category'] != "All"
                                      ? Container(
                                          padding: const EdgeInsets.all(4),
                                          decoration: BoxDecoration(
                                            color: Colors.grey[800],
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                          child: Text(
                                            route['category'],
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 20,
                                            ),
                                          ),
                                        )
                                      : Container(), // Empty container if no category or "All"
                                ),
                              ],
                            ),
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
