import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../services/route_service.dart';
import '../theme/colors.dart';

class RouteDetailPage extends StatefulWidget {
  final String routeId;

  const RouteDetailPage({Key? key, required this.routeId}) : super(key: key);

  @override
  _RouteDetailPageState createState() => _RouteDetailPageState();
}

class _RouteDetailPageState extends State<RouteDetailPage> {
  RouteDetail? _routeDetail;
  bool _isLoading = true;
  final Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    _fetchRouteDetails();
  }

  Future<void> _fetchRouteDetails() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final routeDetail = await RouteService().getRouteDetail(widget.routeId);

      if (routeDetail != null) {
        setState(() {
          _routeDetail = routeDetail;

          // Add markers for each location

          for (var i = 0; i < routeDetail.locations!.length; i++) {
            final location = routeDetail.locations![i];
            final place = location['place'] as GeoPoint;
          }
        });
      }
    } catch (e) {
      print("Error fetching route details: $e");
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
      appBar: AppBar(
        title: const Text('Route Details'),
        backgroundColor: AppColors.green1,
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : _routeDetail == null
              ? const Center(
                  child: Text('Route details could not be loaded.'),
                )
              : SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Map Section
                      // Route Details Section
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _routeDetail!.routecard!.title ?? 'Route Title',
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              _routeDetail!.routecard!.description ??
                                  'Route Description',
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.grey,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Destinations: ${_routeDetail!.routecard!.destinationcount}',
                                  style: const TextStyle(fontSize: 16),
                                ),
                                Text(
                                  'Likes: ${_routeDetail!.routecard!.likecount}',
                                  style: const TextStyle(fontSize: 16),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Created by: ${_routeDetail!.routecard!.username}',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Followers: ${_routeDetail!.ownerfollowercount}',
                              style: const TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                      const Divider(),

                      // Locations Section
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Locations:',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: _routeDetail!.locations!.length,
                              itemBuilder: (context, index) {
                                final location =
                                    _routeDetail!.locations![index];
                                return ListTile(
                                  leading: const Icon(Icons.location_on),
                                  title: Text(location['name']),
                                  subtitle: Text(location['note']),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
    );
  }
}
