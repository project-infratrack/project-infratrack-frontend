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
      home: const LoginScreen(), // Default starting screen
      // Static routes for screens that don't require dynamic arguments.
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
        "/problem_reported": (context) => const ProblemPageReportedScreen(),
        "/add_report": (context) => const ReportIssueScreen(),
        "/issue_rejected": (context) => const IssueRejectedScreen(),
      },
      // onGenerateRoute handles dynamic routes.
      onGenerateRoute: (settings) {
        // Dynamic route for "/issue_nearby"
        if (settings.name == "/issue_nearby") {
          final args = settings.arguments as Map<String, dynamic>?;
          if (args != null && args.containsKey("reportId")) {
            final reportId = args["reportId"] as String;
            // Return the IssuesNearbyScreen with the dynamic reportId.
            return MaterialPageRoute(
              builder: (context) => IssuesNearbyScreen(reportId: reportId),
            );
          } else {
            // If no reportId is provided, show an error page or fallback.
            return MaterialPageRoute(
              builder: (context) => const Scaffold(
                body: Center(
                  child: Text("Report ID is required for this route."),
                ),
              ),
            );
          }
        }
        // If no matching route, return null to let Flutter handle it.
        return null;
      },
    );
  }
}
