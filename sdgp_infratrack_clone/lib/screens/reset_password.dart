import 'package:flutter/material.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  _ResetPasswordScreenState createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEBF8FF),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2C3E50),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Column(
        children: [
          // Logo and Title
          Container(
            color: const Color(0xFF2C3E50),
            width: double.infinity,
            padding: const EdgeInsets.only(top: 40, bottom: 20),
            child: Column(
              children: [
                Image.asset('assets/png/logo.png', height: 250),
                const SizedBox(height: 10),
              ],
            ),
          ),

          // Reset Password Form
          Expanded(
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(25),
              decoration: const BoxDecoration(
                color: Color(0xFFEBF8FF),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 10),
                  const Text(
                    "Recover Password",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 5),
                  const Text(
                    "Create a new password",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black54,
                    ),
                  ),
                  const SizedBox(height: 30),

                  // New Password Input Field
                  _buildPasswordField("New Password", _newPasswordController, true),

                  const SizedBox(height: 15),

                  // Confirm New Password Input Field
                  _buildPasswordField("Re-enter New Password", _confirmPasswordController, false),

                  const SizedBox(height: 20),

                  // Confirm Button
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/login');
                      // Navigate to login or home page
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    child: const Text(
                      "Confirm",
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Password Input Field
  Widget _buildPasswordField(String hintText, TextEditingController controller, bool isNewPassword) {
    return TextField(
      controller: controller,
      obscureText: isNewPassword ? !_isPasswordVisible : !_isConfirmPasswordVisible,
      decoration: InputDecoration(
        filled: true,
        fillColor: const Color(0xFF2C3E50),
        hintText: hintText,
        hintStyle: const TextStyle(color: Colors.white70),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
        suffixIcon: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Info Icon for "New Password" Field
            if (isNewPassword)
              IconButton(
                icon: const Icon(Icons.info_outline, color: Colors.white70),
                onPressed: () {
                  // Show password guidelines (e.g., Snackbar or AlertDialog)
                },
              ),
            // Visibility Toggle Icon
            IconButton(
              icon: Icon(
                isNewPassword
                    ? (_isPasswordVisible ? Icons.visibility : Icons.visibility_off)
                    : (_isConfirmPasswordVisible ? Icons.visibility : Icons.visibility_off),
                color: Colors.white70,
              ),
              onPressed: () {
                setState(() {
                  if (isNewPassword) {
                    _isPasswordVisible = !_isPasswordVisible;
                  } else {
                    _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                  }
                });
              },
            ),
          ],
        ),
      ),
      style: const TextStyle(color: Colors.white, fontSize: 16),
    );
  }
}
