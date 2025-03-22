import 'package:flutter/material.dart';
import '../services/reset_password_services.dart'; // Import your service

/// Screen that allows the user to reset their password after OTP verification.
///
/// Receives the user's NIC number and token from the previous OTP screen.
/// Allows entering a new password, confirming it, and submitting the reset request.
class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  _ResetPasswordScreenState createState() => _ResetPasswordScreenState();
}

/// State class for [ResetPasswordScreen], handling password input, validation, and submission.
class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  /// Controller for new password input.
  final TextEditingController _newPasswordController = TextEditingController();

  /// Controller for confirm password input.
  final TextEditingController _confirmPasswordController = TextEditingController();

  /// Toggles visibility of the new password field.
  bool _isPasswordVisible = false;

  /// Toggles visibility of the confirm password field.
  bool _isConfirmPasswordVisible = false;

  /// NIC number passed from OTP screen.
  String? idNumber;

  /// Token passed from OTP screen.
  String? token;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Receive arguments from OTP screen
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    if (args != null) {
      idNumber = args['idNumber'];
      token = args['token'];
    }
  }

  /// Handles password reset submission after validation.
  Future<void> _handlePasswordReset() async {
    String newPassword = _newPasswordController.text.trim();
    String confirmPassword = _confirmPasswordController.text.trim();

    if (newPassword.isEmpty || confirmPassword.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill in all fields.")),
      );
      return;
    }

    if (newPassword != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Passwords do not match.")),
      );
      return;
    }

    if (idNumber == null || token == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Invalid session. Please try again.")),
      );
      return;
    }

    // Call backend service to reset password
    bool success = await ResetPasswordServices.resetPassword(
      token: token!,
      idNumber: idNumber!,
      newPassword: newPassword,
      confirmPassword: confirmPassword,
    );

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Password reset successful!")),
      );
      Navigator.pushReplacementNamed(context, '/login');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to reset password. Please try again.")),
      );
    }
  }

  /// Builds the password input fields and confirm button UI.
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
          // Logo and Title section
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

          // Password input form
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

                  // New Password Field
                  _buildPasswordField("New Password", _newPasswordController, true),

                  const SizedBox(height: 15),

                  // Confirm Password Field
                  _buildPasswordField("Re-enter New Password", _confirmPasswordController, false),

                  const SizedBox(height: 20),

                  // Confirm Button
                  ElevatedButton(
                    onPressed: _handlePasswordReset,
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

  /// Builds the password input fields with visibility toggle.
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
        suffixIcon: IconButton(
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
      ),
      style: const TextStyle(color: Colors.white, fontSize: 16),
    );
  }
}
