import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:infratrack/components/bottom_navigation.dart';
import 'package:infratrack/model/view_report_model.dart';
import 'package:infratrack/services/problem_page_services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:infratrack/components/MapViewPopup.dart';

class IssuesNearbyScreen extends StatefulWidget {
  final String reportId;
  const IssuesNearbyScreen({super.key, required this.reportId});

  @override
  State<IssuesNearbyScreen> createState() => _IssuesNearbyScreenState();
}

class _IssuesNearbyScreenState extends State<IssuesNearbyScreen> {
  Future<ViewReportsModel>? _reportFuture;

  @override
  void initState() {
    super.initState();
    _loadReport();
  }

  Future<void> _loadReport() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token') ?? "";
    setState(() {
      _reportFuture = ProblemPageServices.getReportById(widget.reportId, token);
    });
  }

  /// Builds a map preview that shows the report location.
  /// When tapped, it opens a read-only full-screen map view.
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
          // Overlay an InkWell to capture taps.
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

  /// Builds a card with report details, each wrapped in its own container.
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

          // Description with more space
          Container(
            height: 150, // Increased height for more description space
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

          // Location
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
                    report.location,
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

          // Map Preview
          _buildMapPreview(report),
        ],
      ),
    );
  }

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
            icon:
                const Icon(Icons.account_circle, color: Colors.black, size: 28),
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
