import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../theme/colors.dart';

class GoogleMapWidget extends StatefulWidget {
  final Set<Marker> markers;
  final LatLng initialLocation;
  final Completer<GoogleMapController> mapController;

  const GoogleMapWidget({
    super.key,
    required this.markers,
    required this.initialLocation,
    required this.mapController,
  });

  @override
  _GoogleMapWidgetState createState() => _GoogleMapWidgetState();
}

class _GoogleMapWidgetState extends State<GoogleMapWidget> {
  late Set<Marker> _markers; // Local markers
  late LatLng _selectedLocation; // To track the tapped location
  late GoogleMapController controller;

  @override
  void initState() {
    super.initState();
    _markers = widget.markers; // Initialize with the passed markers
  }

  //For updated position's camera view changing
  Future<void> _cameraToPosition(LatLng pos) async {
    final GoogleMapController controller = await widget.mapController.future;
    CameraPosition _newCameraPosition = CameraPosition(target: pos, zoom: 12);

    await controller
        .animateCamera(CameraUpdate.newCameraPosition(_newCameraPosition));
  }

  //Method for when the map tapped, saving marker and changing camera view.
  void _updateMapLocation(LatLng location, String placeName) {
    setState(() {
      _markers.clear();
      _markers.add(
        Marker(
          markerId: MarkerId(placeName),
          position: location,
          infoWindow: InfoWindow(title: placeName),
        ),
      );
    });
    _cameraToPosition(location);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        myLocationButtonEnabled: false,
        zoomControlsEnabled: false,
        mapType: MapType.hybrid,
        markers: _markers,
        initialCameraPosition: CameraPosition(
          target: widget.initialLocation,
          zoom: 13,
        ),
        onMapCreated: (GoogleMapController controller) {
          widget.mapController
              .complete(controller); // Completer for async access to api
        },
        onTap: (LatLng tappedPoint) {
          print(widget.initialLocation);
          setState(() {
            // Add a new marker at the tapped location
            _selectedLocation = tappedPoint;
            // Store LatLng of tapped location
            _updateMapLocation(_selectedLocation, _selectedLocation.toString());
            //check
            print('updated location is: $_selectedLocation');
            _markers = {
              ..._markers, // Retain existing markers
              //add new marker
              Marker(
                markerId: MarkerId(_selectedLocation.toString()),
                position: tappedPoint,
                icon: BitmapDescriptor.defaultMarkerWithHue(
                    BitmapDescriptor.hueGreen),
                infoWindow: InfoWindow(
                  title: _selectedLocation.toString(),
                  snippet: '${tappedPoint.latitude}, ${tappedPoint.longitude}',
                ),
              ),
            };
          });
          print(
              "Tapped Location: ${tappedPoint.latitude}, ${tappedPoint.longitude}");
        },
      ),
    );
  }
}
