import 'package:flutter/material.dart';
import '../components/bottom_navigation.dart'; // Import the navigation bar

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    if (index == 0) {
      Navigator.pushReplacementNamed(context, "/home");
    } else if (index == 1) {
      Navigator.pushReplacementNamed(context, "/history");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEBF8FF),
      appBar: AppBar(
        backgroundColor: const Color(0xFFEBF8FF),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Colors.black),
          onPressed: () {},
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.account_circle, color: Colors.black),
            onPressed: () {
              Navigator.pushReplacementNamed(context, "/profile");
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Logo and Title
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Column(
              children: [
                Image.asset('assets/png/logo2.png', height: 200),
                const SizedBox(height: 5),
              ],
            ),
          ),

          // Issue Reports List
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(15),
              children: [
                _buildIssueCard(
                  "Pothole in Nugegoda",
                  "A blocked drainage system in Kohuwala is leading to waterlogging during rains",
                  10,
                  2,
                ),
                _buildIssueCard(
                  "Overgrown Tree",
                  "A blocked drainage system in Kohuwala is leading to waterlogging during rains",
                  10,
                  2,
                ),
                _buildIssueCard(
                  "Pothole in Nugegoda",
                  "A blocked drainage system in Kohuwala is leading to waterlogging during rains",
                  10,
                  2,
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigation(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }

  // Custom Issue Report Card Widget
  Widget _buildIssueCard(
      String title, String description, int likes, int dislikes) {
    return Card(
      color: const Color(0xFF2C3E50),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Issue Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    description,
                    style: const TextStyle(fontSize: 14, color: Colors.white70),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),

            // Reactions (Like & Dislike)
            Column(
              children: [
                Row(
                  children: [
                    const Icon(Icons.thumb_up, color: Colors.white),
                    const SizedBox(width: 5),
                    Text("$likes", style: const TextStyle(color: Colors.white)),
                  ],
                ),
                const SizedBox(height: 5),
                Row(
                  children: [
                    const Icon(Icons.thumb_down, color: Colors.white),
                    const SizedBox(width: 5),
                    Text("$dislikes",
                        style: const TextStyle(color: Colors.white)),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
