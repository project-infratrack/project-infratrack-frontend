import 'package:flutter/material.dart';
import 'package:infratrack/screens/Issue_Reported.dart';
import 'package:infratrack/screens/Problem_Page_Reported.dart';
import 'package:infratrack/screens/Report_Issue_Page.dart';
import 'package:infratrack/screens/history.dart';
import 'package:infratrack/screens/problem_nearby.dart';
import 'package:infratrack/screens/issue_rejected.dart';
import 'screens/login.dart';
import 'screens/signup.dart';
import 'screens/home.dart';
import 'screens/user_profile.dart';
import 'screens/recover_password.dart';
import 'screens/recover_password_otp.dart';
import 'screens/reset_password.dart';

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
      home: const LoginScreen(),

      // Static routes
      routes: {
        "/signup": (context) => const SignUpScreen(),
        "/login": (context) => const LoginScreen(),
        "/home": (context) => const HomeScreen(),
        "/profile": (context) => const UserProfileScreen(),
        "/recover_password": (context) => const RecoverPasswordScreen(),
        "/recover_password_otp": (context) => const RecoverPasswordOtpScreen(),
        "/reset_password": (context) => const ResetPasswordScreen(),
        "/history": (context) => HistoryScreen(),
        "/issue_reported": (context) => const IssueReportedScreen(),
        "/add_report": (context) => const ReportIssueScreen(),
        "/issue_rejected": (context) => const IssueRejectedScreen(),
      },

      // Dynamic routes
      onGenerateRoute: (settings) {
        // Dynamic route for /issue_nearby
        if (settings.name == "/issue_nearby") {
          final args = settings.arguments as Map<String, dynamic>?;
          if (args != null && args.containsKey("reportId")) {
            final reportId = args["reportId"] as String;
            return MaterialPageRoute(
              builder: (context) => IssuesNearbyScreen(reportId: reportId),
            );
          } else {
            return _errorPage("Report ID is required for this route.");
          }
        }

        // Dynamic route for /problem_reported
        if (settings.name == "/problem_reported") {
          final args = settings.arguments as Map<String, dynamic>?;
          if (args != null && args.containsKey("reportId")) {
            final reportId = args["reportId"] as String;
            return MaterialPageRoute(
              builder: (context) => ProblemPageReportedScreen(reportId: reportId),
            );
          } else {
            return _errorPage("Report ID is required for this route.");
          }
        }

        return null;
      },
    );
  }

  // Error fallback widget
  MaterialPageRoute _errorPage(String message) {
    return MaterialPageRoute(
      builder: (context) => Scaffold(
        body: Center(child: Text(message)),
      ),
    );
  }
}
