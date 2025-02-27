import 'package:flutter/material.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  bool _obscurePassword = true; // Controls visibility of the Password field
  bool _obscureConfirmPassword = true; // Controls visibility of the Confirm Password field

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
              // Logo Section
              Padding(
                padding: const EdgeInsets.only(top: 50.0),
                child: Image.asset('assets/png/logo.png', height: 200),
              ),
              const SizedBox(height: 20),
              // Sign Up Container
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
                    // Input Fields with prefix icons
                    _buildInputField("Enter Your National Identity Card Number"),
                    _buildInputField("Enter Your First Name"),
                    _buildInputField("Enter Your Last Name"),
                    _buildInputField("Enter Your Username"),
                    _buildInputField("Enter Your Email Address"),
                    _buildInputField("Enter Your Mobile Number"),
                    _buildPasswordField("Password", _obscurePassword, () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    }),
                    _buildPasswordField("Confirm Password", _obscureConfirmPassword, () {
                      setState(() {
                        _obscureConfirmPassword = !_obscureConfirmPassword;
                      });
                    }),
                    const SizedBox(height: 10),
                    // Sign Up Button
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/home');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
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

  // Helper Function for Regular Input Fields with Prefix Icons
  Widget _buildInputField(String hint) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
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

  // Helper Function for Password Fields with Visibility Toggle and Prefix Icon
  Widget _buildPasswordField(String hint, bool obscureText, VoidCallback toggleVisibility) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
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

  // Helper function to choose prefix icons based on the hint text.
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
