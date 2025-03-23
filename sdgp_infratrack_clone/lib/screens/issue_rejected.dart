import 'package:flutter/material.dart';
import 'package:infratrack/components/bottom_navigation.dart';

/// A screen that displays an "Issue Rejected" message.
///
/// This stateless widget presents a rejection message to the user within a styled
/// container. It features a transparent AppBar with a close button that allows the
/// user to navigate back, and it includes a bottom navigation bar.
class IssueRejectedScreen extends StatelessWidget {
  /// Creates an instance of [IssueRejectedScreen].
  const IssueRejectedScreen({super.key});

  /// Builds the widget tree for the [IssueRejectedScreen].
  ///
  /// The scaffold contains:
  /// - An AppBar with a close button to dismiss the screen.
  /// - A body that centers the rejection message in a container with styling.
  /// - A bottom navigation bar for app-wide navigation.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xE6F1FAFF),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SizedBox(
            width: constraints.maxWidth,
            height: constraints.maxHeight,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center, // Center content vertically
              crossAxisAlignment: CrossAxisAlignment.center, // Center content horizontally
              children: [
                Container(
                  width: constraints.maxWidth * 0.8,
                  height: 500,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: const Color(0xFF2C3E50),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: constraints.maxWidth * 0.15,
                        backgroundColor: Colors.white,
                        child: Icon(
                          Icons.close,
                          color: Colors.red,
                          size: constraints.maxWidth * 0.15,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        "Issue Rejected!",
                        style: TextStyle(
                          fontSize: constraints.maxWidth * 0.05,
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: BottomNavigation(
        selectedIndex: 0,
        onItemTapped: (index) {
          // Handle navigation changes if needed.
        },
      ),
    );
  }
}
