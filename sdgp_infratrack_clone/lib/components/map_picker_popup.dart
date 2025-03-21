import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class MapPickerPopup extends StatefulWidget {
  final LatLng initialLocation;
  const MapPickerPopup({super.key, required this.initialLocation});

  @override
  State<MapPickerPopup> createState() => _MapPickerPopupState();
}

class _MapPickerPopupState extends State<MapPickerPopup> {
  late LatLng _pickedLocation;
  GoogleMapController? _mapController;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _pickedLocation = widget.initialLocation;
  }

  /// Checks or requests location permission and returns true if granted.
  Future<bool> _ensureLocationPermission() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Location services are disabled.")),
      );
      return false;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Location permission denied.")),
      );
      return false;
    }

    return true;
  }

  /// Centers the map on the user's current location if permission is granted.
  Future<void> _goToCurrentLocation() async {
    final hasPermission = await _ensureLocationPermission();
    if (!hasPermission) return;

    // Get current position
    final position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    final currentLatLng = LatLng(position.latitude, position.longitude);

    setState(() {
      _pickedLocation = currentLatLng;
    });

    _mapController?.animateCamera(
      CameraUpdate.newLatLngZoom(currentLatLng, 16),
    );
  }

  Future<void> _searchLocation() async {
    final query = _searchController.text.trim();
    if (query.isNotEmpty) {
      try {
        List<Location> locations = await locationFromAddress(query);
        if (locations.isNotEmpty) {
          final first = locations.first;
          final newLatLng = LatLng(first.latitude, first.longitude);
          setState(() {
            _pickedLocation = newLatLng;
          });
          _mapController?.animateCamera(CameraUpdate.newLatLng(newLatLng));
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Location not found.")),
        );
      }
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // AppBar with a search TextField
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          decoration: const InputDecoration(
            hintText: "Search location",
            border: InputBorder.none,
          ),
          style: const TextStyle(color: Colors.black),
          onSubmitted: (_) => _searchLocation(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: _searchLocation,
          ),
        ],
      ),

      // Main body with Google Map
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: _pickedLocation,
          zoom: 14,
        ),
        onMapCreated: (controller) {
          _mapController = controller;
        },
        onTap: (latLng) {
          setState(() {
            _pickedLocation = latLng;
          });
        },
        markers: {
          Marker(
            markerId: const MarkerId('picked-location'),
            position: _pickedLocation,
            draggable: true,
            onDragEnd: (newPosition) {
              setState(() {
                _pickedLocation = newPosition;
              });
            },
          ),
        },
        myLocationEnabled: true,
        myLocationButtonEnabled: false, // We'll provide our own FAB for this
      ),

      // FloatingActionButton for current location
      floatingActionButton: FloatingActionButton(
        onPressed: _goToCurrentLocation,
        backgroundColor: Colors.black,
        child: const Icon(Icons.my_location, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniStartFloat,

      // Bottom button to return the selected location
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        child: ElevatedButton(
          onPressed: () {
            Navigator.pop(context, _pickedLocation);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            padding: const EdgeInsets.symmetric(vertical: 16),
          ),
          child: const Text(
            "Select Location",
            style: TextStyle(fontSize: 16, color: Colors.white),
          ),
        ),
      ),
    );
  }
}
