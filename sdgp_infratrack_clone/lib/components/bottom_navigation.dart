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
    return SafeArea(
      // Ensures the nav bar doesn't overlap system UI elements
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        padding: const EdgeInsets.symmetric(horizontal: 24),
        height: 80,
        width: double.infinity,
        decoration: BoxDecoration(
          color: const Color(0xFFEBF8FF),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(35),
            topRight: Radius.circular(35),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 20,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.center,
          children: [
            // Row with two interactive nav items.
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                NavItem(
                  icon: Icons.home,
                  isSelected: selectedIndex == 0,
                  onTap: () => onItemTapped(0),
                ),
                NavItem(
                  icon: Icons.history,
                  isSelected: selectedIndex == 1,
                  onTap: () => onItemTapped(1),
                ),
              ],
            ),
            // Center FAB positioned to overlap the nav bar.
            Positioned(
              top: -30,
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: FloatingActionButton(
                  backgroundColor: const Color(0xFF2C3E50),
                  onPressed: () {
                    Navigator.pushNamed(context, "/add_report");
                  },
                  child: const Icon(Icons.add, size: 36, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class NavItem extends StatelessWidget {
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const NavItem({
    super.key,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
        width: 60,
        height: 60,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF2C3E50) : Colors.transparent,
          shape: BoxShape.circle,
          border: isSelected
              ? null
              : Border.all(color: const Color(0xFF2C3E50), width: 2),
        ),
        // Animated scaling of the icon for interactive feedback.
        child: AnimatedScale(
          scale: isSelected ? 1.2 : 1.0,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
          child: Icon(
            icon,
            color: isSelected ? Colors.white : const Color(0xFF2C3E50),
            size: 28,
          ),
        ),
      ),
    );
  }
}