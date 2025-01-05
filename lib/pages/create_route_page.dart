import 'dart:async';
import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:milestone/textfields/route_text_field.dart';
import 'package:milestone/theme/colors.dart';
import 'package:milestone/widgets/google_maps_widget.dart';
import '../services/auth_service.dart';
import '../widgets/custom_navbar.dart';
import '../widgets/place_item.dart';
import '../services/route_service.dart';
import '../theme/app_theme.dart';
import '../widgets/searchBarMaps.dart';

class CreateRoutePage extends StatefulWidget {
  @override
  _CreateRoutePageState createState() => _CreateRoutePageState();
}

class _CreateRoutePageState extends State<CreateRoutePage> {
  int _selectedIndex = 0;
  final List<TextEditingController> _controllers = [];
  final List<TextEditingController> _noteControllers = [];
  final _routecontroller_name = TextEditingController();
  final _routecontroller_desc = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final Completer<GoogleMapController> _mapController =
      Completer<GoogleMapController>();
  late LatLng _selectedLocation; // Track selected location
  Set<Marker> _markers = {};
  final List<LatLng?> places = [];
  final List<GeoPoint> geoPoints = [];

  @override
  void initState() {
    super.initState();
    _selectedLocation = LatLng(41.0082, 28.9784); // Default to Istanbul
    _addPlace(); //first route field
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _onNavBarItemSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });
    print('Selected Index: $index');
  }

  // Method for adding extra route fields
  void _addPlace() {
    setState(() {
      _controllers.add(TextEditingController());
      _noteControllers.add(TextEditingController());
      places.add(null);

      // Scroll slightly when a new item is added
      Future.delayed(Duration(milliseconds: 100), () {
        double targetPosition = _scrollController.position.maxScrollExtent + 2;
        _scrollController.animateTo(
          targetPosition,
          duration: Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      });
    });
  }

  //Method for save route field to firestore
  void createRoute() {
    final routeName = _routecontroller_name.text;
    final description = _routecontroller_desc.text;
    final routeUsername = AuthService().user?.uid;
    final likecount = 0;

    if (routeUsername == null) {
      print("Error: User is not authenticated.");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please log in to create a route.'),
        ),
      );
      return;
    }

    print("Authenticated user UID: $routeUsername");

    List<Map<String, dynamic>> locations = [];
    for (int i = 0; i < _controllers.length - 1; i++) {
      if (_controllers[i].text.isEmpty || places[i] == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Please fill in all fields and add locations'),
          ),
        );
        return;
      }

      // Get the latitude and longitude with higher precision
      double preciseLatitude = double.parse(
          places[i]!.latitude.toStringAsFixed(9)); // 9 decimal places
      double preciseLongitude = double.parse(
          places[i]!.longitude.toStringAsFixed(9)); // 9 decimal places

      locations.add({
        'name': _controllers[i].text,
        'note': _noteControllers[i].text,
        'place': GeoPoint(
            preciseLatitude, preciseLongitude), // Store the precise values
      });
    }

    // Call the RouteService to create the route
    RouteService().createRoute(
      likecount: likecount,
      routeUser: routeUsername,
      routeName: routeName,
      routeDescription: description,
      locations: locations,
    );
  }

  //Method to save selected place to place list
  void _savePlace(LatLng location, int index) {
    setState(() {
      if (index < places.length) {
        places[index] = location;
      }
    });
    print("place saved: $location");
  }

  //Method that put marker to selected place from search bar
  void _onPlaceSelected(LatLng location, String placeName) {
    setState(() {
      _selectedLocation = location;
      _markers = {
        Marker(
          markerId: MarkerId(placeName),
          position: location,
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
          infoWindow: InfoWindow(
            title: placeName,
            snippet: "${location.latitude}, ${location.longitude}",
          ),
        ),
      };

      print("this is selected from search bar: $_selectedLocation");
    });
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Container(
      decoration: const BoxDecoration(gradient: appBackground),
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Stack(children: [
            Positioned(
                top: height * 0.07,
                left: width * 0.1,
                right: width * 0.1,
                child: MapsSearchBar(
                    mapController: _mapController,
                    onPlaceSelected:
                        _onPlaceSelected)), //controller and selected place communication from searchbar
            Positioned(
              top: height * 0.15,
              left: width * 0.1,
              right: width * 0.1,
              child: Container(
                height: height * 0.25, // Adjust the height to fit your design
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20), // Rounded edges
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius:
                      BorderRadius.circular(20), // Rounded corners for map
                  child: GoogleMapWidget(
                    mapController: _mapController,
                    markers: _markers,
                    initialLocation: _selectedLocation,
                  ),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: height * 0.41, left: 20, right: 20),
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.grey1,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(50),
                  topRight: Radius.circular(50),
                ),
              ),
              child: Column(
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  RouteTextField(
                      controller: _routecontroller_name,
                      text: "Rotanızın adı..."),
                  SizedBox(height: 8),
                  RouteTextField(
                      controller: _routecontroller_desc,
                      text: "Rotanızı tanıtın..."),
                  SizedBox(height: 5),
                  Flexible(
                    child: ListView.builder(
                      controller: _scrollController,
                      itemCount: _controllers.length,
                      itemBuilder: (context, index) {
                        bool canShow = true;
                        for (int i = 0; i <= index; i++) {
                          if (_controllers[i].text.isEmpty) {
                            canShow = false;
                            break;
                          }
                        }
                        return AnimatedOpacity(
                          duration: Duration(milliseconds: 300),
                          opacity: canShow ? 1.0 : 0.5,
                          child: PlaceItem(
                            onSaveLocation: (LatLng? location) {
                              _savePlace(location ?? _selectedLocation,
                                  index); // Pass the location and index
                            },
                            isLastItem: index == _controllers.length - 1,
                            totalItems: _controllers.length,
                            onDelete: () {
                              setState(() {
                                _controllers.removeAt(index);
                              });
                            },
                            index: index + 1,
                            controller: _controllers[index],
                            noteController: _noteControllers[index],
                            onChanged: (value, note) {
                              setState(() {
                                if (value.isNotEmpty &&
                                    index == _controllers.length - 1) {
                                  _addPlace();
                                }
                                if (value.isEmpty &&
                                    index < _controllers.length - 1) {
                                  for (int i = index;
                                      i < _controllers.length - 1;
                                      i++) {
                                    _controllers[i].text =
                                        _controllers[i + 1].text;
                                  }
                                  _controllers.removeLast();
                                }
                              });
                            },
                            isVisible: true,
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      SizedBox(
                        width: width * 0.50,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          createRoute();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.green1,
                          padding: EdgeInsets.symmetric(
                              vertical: 10, horizontal: 30),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: Text("oluştur",
                            style: TextStyle(
                                fontSize: 14,
                                color: AppColors.white1,
                                fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ]),
          bottomNavigationBar: Padding(
            padding: const EdgeInsets.only(right: 8.0, left: 8.0, bottom: 10.0),
            child: Container(
              height: height * 0.08, // Reduced height for a sleeker design
              decoration: BoxDecoration(
                color: Colors.transparent,
                // Replace with AppColors if needed
                borderRadius: BorderRadius.circular(16.0), // Rounded corners
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 6.0,
                    offset: Offset(0, 6), // Subtle shadow effect
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
      ),
    );
  }
}
