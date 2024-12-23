import 'package:countries_world_map/data/maps/world_map.dart';
import 'package:flutter/material.dart';
import 'package:milestone/theme/app_theme.dart';
import 'package:milestone/widgets/custom_navbar.dart';
import 'package:countries_world_map/countries_world_map.dart';
import '../widgets/country_selection_modal.dart';
import '../widgets/curved_action_button.dart';
import '../services/map_service.dart';
import '../services/route_service.dart';
import '../theme/colors.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;
  int _visitedCountriesCount = 0;
  int _totalCountriesCount = 150;
  double _visitedPercentage = 0.0;
  bool _isLoading = true;

  final FirestoreService _firestoreService = FirestoreService();
  final RouteService _routeService = RouteService();
  List<Map<String, dynamic>> _visitedCountries = [];

  @override
  void initState() {
    super.initState();
    _fetchCountriesFromFirebase();
  }

  Future<void> _fetchCountriesFromFirebase() async {
    try {
      List<Map<String, dynamic>> countries =
          await _firestoreService.getCountries();
      print("Fetched countries: $countries");
      setState(() {
        _visitedCountries = countries;
        _visitedCountriesCount = countries.length;
        _visitedPercentage =
            (_visitedCountriesCount / _totalCountriesCount) * 100;
        _isLoading = false;
      });
    } catch (e) {
      print("Error fetching countries: $e");
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _testExploreRoutes() async {
    const String testUserId = "test_user_123";
    try {
      await _routeService.getExploreRoutes(userID: testUserId);
    } catch (e) {
      print("Error testing explore routes: $e");
    }
  }

  Future<void> _testOwnedRoutes() async {
    const String testUserId = "test_user_123";
    try {
      await _routeService.getOwnedRoutes(userID: testUserId);
    } catch (e) {
      print("Error testing owned routes: $e");
    }
  }

  void _showCountrySelectionMenu() {
    if (_visitedCountries.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("No countries available for selection")),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (context) => CountrySelectionModal(
        countries: _visitedCountries,
        onCountrySelected: (selectedCountry) {
          print("Selected country: $selectedCountry");
        },
      ),
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
    return Container(
      decoration: const BoxDecoration(gradient: appBackground),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: const Text(
            'milestone',
            style: TextStyle(
              color: AppColors.green1,
              fontWeight: FontWeight.bold,
              fontSize: 24,
            ),
          ),
          actions: [
            IconButton(
              icon: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.green1.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(Icons.explore, color: AppColors.green1),
              ),
              onPressed: _testExploreRoutes,
            ),
            const SizedBox(width: 8),
            IconButton(
              icon: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.green1.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(Icons.route, color: AppColors.green1),
              ),
              onPressed: _testOwnedRoutes,
            ),
            const SizedBox(width: 16),
          ],
        ),
        body: Stack(
          children: [
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _isLoading
                          ? CircularProgressIndicator(color: AppColors.green1)
                          : _buildStatCard(
                              '${_visitedPercentage.toStringAsFixed(1)}%',
                              'Dünya',
                            ),
                      Column(
                        children: [
                          CircleAvatar(
                            radius: 30,
                            backgroundColor: AppColors.yellow1,
                            child: const Icon(
                              Icons.star,
                              color: AppColors.darkgrey1,
                              size: 30,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Çılgın Gezgin',
                            style: TextStyle(
                              color: AppColors.yellow1,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      _isLoading
                          ? CircularProgressIndicator(color: AppColors.green1)
                          : _buildStatCard(
                              '$_visitedCountriesCount/$_totalCountriesCount',
                              'Ülke',
                            ),
                    ],
                  ),
                ),
                Expanded(
                  child: Center(
                    child: InteractiveViewer(
                      child: SimpleMap(
                        instructions: SMapWorld.instructions,
                        defaultColor: AppColors.grey1,
                        colors: {},
                        callback: (id, name, tapdetails) {
                          print(id);
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(bottom: 80),
          child: CurvedFloatingActionButton(
            onPressed: _showCountrySelectionMenu,
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        bottomNavigationBar: CustomNavBar(
          onItemSelected: _onNavBarItemSelected,
          selectedIndex: _selectedIndex,
        ),
      ),
    );
  }

  Widget _buildStatCard(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            color: AppColors.white1,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            color: AppColors.white1.withOpacity(0.7),
            fontSize: 16,
          ),
        ),
      ],
    );
  }
}
