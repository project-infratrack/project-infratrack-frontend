import 'package:flutter/material.dart';
import 'screens/login.dart';
import 'screens/signup.dart';
import 'screens/home.dart';
import 'screens/user_profile.dart';
import 'screens/recover_password.dart';
import 'screens/recover_password_otp.dart'; // Import OTP Screen
import 'screens/reset_password.dart'; // Placeholder for Reset Password
// import 'screens/add_report.dart'; // Uncomment when implemented

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
        "/recover_password_otp": (context) => const RecoverPasswordOtpScreen(), // OTP Screen
        "/reset_password": (context) => const ResetPasswordScreen(), // Reset Password Screen
        // "/add_report": (context) => const AddReportScreen(), // Uncomment when available
      },
    );
  }
}
