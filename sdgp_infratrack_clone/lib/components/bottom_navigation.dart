import 'package:flutter/material.dart';

class BottomNavigation extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onItemTapped;

  const BottomNavigation({
    Key? key,
    required this.selectedIndex,
    required this.onItemTapped,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Maintain the original color.
    const navColor = Color(0xFF2C3E50);

    return SafeArea(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        padding: const EdgeInsets.symmetric(horizontal: 32),
        // Increased height from 70 to 90
        height: 90,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFFFFFFFF), Color(0xFFEBF8FF)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
          borderRadius: BorderRadius.circular(35),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 15,
              offset: const Offset(0, -3),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            NavItem(
              icon: Icons.home,
              label: "Home",
              isSelected: selectedIndex == 0,
              onTap: () => onItemTapped(0),
              navColor: navColor,
            ),
            const SizedBox(width: 55),
            SizedBox(
              width: 60,
              height: 60,
              child: FloatingActionButton(
                backgroundColor: navColor,
                onPressed: () {
                  Navigator.pushNamed(context, "/add_report");
                },
                shape: const CircleBorder(),
                child: const Icon(Icons.add, size: 24, color: Colors.white),
              ),
            ),
            const SizedBox(width: 55),
            NavItem(
              icon: Icons.history,
              label: "History",
              isSelected: selectedIndex == 1,
              onTap: () => onItemTapped(1),
              navColor: navColor,
            ),
          ],
        ),
      ),
    );
  }
}

class NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final Color navColor;

  const NavItem({
    Key? key,
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
    required this.navColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(30),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          color: isSelected ? navColor : Colors.transparent,
          borderRadius: BorderRadius.circular(30),
          border: isSelected ? null : Border.all(color: navColor, width: 2),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedScale(
              scale: isSelected ? 1.2 : 1.0,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOut,
              child: Icon(
                icon,
                color: isSelected ? Colors.white : navColor,
                size: 24,
              ),
            ),
            const SizedBox(height: 4),
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 300),
              style: TextStyle(
                color: isSelected ? Colors.white : navColor,
                fontSize: 10,
                fontWeight: FontWeight.w600,
              ),
              child: Text(
                label,
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
