import 'package:flutter/material.dart';
import 'package:infratrack/components/bottom_navigation.dart';

/// A screen that displays a success message after an issue has been reported.
///
/// This stateless widget presents a confirmation message to the user within a styled
/// container. It features a transparent AppBar with a close button that allows the user
/// to navigate back, and it includes a bottom navigation bar for app-wide navigation.
class IssueReportedScreen extends StatelessWidget {
  /// Creates an instance of [IssueReportedScreen].
  const IssueReportedScreen({super.key});

  /// Builds the widget tree for the [IssueReportedScreen].
  ///
  /// The [Scaffold] contains:
  /// - A transparent AppBar with a close button to dismiss the screen.
  /// - A body that centers a container with a success icon and message.
  /// - A bottom navigation bar for further navigation within the app.
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
              mainAxisAlignment: MainAxisAlignment.center, // Center vertically
              crossAxisAlignment: CrossAxisAlignment.center, // Center horizontally
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
                      // Success icon inside a circular avatar.
                      CircleAvatar(
                        radius: constraints.maxWidth * 0.15,
                        backgroundColor: Colors.white,
                        child: Icon(
                          Icons.check,
                          color: Colors.green,
                          size: constraints.maxWidth * 0.15,
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Success message text.
                      Text(
                        "Issue Reported Successfully!",
                        style: TextStyle(
                          fontSize: constraints.maxWidth * 0.05,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
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
          // Handle navigation changes if necessary.
        },
      ),
    );
  }
}
