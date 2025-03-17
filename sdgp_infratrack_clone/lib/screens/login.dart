// lib/screens/login_screen.dart

import 'package:flutter/material.dart';
import 'package:infratrack/services/login_services.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _obscureText = true; // Toggles password visibility

  // Controllers to capture user input
  final TextEditingController _idNumberController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  /// Optional: a loading indicator to display while the login request is in flight
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2C3E50),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo (adjust image asset as needed)
              Padding(
                padding: const EdgeInsets.only(top: 50.0),
                child: Column(
                  children: [
                    Image.asset('assets/png/logo.png', height: 300),
                    const SizedBox(height: 10),
                  ],
                ),
              ),

              // Login Container
              SizedBox(
                height: 600,
                child: Container(
                  margin: const EdgeInsets.only(top: 20),
                  padding: const EdgeInsets.all(25),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEBF8FF),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 20),
                      const Text(
                        "Login",
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 50),

                      // ID Number Field
                      TextField(
                        controller: _idNumberController,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.person, color: Colors.white70),
                          contentPadding:
                              const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                          filled: true,
                          fillColor: const Color(0xFF2C3E50),
                          hintText: "NIC Number",
                          hintStyle: const TextStyle(color: Colors.white70),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide:
                                const BorderSide(color: Colors.white, width: 2),
                          ),
                        ),
                        style: const TextStyle(color: Colors.white),
                      ),
                      const SizedBox(height: 25),

                      // Password Field with Visibility Toggle
                      TextField(
                        controller: _passwordController,
                        obscureText: _obscureText,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.lock, color: Colors.white70),
                          contentPadding:
                              const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                          filled: true,
                          fillColor: const Color(0xFF2C3E50),
                          hintText: "Password",
                          hintStyle: const TextStyle(color: Colors.white70),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide:
                                const BorderSide(color: Colors.white, width: 2),
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscureText ? Icons.visibility_off : Icons.visibility,
                              color: Colors.white70,
                            ),
                            onPressed: () {
                              setState(() {
                                _obscureText = !_obscureText; // Toggle visibility
                              });
                            },
                          ),
                        ),
                        style: const TextStyle(color: Colors.white),
                      ),
                      const SizedBox(height: 10),

                      // Forgot Password
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {
                            Navigator.pushNamed(context, "/recover_password");
                          },
                          child: const Text(
                            "Forgot password?",
                            style: TextStyle(color: Colors.black, fontSize: 14),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),

                      // Login Button
                      ElevatedButton(
                        onPressed: _isLoading ? null : _login,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 40, vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        child: _isLoading
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : const Text(
                                "Log in",
                                style: TextStyle(fontSize: 18, color: Colors.white),
                              ),
                      ),
                      const SizedBox(height: 20),

                      // Sign-up Prompt
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Don't have an account? ",
                            style: TextStyle(color: Color(0xFF000000)),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(context, "/signup");
                            },
                            child: const Text(
                              "Sign up!",
                              style: TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// This method is called when the Login button is pressed
  Future<void> _login() async {
    setState(() {
      _isLoading = true; // Show loading indicator
    });

    final idNumber = _idNumberController.text.trim();
    final password = _passwordController.text.trim();

    try {
      final response = await LoginServices.userLogin(idNumber, password);
      // Handle the response (save tokens, navigate, etc.)
      debugPrint('Login successful. Response: $response');
      Navigator.pushNamed(context, "/home");
    } catch (error) {
      debugPrint('Login error: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Login failed: invalid credentials')),
      );
    } finally {
      setState(() {
        _isLoading = false; // Hide loading indicator
      });
    }
  }
}
