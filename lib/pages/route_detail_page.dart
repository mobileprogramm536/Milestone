import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import '../calculator/geolocation_calculator.dart';
import '../services/route_service.dart';
import '../theme/app_theme.dart';
import '../theme/colors.dart';
import '../widgets/custom_navbar.dart';
import 'ai_page.dart';

class RouteDetailPage extends StatefulWidget {
  final String routeId;

  const RouteDetailPage({Key? key, required this.routeId}) : super(key: key);

  @override
  _RouteDetailPageState createState() => _RouteDetailPageState();
}

class _RouteDetailPageState extends State<RouteDetailPage> {
  RouteDetail? _routeDetail;
  bool _isLoading = true;
  String _errorMessage = '';
  bool isLiked = false;
  int likes = 0;
  double estimatedTravelTime = 0.0;
  int _selectedIndex = 1;
  RouteCard? routeC = null;

  GeolocationCalculator geolocationCalculator = GeolocationCalculator();

  @override
  void initState() {
    super.initState();
    _fetchRouteDetails();
    RouteService().getRouteCard(widget.routeId).then((element) => {
          setState(() {
            routeC = element;
            likes = routeC!.likecount!;
            isLiked = routeC!.liked!;
          })
        });
  }

  void _onNavBarItemSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });
    print('Selected Index: $index');
  }

  void toggleLike() {
    // Before making the API call, we toggle the like state.
    setState(() {
      isLiked = !isLiked; // Toggle heart state
      likes = isLiked
          ? likes + 1
          : likes - 1; // Update like count immediately on the UI
    });

    // Make the API call to update the like status on the backend
    RouteService().likeRoute(widget.routeId, isLiked).then((_) {
      // After updating the backend, fetch the updated route data (including like count)
      RouteService().getRouteCard(widget.routeId).then((updatedRouteCard) {
        // Ensure the widget is still mounted before calling setState
        if (mounted) {
          setState(() {
            routeC = updatedRouteCard;
            likes = routeC!
                .likecount!; // Update the UI with the correct like count from the backend
          });
        }
      }).catchError((e) {
        print("Error getting updated route card: $e");
      });
    }).catchError((e) {
      print("Error liking route: $e");
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<List<Position>> _convertLocationsToPositions(
      List<dynamic> locations, double speed) async {
    List<Position> positions = [];
    double totalDistance = 0.0; // Variable to hold the total distance

    for (int i = 0; i < locations.length; i++) {
      double latitude = locations[i]["place"].latitude;
      print(latitude);
      double longitude = locations[i]["place"].longitude;
      print(longitude);

      // Get current time as timestamp
      DateTime currentTime = DateTime.now();

      // Add position to the list
      positions.add(Position(
        latitude: latitude,
        longitude: longitude,
        timestamp: currentTime,
        altitude: 0,
        accuracy: 10,
        speed: 0,
        speedAccuracy: 0,
        altitudeAccuracy: 0,
        heading: 0,
        headingAccuracy: 0,
      ));

      // Calculate distance between consecutive points
      if (i > 0) {
        double distance = await Geolocator.distanceBetween(
          positions[i - 1].latitude,
          positions[i - 1].longitude,
          latitude,
          longitude,
        );
        totalDistance += distance; // Add to total distance
        print('Distance between point $i and point ${i - 1}: $distance meters');
      }
    }

    // Calculate the total travel time by dividing total distance by speed (in km/h)
    double travelTime = totalDistance /
        (speed * 1000 / 3600); // Convert speed to meters per second

    print('Total Distance: $totalDistance meters');
    print('Total Travel Time: $travelTime hours');
    return positions;
  }

  Future<void> _fetchRouteDetails() async {
    setState(() {
      _isLoading = true;
    });

    try {
      print(widget.routeId);
      final routeDetail = await RouteService().getRouteDetail(widget.routeId);
      print(routeDetail?.routecard);
      if (routeDetail != null) {
        setState(() {
          _routeDetail = routeDetail;
          isLiked = _routeDetail!.routecard!.liked ?? false;
          likes = _routeDetail!.routecard!.likecount ?? 0;
        });

        List<Position> positions = await _convertLocationsToPositions(
            routeDetail.locations!, 50); // Assuming speed is 50 km/h
        double travelTime = await geolocationCalculator.toplamGeziSuresi(
            positions, 50); // Optional if needed

        setState(() {
          estimatedTravelTime = travelTime;
        });
      } else {
        setState(() {
          _errorMessage = 'Route details could not be loaded.';
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Error fetching route details: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: AppColors.darkgrey2,
      body: Container(
        decoration: BoxDecoration(gradient: appBackground),
        child: _isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : _errorMessage.isNotEmpty
                ? Center(
                    child: Text(
                      _errorMessage,
                      style: const TextStyle(fontSize: 16, color: Colors.red),
                      textAlign: TextAlign.center,
                    ),
                  )
                : _routeDetail == null || _routeDetail!.routecard == null
                    ? const Center(
                        child: Text(
                          'No route details available.',
                          style: TextStyle(fontSize: 16, color: Colors.red),
                        ),
                      )
                    : Container(
                        decoration:
                            const BoxDecoration(gradient: appBackground),
                        child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    height: height * 0.08,
                                  ),
                                  //Profile info
                                  Center(
                                    child: Row(
                                      children: [
                                        SizedBox(
                                          width: width * 0.025,
                                        ),
                                        Padding(
                                          padding: EdgeInsets.all(2.0),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: Colors
                                                  .yellow, // Sarı arka plan rengi
                                              shape: BoxShape
                                                  .circle, // Yuvarlak şekil
                                            ),
                                            padding: EdgeInsets.all(
                                                3.0), // Arka planın boyutunu büyütüyoruz
                                            child: GestureDetector(
                                              onTap: () => {},
                                              child: CircleAvatar(
                                                backgroundImage: AssetImage(
                                                    'assets/images/femaleavatar9.png'),
                                                radius: 30.0, // Avatarın boyutu
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: width * 0.04,
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              '${_routeDetail!.routecard!.username ?? 'Unknown'}',
                                              style: const TextStyle(
                                                color: AppColors.white1,
                                                fontSize: 16,
                                              ),
                                            ),
                                            SizedBox(
                                              height: height * 0.01,
                                            ),
                                            Text(
                                              '${_routeDetail!.ownerfollowercount ?? 0} followers',
                                              style: const TextStyle(
                                                  fontSize: 13,
                                                  color: AppColors.white1),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          width: width * 0.21,
                                        ),
                                        OutlinedButton(
                                          style: OutlinedButton.styleFrom(
                                            side: BorderSide(
                                                color: AppColors.yellow1,
                                                width: 1.5), // Yellow outline
                                            backgroundColor: Colors
                                                .transparent, // Transparent background inside
                                          ),
                                          onPressed:
                                              () {}, // Does nothing when pressed
                                          child: Text(
                                            'follow',
                                            style: TextStyle(
                                                fontSize: 10,
                                                color: AppColors
                                                    .yellow1), // Yellow text color
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  // Route Title
                                  Container(
                                    height: height * 0.6,
                                    padding: EdgeInsets.only(
                                        top: 20, right: 25, left: 25),
                                    margin: EdgeInsets.all(15),
                                    decoration: BoxDecoration(
                                      color: AppColors.grey1,
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Text(
                                                _routeDetail!
                                                        .routecard!.title ??
                                                    'Route Title',
                                                style: const TextStyle(
                                                  fontSize: 24,
                                                  fontWeight: FontWeight.w700,
                                                  color: AppColors.white1,
                                                ),
                                              ),
                                            ),
                                            Row(children: [
                                              Text(
                                                '${likes}',
                                                style: const TextStyle(
                                                  color: AppColors.white1,
                                                  fontSize: 12.0,
                                                ),
                                              ),
                                              IconButton(
                                                onPressed:
                                                    toggleLike, // Action to toggle like
                                                icon: Icon(
                                                  isLiked
                                                      ? Icons.favorite
                                                      : Icons.favorite_border,
                                                  color: isLiked
                                                      ? AppColors.red1
                                                      : AppColors.white1,
                                                  size: 24.0,
                                                ),
                                              ),
                                            ]),
                                          ],
                                        ),
                                        const SizedBox(height: 8),

                                        // Route Description
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Text(
                                                _routeDetail!.routecard!
                                                        .description ??
                                                    'Route Description',
                                                style: const TextStyle(
                                                  fontSize: 16,
                                                  color: AppColors.white1,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 16),
                                        // Destinations and Likes
                                        Text(
                                          'Estimated trip time: ${estimatedTravelTime} hours',
                                          style: const TextStyle(
                                              fontSize: 12,
                                              color: AppColors.white1),
                                        ),
                                        // Locations Section
                                        if (_routeDetail!.locations != null &&
                                            _routeDetail!.locations!.isNotEmpty)
                                          Expanded(
                                            child: Container(
                                              height: height * 0.6,
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Flexible(
                                                    child: ListView.builder(
                                                      shrinkWrap: true,
                                                      itemCount: _routeDetail!
                                                          .locations!.length,
                                                      itemBuilder:
                                                          (context, index) {
                                                        final location =
                                                            _routeDetail!
                                                                    .locations![
                                                                index];
                                                        return SingleChildScrollView(
                                                          child: Container(
                                                              margin:
                                                                  const EdgeInsets
                                                                      .only(
                                                                      bottom:
                                                                          8),
                                                              decoration:
                                                                  const BoxDecoration(
                                                                gradient:
                                                                    LinearGradient(
                                                                  begin: Alignment
                                                                      .topLeft,
                                                                  end: Alignment
                                                                      .bottomRight,
                                                                  colors: [
                                                                    AppColors
                                                                        .yellow1,
                                                                    AppColors
                                                                        .yellow2
                                                                  ],
                                                                ),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .only(
                                                                  topLeft: Radius
                                                                      .circular(
                                                                          80),
                                                                  topRight: Radius
                                                                      .circular(
                                                                          20),
                                                                  bottomLeft: Radius
                                                                      .circular(
                                                                          80),
                                                                  bottomRight: Radius
                                                                      .circular(
                                                                          20),
                                                                ),
                                                              ),
                                                              child: ListTile(
                                                                leading:
                                                                    CircleAvatar(
                                                                  backgroundColor:
                                                                      AppColors
                                                                          .grey1,
                                                                  child: Text(
                                                                    "${index + 1}",
                                                                    style: const TextStyle(
                                                                        color: AppColors
                                                                            .white1,
                                                                        fontWeight:
                                                                            FontWeight.bold),
                                                                  ),
                                                                ),
                                                                title: Text(
                                                                    location[
                                                                            'name'] ??
                                                                        '',
                                                                    style: TextStyle(
                                                                        color: AppColors
                                                                            .grey1,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .bold,
                                                                        fontSize:
                                                                            16)),
                                                                subtitle: Text(
                                                                    location[
                                                                            'note'] ??
                                                                        '',
                                                                    style: TextStyle(
                                                                        color: AppColors
                                                                            .grey1,
                                                                        fontSize:
                                                                            14)),
                                                              )),
                                                        );
                                                      },
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          )
                                        else
                                          const Center(
                                            child:
                                                Text('No locations available.'),
                                          ),
                                      ],
                                    ),
                                  ),
                                  Center(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        OutlinedButton(
                                          onPressed: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => AiPage(),
                                              ),
                                            );
                                          },
                                          style: OutlinedButton.styleFrom(
                                            side: BorderSide(
                                                color: AppColors.green1,
                                                width: 2), // Yellow outline
                                            backgroundColor: Colors
                                                .transparent, // Transparent background inside

                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 20, vertical: 15),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                          ),
                                          child: Row(
                                            children: [
                                              Icon(
                                                Icons.stars,
                                                color: AppColors.green1,
                                              ),
                                              SizedBox(
                                                width: width * 0.01,
                                              ),
                                              Text(
                                                'Ask AI',
                                                style: TextStyle(
                                                    fontSize: 15,
                                                    color: AppColors.green1),
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          width: width * 0.2,
                                        ),
                                        ElevatedButton(
                                          onPressed: () {
                                            RouteService()
                                                .saveRoute(widget.routeId);
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: AppColors
                                                .green1, // Butonun arka plan rengi
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      10), // Kenar yuvarlama
                                            ),
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 20,
                                                vertical:
                                                    14), // Buton içi boşluk
                                          ),
                                          child: Row(
                                            children: [
                                              Icon(
                                                Icons.bookmark_add_outlined,
                                                color: AppColors.white1,
                                              ),
                                              SizedBox(
                                                width: width * 0.01,
                                              ),
                                              Text(
                                                'Kaydet',
                                                style: TextStyle(
                                                    fontSize: 15,
                                                    color: AppColors.white1),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                ])),
                      ),
      ),
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
    );
  }
}
