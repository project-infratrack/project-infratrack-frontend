// lib/screens/user_profile_screen.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:infratrack/model/user_profile_model.dart';
import 'package:infratrack/services/user_profile_services.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({super.key});

  @override
  _UserProfileScreenState createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  Future<UserProfile>? _profileFuture;
  String? _token;

  @override
  void initState() {
    super.initState();
    _loadTokenAndFetchProfile();
  }

  /// Loads the token from SharedPreferences and fetches the user profile.
  Future<void> _loadTokenAndFetchProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');
    if (token == null || token.isEmpty) {
      Navigator.pushReplacementNamed(context, "/login");
      return;
    }

    setState(() {
      _token = token;
      _profileFuture = UserProfileServices.getUserProfile(_token!);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEBF8FF),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pushReplacementNamed(context, "/home");
          },
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.account_circle, color: Colors.black, size: 36),
                SizedBox(width: 10),
                Text(
                  "Profile",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: FutureBuilder<UserProfile>(
        future: _profileFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return const Center(child: Text('No profile data found.'));
          } else {
            final profile = snapshot.data!;
            return SingleChildScrollView(
              child: Column(
                children: [
                  // Header area with curved background and greeting text inside.
                  ClipPath(
                    clipper: HeaderClipper(),
                    child: Container(
                      height: 150,
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Color(0xFF2C3E50), Color(0xFF2C3E50)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          "Hey, ${profile.name}!",
                          style: const TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                  // Use Transform.translate to move the data card upward, adjusted to -15.
                  Transform.translate(
                    offset: const Offset(0, -15),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            children: [
                              InfoRow(
                                icon: Icons.person,
                                label: "Name",
                                value: profile.name,
                              ),
                              const SizedBox(height: 10),
                              InfoRow(
                                icon: Icons.credit_card,
                                label: "NIC / EIC",
                                value: profile.idNumber,
                              ),
                              const SizedBox(height: 10),
                              InfoRow(
                                icon: Icons.account_circle,
                                label: "Username",
                                value: profile.username,
                              ),
                              const SizedBox(height: 10),
                              InfoRow(
                                icon: Icons.email,
                                label: "Email",
                                value: profile.email,
                              ),
                              const SizedBox(height: 10),
                              InfoRow(
                                icon: Icons.phone,
                                label: "Mobile",
                                value: profile.mobileNo,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Logout Button.
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, "/login");
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    icon: const Icon(Icons.logout, color: Colors.white),
                    label: const Text(
                      "Log Out",
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}

// Custom Clipper for the header's curved bottom edge.
class HeaderClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    // Start at top left.
    path.lineTo(0, size.height - 40);
    // Draw a quadratic curve for a smooth curve.
    var firstControlPoint = Offset(size.width / 2, size.height);
    var firstEndPoint = Offset(size.width, size.height - 40);
    path.quadraticBezierTo(
      firstControlPoint.dx,
      firstControlPoint.dy,
      firstEndPoint.dx,
      firstEndPoint.dy,
    );
    // Line to top right and close.
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  const InfoRow({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 6,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Icon with gradient circular background using the same blue color as the header.
          Container(
            padding: const EdgeInsets.all(12),
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [Color(0xFF2C3E50), Color(0xFF2C3E50)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Icon(
              icon,
              color: Colors.white,
              size: 24,
            ),
          ),
          const SizedBox(width: 20),
          // Text information.
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.blueGrey.shade700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
