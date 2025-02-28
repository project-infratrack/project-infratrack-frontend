import 'package:flutter/material.dart';
import 'package:infratrack/components/bottom_navigation.dart';

class IssueReportedScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xE6F1FAFF),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.close, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Container(
            width: constraints.maxWidth,
            height: constraints.maxHeight,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center, // Vertical alignment
              crossAxisAlignment:
                  CrossAxisAlignment.center, // Horizontal alignment
              children: [
                Container(
                  width: constraints.maxWidth * 0.8,
                  height: 500,
                  padding: EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Color(0xFF2C3E50),
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
                          Icons.check,
                          color: Colors.green,
                          size: constraints.maxWidth * 0.15,
                        ),
                      ),
                      SizedBox(height: 16),
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
          // Handle navigation changes
        },
      ),
    );
  }
}
