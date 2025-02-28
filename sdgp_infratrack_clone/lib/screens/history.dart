import 'package:flutter/material.dart';
import 'package:infratrack/components/bottom_navigation.dart';

class HistoryScreen extends StatelessWidget {
  final List<Map<String, String>> reportedProblems = [
    {
      "title": "Pothole in Nugegoda",
      "id": "CP123456",
      "priority": "High Priority",
      "status": "In-Progress",
      "priorityColor": "0xFFFF6B6B",
      "statusColor": "0xFFFDBE56",
    },
    {
      "title": "Overgrown Tree in Malabe",
      "id": "CP123487",
      "priority": "Medium Priority",
      "status": "Completed",
      "priorityColor": "0xFFFEDC56",
      "statusColor": "0xFF6BCB77",
    },
    {
      "title": "Pothole in Kollupitiya",
      "id": "CP123489",
      "priority": "High Priority",
      "status": "In-Progress",
      "priorityColor": "0xFFFF6B6B",
      "statusColor": "0xFFFDBE56",
    },
    {
      "title": "Pothole in Bambalapitiya",
      "id": "CP1234675",
      "priority": "Low Priority",
      "status": "Completed",
      "priorityColor": "0xFFFEDC56",
      "statusColor": "0xFF6BCB77",
    },
  ];

  HistoryScreen({Key? key}) : super(key: key);

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
            Navigator.of(context).pop(); // Or handle as needed
          },
        ),
        actions: [
          IconButton(
            icon:
                const Icon(Icons.account_circle, color: Colors.black, size: 28),
            onPressed: () {
              // Handle account icon tap
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: Text(
                "Your Reported Problems",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: reportedProblems.length,
                itemBuilder: (context, index) {
                  final problem = reportedProblems[index];
                  return _buildProblemCard(context, problem);
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigation(
        selectedIndex: 2,
        onItemTapped: (index) {
          // Handle navigation changes
        },
      ),
    );
  }

  Widget _buildProblemCard(BuildContext context, Map<String, String> problem) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      color: const Color(0xFF2C3E50),
      margin: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          // Handle card tap, e.g., navigate to a detail page
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                problem["title"] ?? "",
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                problem["id"] ?? "",
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.white60,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildTag(
                    problem["priority"] ?? "",
                    Color(int.parse(problem["priorityColor"]!)),
                  ),
                  _buildTag(
                    problem["status"] ?? "",
                    Color(int.parse(problem["statusColor"]!)),
                  ),
                  const Icon(Icons.arrow_forward_ios, color: Colors.white),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTag(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
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
