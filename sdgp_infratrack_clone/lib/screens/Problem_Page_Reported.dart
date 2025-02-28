import 'package:flutter/material.dart';
import 'package:infratrack/components/bottom_navigation.dart';

class ProblemPageReportedScreen extends StatelessWidget {
  const ProblemPageReportedScreen({super.key});

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
            icon:
                const Icon(Icons.account_circle, color: Colors.black, size: 28),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _buildIssueCard(),
          ],
        ),
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

  Widget _buildIssueCard() {
    return Card(
      // 2. Elevated Card with rounded corners
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      // 3. Card margin for spacing from screen edges
      margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Title
            const Text(
              "Pothole in Nugegoda",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
                shadows: [
                  Shadow(
                    color: Colors.black12,
                    offset: Offset(2, 2),
                    blurRadius: 3,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 4),

            // Complaint ID
            Text(
              "Complaint ID: CP123456",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 16),

            // Main image
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                'assets/png/pothole.png',
                height: 180,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 16),

            // Description
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.0),
              child: Text(
                "Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, "
                "when an unknown printer took a galley of type and scrambled it to make a type specimen book. "
                "It has survived not only five centuries, but also the leap into electronic typesetting, "
                "remaining essentially unchanged.",
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.justify,
              ),
            ),
            const SizedBox(height: 16),

            // Map image
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                'assets/png/map_placeholder.png',
                height: 180,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 16),

            // Priority & Status Tags
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildTag("High Priority", const Color(0xFFFF6B6B)),
                const SizedBox(width: 8),
                _buildTag("In-Progress", const Color(0xFFFDBE56)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // 4. Build a pill-shaped tag with a subtle drop shadow
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
}
