import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapViewPopup extends StatelessWidget {
  final LatLng initialLocation;
  const MapViewPopup({Key? key, required this.initialLocation}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("View Location"),
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(target: initialLocation, zoom: 14),
        markers: {
          Marker(
            markerId: const MarkerId("report-location"),
            position: initialLocation,
            draggable: false,
          ),
        },
        // Enable user interaction for panning/zooming.
        zoomGesturesEnabled: true,
        scrollGesturesEnabled: true,
        tiltGesturesEnabled: false,
        rotateGesturesEnabled: false,
      ),
    );
  }
}
