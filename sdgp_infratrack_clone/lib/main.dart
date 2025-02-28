import 'package:flutter/material.dart';
import 'package:infratrack/screens/Issue_Reported.dart';
import 'package:infratrack/screens/Problem_Page_Reported.dart';
import 'package:infratrack/screens/Report_Issue_Page.dart';
import 'package:infratrack/screens/history.dart';
import 'package:infratrack/screens/issue_nearby.dart';
import 'package:infratrack/screens/issue_rejected.dart';
import 'screens/login.dart';
import 'screens/signup.dart';
import 'screens/home.dart';
import 'screens/user_profile.dart';
import 'screens/recover_password.dart';
import 'screens/recover_password_otp.dart'; // Import OTP Screen
import 'screens/reset_password.dart'; // Placeholder for Reset Password


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
        "/recover_password": (context) => const RecoverPasswordScreen(),
        "/recover_password_otp": (context) =>
            const RecoverPasswordOtpScreen(), // OTP Screen
        "/reset_password": (context) => const ResetPasswordScreen(),
        "/history": (context) => HistoryScreen(),
        "/issue_reported": (context) => const IssueReportedScreen(),
        "/problem_reported": (context) => const ProblemPageReportedScreen(),
        "/issue_nearby": (context) => const IssuesNearbyScreen(),
        "/issue_rejected": (context) => const IssueRejectedScreen(),
        // "/gov_issue_description": (context) => GovIssueDescription(),
        // "/gov_issue_high": (context) => GovernmentIssueScreenHigh(),

        "/add_report": (context) => const ReportIssueScreen(),
      },
    );
  }
}
