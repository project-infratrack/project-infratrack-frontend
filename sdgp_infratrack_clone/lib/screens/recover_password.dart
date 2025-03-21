import 'package:flutter/material.dart';
import '../services/password_recovery_services.dart';

class RecoverPasswordScreen extends StatefulWidget {
  const RecoverPasswordScreen({super.key});

  @override
  _RecoverPasswordScreenState createState() => _RecoverPasswordScreenState();
}

class _RecoverPasswordScreenState extends State<RecoverPasswordScreen> {
  final TextEditingController _nicController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context)
            .unfocus(); // Dismiss keyboard when tapping outside
      },
      child: Scaffold(
        resizeToAvoidBottomInset: true, // Fixes keyboard not appearing
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

            // Recover Password Form
            Expanded(
              child: SingleChildScrollView(
                // Ensures keyboard scrolls properly
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
                        "Please enter your registered NIC number to proceed",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.black54,
                        ),
                      ),
                      const SizedBox(height: 30),

                      // NIC Input Field (Now Editable)
                      _buildInputField(),

                      const SizedBox(height: 20),

                      // Recover Button
                      ElevatedButton(
                        onPressed: () async {
                          String idNumber = _nicController.text.trim();
                          if (idNumber.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content:
                                      Text("Please enter your NIC number")),
                            );
                            return;
                          }

                          bool success = await PasswordRecoveryServices
                              .requestPasswordReset(idNumber);

                          if (success) {
                            Navigator.pushNamed(
                              context,
                              "/recover_password_otp",
                              arguments: {'idNumber': idNumber},
                            );
                          } else {
                            // Show error message if user doesn't exist or other backend error
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text(
                                      "Invalid ID number or user not found. Please check and try again.")),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 50, vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        child: const Text(
                          "Recover",
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Custom NIC Input Field
  Widget _buildInputField() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: _nicController,
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
          filled: true,
          fillColor: const Color(0xFF2C3E50),
          hintText: "NIC / EIC",
          hintStyle: const TextStyle(color: Colors.white70),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide.none,
          ),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
        ),
        style: const TextStyle(color: Colors.white, fontSize: 16),
      ),
    );
  }
}
