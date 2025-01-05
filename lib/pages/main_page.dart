import 'package:countries_world_map/data/maps/world_map.dart';
import 'package:flutter/material.dart';
import 'package:milestone/theme/app_theme.dart';
import 'package:milestone/widgets/custom_navbar.dart';
import 'package:countries_world_map/countries_world_map.dart';
import '../widgets/country_selection_modal.dart';
import '../widgets/curved_action_button.dart';
import '../services/map_service.dart';
import '../theme/colors.dart';
import '../widgets/countries.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 4;
  int _visitedCountriesCount = 0;
  int _totalCountriesCount = countries.length;
  double _visitedPercentage = 0.0;
  bool _isLoading = true;

  final FirestoreService _firestoreService = FirestoreService();
  List<Map<String, dynamic>> _visitedCountries = [];

  ValueNotifier<Map<String, Color>> _highlightedCountriesNotifier =
      ValueNotifier<Map<String, Color>>({});

  @override
  void initState() {
    super.initState();
    _fetchCountriesFromDatabase();
  }

  Future<void> _fetchCountriesFromDatabase() async {
    try {
      List<Map<String, dynamic>> visitedCountries =
          await _firestoreService.getVisitedCountries();
      Map<String, Color> highlights = {};

      for (var country in visitedCountries) {
        String countryCode = country['code'] ?? '';
        if (countryCode.isNotEmpty) {
          highlights[countryCode] = AppColors.green1;
        }
      }

      setState(() {
        _visitedCountries = visitedCountries;
        _visitedCountriesCount = visitedCountries.length;
        _visitedPercentage =
            (_visitedCountriesCount / _totalCountriesCount) * 100;
        _highlightedCountriesNotifier.value = highlights;
        _isLoading = false;
      });
    } catch (e) {
      print("Error fetching countries: $e");
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _addCountryToVisited(
      String countryCode, String countryName) async {
    try {
      final countryData = {
        'code': countryCode,
        'name': countryName,
        'visitDate': DateTime.now().toIso8601String(),
      };

      await _firestoreService.addVisitedCountry(countryData);

      setState(() {
        _visitedCountries.add(countryData);
        _highlightedCountriesNotifier.value = {
          ..._highlightedCountriesNotifier.value,
          countryCode: AppColors.green1,
        };
        _visitedCountriesCount = _visitedCountries.length;
        _visitedPercentage =
            (_visitedCountriesCount / _totalCountriesCount) * 100;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content:
                Text('$countryName has been added to your visited countries!')),
      );
    } catch (e) {
      print("Error adding country: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Error adding country. Please try again.')),
      );
    }
  }

  Future<void> _removeCountryFromVisited(String countryCode) async {
    try {
      await _firestoreService.removeVisitedCountry(countryCode);

      setState(() {
        _visitedCountries
            .removeWhere((country) => country['code'] == countryCode);
        final updatedHighlights = {..._highlightedCountriesNotifier.value};
        updatedHighlights.remove(countryCode);
        _highlightedCountriesNotifier.value = updatedHighlights;

        _visitedCountriesCount = _visitedCountries.length;
        _visitedPercentage =
            (_visitedCountriesCount / _totalCountriesCount) * 100;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content:
                Text('Country has been removed from your visited countries.')),
      );
    } catch (e) {
      print("Error removing country: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Error removing country. Please try again.')),
      );
    }
  }

  void _showCountrySelectionMenu() {
    showDialog(
      context: context,
      builder: (context) => CountrySelectionModal(
        countries: countries,
        onCountrySelected: (selectedCountry) {
          final countryCode = selectedCountry['code'] ?? '';
          final countryName = selectedCountry['name'] ?? 'Unknown';

          if (_isCountryVisited(countryCode)) {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text(
                    'Remove $countryName?',
                    style: TextStyle(color: AppColors.green1),
                  ),
                  content: Text(
                    'You have already visited $countryName. Would you like to remove it from your visited countries?',
                    style: TextStyle(color: Colors.white),
                  ),
                  backgroundColor: Colors.black,
                  actions: [
                    TextButton(
                      child: const Text('Cancel',
                          style: TextStyle(color: AppColors.green1)),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                    TextButton(
                      child: const Text('Remove',
                          style: TextStyle(color: AppColors.green1)),
                      onPressed: () {
                        Navigator.of(context).pop();
                        _removeCountryFromVisited(countryCode);
                      },
                    ),
                  ],
                );
              },
            );
          } else {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text(
                    'Add $countryName?',
                    style: TextStyle(color: AppColors.green1),
                  ),
                  content: Text(
                    'Would you like to add $countryName to your visited countries?',
                    style: TextStyle(color: Colors.white),
                  ),
                  backgroundColor: Colors.black,
                  actions: [
                    TextButton(
                      child: const Text('Cancel',
                          style: TextStyle(color: AppColors.green1)),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                    TextButton(
                      child: const Text('Add',
                          style: TextStyle(color: AppColors.green1)),
                      onPressed: () {
                        Navigator.of(context).pop();
                        _addCountryToVisited(countryCode, countryName);
                      },
                    ),
                  ],
                );
              },
            );
          }
        },
        highlightedCountries: _highlightedCountriesNotifier.value,
      ),
    );
  }

  bool _isCountryVisited(String countryCode) {
    return _highlightedCountriesNotifier.value.containsKey(countryCode);
  }

  void _onNavBarItemSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  String _getBadgeAsset() {
    if (_visitedCountriesCount <= 5) {
      return 'assets/rozets/caylak.png';
    } else if (_visitedCountriesCount <= 10) {
      return 'assets/rozets/deneyimli.png';
    } else if (_visitedCountriesCount <= 20) {
      return 'assets/rozets/efsanevi.png';
    } else if (_visitedCountriesCount <= 50) {
      return 'assets/rozets/kasif.png';
    } else if (_visitedCountriesCount <= 100) {
      return 'assets/rozets/maceraci.png';
    } else {
      return 'assets/rozets/merakli.png';
    }
  }

  String _getBadgeLabel() {
    if (_visitedCountriesCount <= 5) {
      return 'Çaylak';
    } else if (_visitedCountriesCount <= 10) {
      return 'Deneyimli';
    } else if (_visitedCountriesCount <= 20) {
      return 'Efsanevi';
    } else if (_visitedCountriesCount <= 50) {
      return 'Kaşif';
    } else if (_visitedCountriesCount <= 100) {
      return 'Maceracı';
    } else {
      return 'Meraklı';
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

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
                              'World',
                            ),
                      Column(
                        children: [
                          CircleAvatar(
                            radius: 40,
                            backgroundColor: AppColors.yellow1,
                            child: _isLoading
                                ? CircularProgressIndicator(
                                    color: AppColors.green1,
                                  )
                                : Image.asset(
                                    _getBadgeAsset(),
                                    fit: BoxFit.cover,
                                  ),
                          ),
                          if (!_isLoading)
                            Text(
                              _getBadgeLabel(),
                              style: const TextStyle(
                                color: AppColors.white1,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                        ],
                      ),
                      _isLoading
                          ? CircularProgressIndicator(color: AppColors.green1)
                          : _buildStatCard(
                              '$_visitedCountriesCount/$_totalCountriesCount',
                              'Countries',
                            ),
                    ],
                  ),
                ),
                Expanded(
                  child: Transform.scale(
                    scale: 1.15,
                    child: Transform.translate(
                      offset: const Offset(-12, -40),
                      child: ValueListenableBuilder<Map<String, Color>>(
                        valueListenable: _highlightedCountriesNotifier,
                        builder: (context, highlightedCountries, child) {
                          return InteractiveViewer(
                            child: SimpleMap(
                              instructions: SMapWorld.instructions,
                              defaultColor: AppColors.grey1,
                              colors: highlightedCountries,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Positioned(
              bottom: 80,
              right: -10,
              child: CurvedFloatingActionButton(
                onPressed: _showCountrySelectionMenu,
                assetPath: 'assets/images/button.png',
              ),
            ),
          ],
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
      ),
    );
  }

  Widget _buildStatCard(String value, String label) {
    return Card(
      color: AppColors.green1,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
        child: Column(
          children: [
            Text(
              value,
              style: TextStyle(
                color: AppColors.white1,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              label,
              style: TextStyle(
                color: AppColors.white1,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
