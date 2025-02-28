import 'package:flutter/material.dart';
import 'package:infratrack/admin_screens/Gov_issue_description.dart';
import 'package:infratrack/admin_screens/Government_issue_screen%20low.dart';
import 'package:infratrack/admin_screens/Government_issue_screen_high.dart';
import 'package:infratrack/admin_screens/Government_issue_screen_mid.dart';
import 'package:infratrack/screens/Issue_Reported.dart';
import 'package:infratrack/screens/Problem_Page_Reported.dart';
import 'package:infratrack/screens/Report_Issue_Page.dart';
import 'package:infratrack/screens/history.dart';
import 'package:infratrack/screens/issue_nearby.dart';
import 'package:infratrack/screens/issue_rejected.dart';
import 'screens/login.dart';
import 'screens/signup.dart';
import 'screens/home.dart';
import 'screens/userprofile.dart'; // Import User Profile Screen
//import 'screens/add_report.dart'; // Import Add Report Screen

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Infra Track',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
        scaffoldBackgroundColor: Colors.blueGrey.shade900,
        textTheme: const TextTheme(
          bodyMedium: TextStyle(color: Colors.white),
        ),
      ),
      home: const LoginScreen(), // Default starting screen
      routes: {
        "/signup": (context) => const SignUpScreen(),
        "/login": (context) => const LoginScreen(),
        "/home": (context) => const HomeScreen(),
        "/profile": (context) => const UserProfileScreen(),
        "/issue_nearby": (context) => IssuesNearbyScreen(),
        "/Report_Issue_Page": (context) => ReportIssueScreen(),
        "/history": (context) => HistoryScreen(),
        "/problem_page_reported": (context) => ProblemPageReportedScreen(),
        "/issue_reported": (context) => IssueReportedScreen(),
        "/issue_rejected": (context) => IssueRejectedScreen(),
        "/government_issue_Low": (context) => GovernmentIssueScreenLow(),
        "/government_issue_High": (context) => GovernmentIssueScreenHigh(),
        "/government_issue_Mid": (context) => GovernmentIssueScreenMid(),
        "/gove_issue_description": (context) =>
            GovernmentIssueDescriptionScreen(),
        // Added User Profile Screen
        //"/add_report": (context) => const AddReportScreen(), // Added Add Report Screen
      },
    );
  }
}
