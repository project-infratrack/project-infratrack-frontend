import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:infratrack/components/bottom_navigation.dart';
import 'package:infratrack/model/view_report_model.dart';
import 'package:infratrack/services/reported_pages_services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:infratrack/components/MapViewPopup.dart';

/// Screen that displays detailed information of a previously reported issue.
///
/// The [ProblemPageReportedScreen] fetches and shows information such as:
/// - Report type
/// - Complaint ID
/// - Description
/// - Location
/// - Priority level and status
/// - Associated image
/// - Static map preview with location pin
///
/// The report is fetched using the [reportId] passed to the screen.
class ProblemPageReportedScreen extends StatefulWidget {
  /// Unique ID of the report to be displayed.
  final String reportId;

  /// Creates an instance of [ProblemPageReportedScreen].
  const ProblemPageReportedScreen({super.key, required this.reportId});

  @override
  State<ProblemPageReportedScreen> createState() =>
      _ProblemPageReportedScreenState();
}

/// State class responsible for data fetching and UI rendering for [ProblemPageReportedScreen].
class _ProblemPageReportedScreenState extends State<ProblemPageReportedScreen> {
  /// Holds the fetched report details from the backend.
  Future<ViewReportsModel>? _reportFuture;

  @override
  void initState() {
    super.initState();
    _loadReport();
  }

  /// Loads the specific report data using stored auth token and the report ID.
  Future<void> _loadReport() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token') ?? "";
    setState(() {
      _reportFuture =
          ReportedPagesServices.getReportById(widget.reportId, token);
    });
  }

  /// Builds a map preview showing the location of the report.
  ///
  /// Tapping the preview opens a full-screen map in read-only mode.
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

  /// Builds the main issue card displaying all report details including image, type, status.
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
                  color: Colors.black87,
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
              "Complaint ID: ${report.id}",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade600,
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
                  color: Colors.black87,
                ),
                textAlign: TextAlign.justify,
              ),
            ),
          ),
          const SizedBox(height: 12),

          // Image Display (if available)
          report.image.isNotEmpty
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.memory(
                    base64Decode(report.image),
                    height: 180,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                )
              : Container(),
          const SizedBox(height: 12),

          // Map Preview
          _buildMapPreview(report),
          const SizedBox(height: 12),

          // Priority & Status Tags
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildTag(report.priorityLevel, const Color(0xFFFF6B6B)),
              const SizedBox(width: 8),
              _buildTag(report.status, const Color(0xFFFDBE56)),
            ],
          ),
        ],
      ),
    );
  }

  /// Builds a styled tag widget to display status or priority.
  Widget _buildTag(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.3),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  /// Main UI builder handling report loading, errors, or data display.
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
            Navigator.pushReplacementNamed(context, "/history");
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.account_circle, color: Colors.black, size: 28),
            onPressed: () {},
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
