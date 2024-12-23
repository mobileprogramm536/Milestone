import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:milestone/api_ignore.dart';

class MapsSearchBar extends StatefulWidget {
  final Function(LatLng, String) onPlaceSelected;
  final Completer<GoogleMapController> mapController;

  const MapsSearchBar(
      {super.key, required this.onPlaceSelected, required this.mapController});

  @override
  State<MapsSearchBar> createState() => _MapsSearchBarState();
}

class _MapsSearchBarState extends State<MapsSearchBar> {
  final String _googleApiKey = GOOGLE_MAPS_API;
  // Default to Rome
  String _selectedPlaceName = "Search for a location...";
  late final GoogleMapsPlaces _places;

  @override
  void initState() {
    super.initState();
    _places = GoogleMapsPlaces(apiKey: GOOGLE_MAPS_API);
  }

  Future<void> _updateSelectedPlace(Prediction? prediction) async {
    if (prediction != null) {
      final placeId = prediction.placeId;
      if (placeId != null) {
        // Fetch place details using the place ID
        PlacesDetailsResponse details =
            await _places.getDetailsByPlaceId(placeId);
        final lat = details.result.geometry!.location.lat;
        final lng = details.result.geometry!.location.lng;
        final placeName = details.result.name;

        // Update the search bar text
        setState(() {
          _selectedPlaceName = placeName;
        });

        // Pass the coordinates and name to the parent widget
        widget.onPlaceSelected(LatLng(lat, lng), placeName);
      }
    }
  }

  Future<void> displayPrediction(Prediction p) async {
    final GoogleMapController controller = await widget.mapController.future;
    if (p.placeId != null) {
      // Get detailed information about the selected place
      PlacesDetailsResponse detail =
          await _places.getDetailsByPlaceId(p.placeId!);

      final lat = detail.result.geometry!.location.lat;
      final lng = detail.result.geometry!.location.lng;
      final placeName = detail.result.name;

      setState(() {
        widget.onPlaceSelected(LatLng(lat, lng), placeName);
      });

      // Move the camera to the selected location
      controller.animateCamera(
        CameraUpdate.newLatLngZoom(LatLng(lat, lng), 12.0),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: GestureDetector(
        onTap: () async {
          Prediction? prediction = await PlacesAutocomplete.show(
            context: context,
            apiKey: _googleApiKey,
            radius: 10000000,
            types: [],
            logo: const SizedBox.shrink(),
            strictbounds: false,
            // Can also use Mode.fullscreen
            language: "en",
            components: [
              Component(Component.country, "us"),
              Component(Component.country, "fr"),
              Component(Component.country, "in"),
              Component(Component.country, "UK")
            ],
            // Add below to avoid layout issues
            hint: "Search for a place",
          );

          if (prediction != null) {
            await _updateSelectedPlace(prediction);
            await displayPrediction(prediction);
          }
        },
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 6,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            children: [
              Icon(Icons.search, color: Colors.grey),
              SizedBox(width: 10),
              Text(
                _selectedPlaceName,
                style: TextStyle(color: Colors.grey, fontSize: 16),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
