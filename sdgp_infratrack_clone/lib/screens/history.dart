import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:infratrack/model/history_report_model.dart';
import 'package:infratrack/services/history_services.dart';
import '../components/bottom_navigation.dart'; // Your BottomNavigation widget

/// A screen that displays a list of the user's reported problems.
///
/// This screen retrieves the user's report history from the server using the saved
/// authentication token. If no token is found or it is invalid, the user is redirected
/// to the login screen.
class HistoryScreen extends StatefulWidget {
  /// Creates an instance of [HistoryScreen].
  const HistoryScreen({super.key});

  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

/// The state for [HistoryScreen] that handles fetching and displaying user reports.
class _HistoryScreenState extends State<HistoryScreen> {
  Future<List<HistoryReportModel>>? _userReports;
  String? _token;

  @override
  void initState() {
    super.initState();
    _loadTokenAndFetchReports();
  }

  /// Loads the authentication token from shared preferences and fetches user reports.
  ///
  /// If the token is null or empty, navigates to the login screen.
  Future<void> _loadTokenAndFetchReports() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');

    if (token == null || token.isEmpty) {
      Navigator.pushReplacementNamed(context, "/login");
      return;
    }

    setState(() {
      _token = token;
      _userReports = HistoryServices.getUserReports(_token!);
    });
  }

  /// Builds the UI for the HistoryScreen.
  ///
  /// Displays the user's report history if available. Shows a loading indicator while fetching data,
  /// an error message if something goes wrong, or an empty state if there are no reports.
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
              child: RefreshIndicator(
                onRefresh: _loadTokenAndFetchReports,
                child: FutureBuilder<List<HistoryReportModel>>(
                  future: _userReports,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return _buildEmptyState(
                        "Something went wrong!",
                        "Please check your connection or try again later.",
                      );
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      // User hasn't submitted any reports
                      return _buildEmptyState(
                        "No Reports Found",
                        "You haven't reported any problems yet.",
                      );
                    } else {
                      final reports = snapshot.data!;
                      return ListView.builder(
                        itemCount: reports.length,
                        itemBuilder: (context, index) {
                          final report = reports[index];
                          return _buildProblemCard(context, report);
                        },
                      );
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigation(
        selectedIndex: 1,
        onItemTapped: (index) {
          if (index == 0) {
            Navigator.pushReplacementNamed(context, "/home");
          }
        },
      ),
    );
  }

  /// Builds a card widget that displays details of a single report.
  ///
  /// The card is tappable and navigates to the detailed report view when tapped.
  ///
  /// Parameters:
  /// - [context]: The build context.
  /// - [report]: The report data to display.
  ///
  /// Returns a [Widget] representing the problem card.
  Widget _buildProblemCard(BuildContext context, HistoryReportModel report) {
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
          Navigator.pushNamed(
            context,
            "/problem_reported",
            arguments: {
              "reportId": report.id,
            },
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                report.reportType,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                "ID: ${report.id}",
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.white60,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                report.description,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.white70,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildTag(report.priorityLevel, const Color(0xFFFF6B6B)),
                  _buildTag(report.status, const Color(0xFFFDBE56)),
                  const Icon(Icons.arrow_forward_ios, color: Colors.white),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Builds a styled tag widget used to display priority or status.
  ///
  /// Parameters:
  /// - [text]: The label text for the tag.
  /// - [color]: The background color of the tag.
  ///
  /// Returns a [Widget] representing the tag.
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

  /// Builds a widget that displays an empty state for the screen.
  ///
  /// This is used when there are no reports to display or when an error occurs.
  ///
  /// Parameters:
  /// - [title]: The title text for the empty state.
  /// - [message]: The detailed message for the empty state.
  ///
  /// Returns a [Widget] representing the empty state.
  Widget _buildEmptyState(String title, String message) {
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      children: [
        const SizedBox(height: 100),
        Center(
          child: Icon(Icons.report_problem, size: 80, color: Colors.grey.shade400),
        ),
        const SizedBox(height: 20),
        Center(
          child: Text(
            title,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black54),
          ),
        ),
        const SizedBox(height: 10),
        Center(
          child: Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 16, color: Colors.black45),
          ),
        ),
      ],
    );
  }
}
