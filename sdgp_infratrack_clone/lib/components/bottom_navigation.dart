import 'package:flutter/material.dart';

class BottomNavigation extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  const BottomNavigation({
    super.key,
    required this.selectedIndex,
    required this.onItemTapped,
  });

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      color: const Color(0xFFEBF8FF),
      shape: const CircularNotchedRectangle(),
      notchMargin: 12,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 1, vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildNavButton(Icons.home, 0, context),
            _buildFloatingActionButton(context),
            _buildNavButton(Icons.history, 1, context),
          ],
        ),
      ),
    );
  }

  // Custom Floating Action Button (Increased Size)
  Widget _buildFloatingActionButton(BuildContext context) {
    return SizedBox(
      height: 90, // Further increased height
      width: 90, // Further increased width
      child: FloatingActionButton(
        backgroundColor: const Color(0xFF2C3E50),
        shape: const CircleBorder(),
        onPressed: () {
          Navigator.pushNamed(context, "/add_report");
        },
        child: const Icon(Icons.add, color: Colors.white, size: 36), // Bigger icon
      ),
    );
  }

  // Custom Navigation Button (Increased Size)
  Widget _buildNavButton(IconData icon, int index, BuildContext context) {
    return GestureDetector(
      onTap: () => onItemTapped(index),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF2C3E50),
          borderRadius: BorderRadius.circular(50),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 3), // Further increased padding
        child: Icon(
          icon,
          color: Colors.white,
          size: 33, // Larger icon size
        ),
      ),
    );
  }
}
