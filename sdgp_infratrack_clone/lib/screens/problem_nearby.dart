import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:infratrack/components/bottom_navigation.dart';
import 'package:infratrack/model/view_report_model.dart';
import 'package:infratrack/services/problem_page_services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:infratrack/components/MapViewPopup.dart';
// 1. Import the geocoding package
import 'package:geocoding/geocoding.dart';

/// A screen that displays detailed information about a specific reported issue.
///
/// This screen fetches the report details based on the `reportId` provided
/// and displays report type, ID, description, location, image, and location map.
///
/// The map preview is interactive and opens a full-screen map when tapped.
class IssuesNearbyScreen extends StatefulWidget {
  /// ID of the report to be fetched and displayed.
  final String reportId;

  /// Creates an instance of [IssuesNearbyScreen].
  const IssuesNearbyScreen({super.key, required this.reportId});

  @override
  State<IssuesNearbyScreen> createState() => _IssuesNearbyScreenState();
}

/// State class for [IssuesNearbyScreen], handling data fetching and UI building.
class _IssuesNearbyScreenState extends State<IssuesNearbyScreen> {
  /// Future holding report data fetched from the backend.
  Future<ViewReportsModel>? _reportFuture;

  /// Holds the human-readable address from latitude/longitude.
  String _locationAddress = "Loading location...";

  @override
  void initState() {
    super.initState();
    _loadReport();
  }

  /// Fetches report details using stored auth token and `reportId`.
  /// Then calls `_getAddressFromLatLng` to set `_locationAddress`.
  Future<void> _loadReport() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token') ?? "";

    setState(() {
      _reportFuture = ProblemPageServices.getReportById(widget.reportId, token);
    });

    // Once the report is fetched, convert its lat/lng to a human-readable address
    _reportFuture?.then((report) {
      _getAddressFromLatLng(report.latitude, report.longitude);
    });
  }

  /// Use the geocoding package to convert lat/lng into a readable address.
  Future<void> _getAddressFromLatLng(double lat, double lng) async {
    try {
      // Fetch placemarks from the geocoding package
      List<Placemark> placemarks = await placemarkFromCoordinates(lat, lng);
      if (placemarks.isNotEmpty) {
        final Placemark place = placemarks.first;
        setState(() {
          _locationAddress = "${place.street}, "
                             "${place.locality}, "
                             "${place.administrativeArea}, "
                             "${place.country}";
        });
      } else {
        setState(() {
          _locationAddress = "Location not found";
        });
      }
    } catch (e) {
      setState(() {
        _locationAddress = "Error finding location";
      });
      debugPrint("Error during reverse geocoding: $e");
    }
  }

  /// Builds a static map preview showing the report location.
  ///
  /// Tapping on the map opens a full-screen read-only map view.
  Widget _buildMapPreview(ViewReportsModel report) {
    final LatLng reportLocation = LatLng(report.latitude, report.longitude);
    return Container(
      height: 180,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.grey[100],
      ),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: GoogleMap(
              initialCameraPosition: CameraPosition(
                target: reportLocation,
                zoom: 14,
              ),
              markers: {
                Marker(
                  markerId: const MarkerId("report-location"),
                  position: reportLocation,
                  draggable: false,
                )
              },
              zoomGesturesEnabled: false,
              scrollGesturesEnabled: false,
              tiltGesturesEnabled: false,
              rotateGesturesEnabled: false,
              onMapCreated: (controller) {},
            ),
          ),
          Positioned.fill(
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          MapViewPopup(initialLocation: reportLocation),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Builds the main card widget displaying all report details.
  Widget _buildIssueCard(ViewReportsModel report) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Report Type
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFE6F1FA),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text(
                report.reportType,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),

          // Report ID
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              "Report ID: ${report.id}",
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
          ),
          const SizedBox(height: 12),

          // Description
          Container(
            height: 150,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(12),
            ),
            child: SingleChildScrollView(
              child: Text(
                report.description,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.black,
                ),
                textAlign: TextAlign.left,
              ),
            ),
          ),
          const SizedBox(height: 12),

          // Location (using our reverse-geocoded address)
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                const Icon(Icons.location_on, size: 18, color: Colors.black54),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    _locationAddress,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // Image (if available)
          if (report.image.isNotEmpty)
            Container(
              height: 180,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.grey[100],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.memory(
                  base64Decode(report.image),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          if (report.image.isNotEmpty) const SizedBox(height: 12),

          // Map preview
          _buildMapPreview(report),
        ],
      ),
    );
  }

  /// Builds the overall UI, handling loading, errors, or displaying report details.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE6F1FA),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pushReplacementNamed(context, "/home");
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.account_circle, color: Colors.black, size: 28),
            onPressed: () {
              Navigator.pushReplacementNamed(context, "/profile");
            },
          ),
        ],
      ),
      body: FutureBuilder<ViewReportsModel>(
        future: _reportFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (!snapshot.hasData) {
            return const Center(child: Text("No report found."));
          } else {
            final report = snapshot.data!;
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: _buildIssueCard(report),
            );
          }
        },
      ),
      bottomNavigationBar: BottomNavigation(
        selectedIndex: 2,
        onItemTapped: (index) {
          if (index == 0) {
            Navigator.pushReplacementNamed(context, "/home");
          } else if (index == 1) {
            Navigator.pushReplacementNamed(context, "/history");
          }
        },
      ),
    );
  }
}
