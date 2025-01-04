import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GoogleMapWidget extends StatefulWidget {
  const GoogleMapWidget({super.key});

  @override
  _GoogleMapWidgetState createState() => _GoogleMapWidgetState();
}

class _GoogleMapWidgetState extends State<GoogleMapWidget> {
  late GoogleMapController mapController;

  // Google Map için başlangıç konumu
  final CameraPosition _initialCameraPosition = const CameraPosition(
    target: LatLng(37.7749, -122.4194), // Örnek koordinat: San Francisco
    zoom: 12,
  );

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      initialCameraPosition: _initialCameraPosition,
      onMapCreated: (GoogleMapController controller) {
        mapController = controller;
      },
      markers: const <Marker>{}, // Marker'ları burada ekleyebilirsiniz
    );
  }
}
