import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';

class RecoverPasswordOtpScreen extends StatelessWidget {
  const RecoverPasswordOtpScreen({super.key});

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

          // OTP Verification UI
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
                    "Please enter the OTP sent to user@gmail.com",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black54,
                    ),
                  ),
                  const SizedBox(height: 30),

                  // OTP Input Fields
                  OtpTextField(
                    numberOfFields: 6,
                    borderColor: const Color(0xFF2C3E50),
                    focusedBorderColor: Colors.black,
                    cursorColor: Colors.white,
                    fieldWidth: 50,
                    textStyle: const TextStyle(fontSize: 20, color: Colors.white),
                    fillColor: const Color(0xFF2C3E50),
                    filled: true,
                    borderRadius: BorderRadius.circular(10),
                    showFieldAsBox: true,
                  ),

                  const SizedBox(height: 20),

                  // Create New Password Button
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/reset_password');
                      // Navigate to reset password screen
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    child: const Text(
                      "Create New Password",
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ),

                  const SizedBox(height: 10),

                  // Resend OTP Option
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Didn't Receive OTP? ",
                        style: TextStyle(color: Colors.black54),
                      ),
                      GestureDetector(
                        onTap: () {
                          // Resend OTP action
                        },
                        child: const Text(
                          "Resend",
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
    );
  }
}
