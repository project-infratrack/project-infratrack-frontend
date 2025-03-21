import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:infratrack/model/view_report_model.dart';
import 'package:infratrack/services/reported_pages_services.dart';
import 'package:infratrack/components/bottom_navigation.dart';
import 'package:infratrack/components/MapViewPopup.dart';

class ProblemPageReportedScreen extends StatefulWidget {
  final String reportId; // Pass reportId dynamically

  const ProblemPageReportedScreen({super.key, required this.reportId});

  @override
  State<ProblemPageReportedScreen> createState() => _ProblemPageReportedScreenState();
}

class _ProblemPageReportedScreenState extends State<ProblemPageReportedScreen> {
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
      _reportFuture = ReportedPagesServices.getReportById(widget.reportId, token);
    });
  }

  Widget _buildMapPreview(ViewReportsModel report) {
    final LatLng reportLocation = LatLng(report.latitude, report.longitude);
    return Container(
      height: 180,
      width: double.infinity,
      child: Stack(
        children: [
          GoogleMap(
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
          Positioned.fill(
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MapViewPopup(initialLocation: reportLocation),
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

  Widget _buildIssueCard(ViewReportsModel report) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              report.reportType,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
                shadows: [
                  Shadow(color: Colors.black12, offset: Offset(2, 2), blurRadius: 3),
                ],
              ),
            ),
            const SizedBox(height: 4),
            Text(
              "Complaint ID: ${report.id}",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 16),

            // Decoded image
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

            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Text(
                report.description,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.justify,
              ),
            ),
            const SizedBox(height: 16),
            _buildMapPreview(report),
            const SizedBox(height: 16),

            // Priority & Status tags
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildTag(
                  report.priorityLevel,
                  const Color(0xFFFF6B6B), // Red color (customizable based on level)
                ),
                const SizedBox(width: 8),
                _buildTag(
                  report.status,
                  const Color(0xFFFDBE56), // Yellow color (customizable)
                ),
              ],
            ),
          ],
        ),
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
