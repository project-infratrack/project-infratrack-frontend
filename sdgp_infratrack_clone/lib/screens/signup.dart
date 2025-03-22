import 'package:flutter/material.dart';
import 'package:infratrack/services/signup_services.dart';

/// Screen where users can register a new account.
///
/// Collects user information such as NIC, name, username, email, mobile number, and password.
/// Handles form validation, password matching check, and submits data to backend service.
class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  // Toggles password visibility
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  // Controllers for each form input
  final TextEditingController _idNumberController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _mobileNumberController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  // Shows loading spinner while signing up
  bool _isLoading = false;

  @override
  void dispose() {
    // Clean up controllers when the widget is disposed
    _idNumberController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _usernameController.dispose();
    _emailController.dispose();
    _mobileNumberController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  /// Handles form submission, validates inputs, and calls signup API.
  Future<void> _signUp() async {
    final password = _passwordController.text.trim();
    final confirmPassword = _confirmPasswordController.text.trim();

    // Password confirmation check
    if (password != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Passwords do not match.")),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Call signup service
      final response = await SignUpServices.registerUser(
        idNumber: _idNumberController.text.trim(),
        firstName: _firstNameController.text.trim(),
        lastName: _lastNameController.text.trim(),
        username: _usernameController.text.trim(),
        email: _emailController.text.trim(),
        password: password,
        mobileNumber: _mobileNumberController.text.trim(),
      );

      debugPrint('Registration successful: $response');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Registration successful!')),
      );

      // Navigate to Login
      Navigator.pushReplacementNamed(context, "/login");
    } catch (error) {
      debugPrint('Registration error: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Registration failed: $error')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  /// Builds the complete UI for the signup screen.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2C3E50),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pushReplacementNamed(context, "/login");
          },
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo
              Padding(
                padding: const EdgeInsets.only(top: 50.0),
                child: Image.asset('assets/png/logo.png', height: 200),
              ),
              const SizedBox(height: 20),

              // Form Container
              Container(
                margin: const EdgeInsets.only(top: 20),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      "Sign Up",
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Input Fields
                    _buildInputField(
                      hint: "Enter Your National Identity Card Number",
                      controller: _idNumberController,
                    ),
                    _buildInputField(
                      hint: "Enter Your First Name",
                      controller: _firstNameController,
                    ),
                    _buildInputField(
                      hint: "Enter Your Last Name",
                      controller: _lastNameController,
                    ),
                    _buildInputField(
                      hint: "Enter Your Username",
                      controller: _usernameController,
                    ),
                    _buildInputField(
                      hint: "Enter Your Email Address",
                      controller: _emailController,
                    ),
                    _buildInputField(
                      hint: "Enter Your Mobile Number",
                      controller: _mobileNumberController,
                    ),
                    _buildPasswordField(
                      hint: "Password",
                      obscureText: _obscurePassword,
                      toggleVisibility: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                      controller: _passwordController,
                    ),
                    _buildPasswordField(
                      hint: "Confirm Password",
                      obscureText: _obscureConfirmPassword,
                      toggleVisibility: () {
                        setState(() {
                          _obscureConfirmPassword = !_obscureConfirmPassword;
                        });
                      },
                      controller: _confirmPasswordController,
                    ),
                    const SizedBox(height: 10),

                    // Sign Up Button
                    ElevatedButton(
                      onPressed: _isLoading ? null : _signUp,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
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
                              "Sign Up",
                              style: TextStyle(fontSize: 18, color: Colors.white),
                            ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Reusable Input Field builder.
  Widget _buildInputField({
    required String hint,
    required TextEditingController controller,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          prefixIcon: _getPrefixIcon(hint),
          filled: true,
          fillColor: const Color(0xFF2C3E50),
          hintText: hint,
          hintStyle: const TextStyle(color: Colors.white70),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
        ),
        style: const TextStyle(color: Colors.white),
      ),
    );
  }

  /// Reusable Password Field builder with visibility toggle.
  Widget _buildPasswordField({
    required String hint,
    required bool obscureText,
    required VoidCallback toggleVisibility,
    required TextEditingController controller,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
          prefixIcon: const Icon(Icons.lock, color: Colors.white70),
          filled: true,
          fillColor: const Color(0xFF2C3E50),
          hintText: hint,
          hintStyle: const TextStyle(color: Colors.white70),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
          suffixIcon: IconButton(
            icon: Icon(
              obscureText ? Icons.visibility_off : Icons.visibility,
              color: Colors.white70,
            ),
            onPressed: toggleVisibility,
          ),
        ),
        style: const TextStyle(color: Colors.white),
      ),
    );
  }

  /// Chooses prefix icons based on hint text content.
  Icon _getPrefixIcon(String hint) {
    final lowerHint = hint.toLowerCase();
    if (lowerHint.contains("national identity")) {
      return const Icon(Icons.credit_card, color: Colors.white70);
    } else if (lowerHint.contains("first name")) {
      return const Icon(Icons.person, color: Colors.white70);
    } else if (lowerHint.contains("last name")) {
      return const Icon(Icons.person_outline, color: Colors.white70);
    } else if (lowerHint.contains("username")) {
      return const Icon(Icons.account_circle, color: Colors.white70);
    } else if (lowerHint.contains("email")) {
      return const Icon(Icons.email, color: Colors.white70);
    } else if (lowerHint.contains("mobile")) {
      return const Icon(Icons.phone, color: Colors.white70);
    }
    return const Icon(Icons.input, color: Colors.white70);
  }
}
