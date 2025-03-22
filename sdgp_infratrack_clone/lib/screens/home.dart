import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:infratrack/model/report_model.dart';
import 'package:infratrack/services/home_services.dart';
import 'package:infratrack/components/bottom_navigation.dart';

/// A screen that displays a list of infrastructure reports.
///
/// The [HomeScreen] serves as the main page of the app. It loads a token from
/// [SharedPreferences] and fetches reports from the backend. It includes a
/// navigation drawer, a header with logo, and a bottom navigation bar.
class HomeScreen extends StatefulWidget {
  /// Creates a [HomeScreen] widget.
  const HomeScreen({super.key});

  @override
  HomeScreenState createState() => HomeScreenState();
}

/// The state for [HomeScreen] that handles data fetching, UI updates,
/// and navigation.
class HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  Future<List<ReportModel>>? _reportFuture;
  String? _token; // Stores the extracted token

  @override
  void initState() {
    super.initState();
    _loadTokenAndFetchReports();
  }

  /// Loads the authentication token from [SharedPreferences] and fetches the reports.
  ///
  /// If no token is found or it is empty, the user is redirected to the login screen.
  Future<void> _loadTokenAndFetchReports() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');

    if (token == null || token.isEmpty) {
      // If no token is stored, navigate to the login screen.
      Navigator.pushReplacementNamed(context, "/login");
      return;
    }

    setState(() {
      _token = token;
      _reportFuture = HomeServices.getAllReports(_token!);
    });
  }

  /// Handles bottom navigation item taps.
  ///
  /// Updates the selected index and navigates to the corresponding screen.
  /// - [index] The tapped navigation item index.
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    if (index == 0) {
      Navigator.pushReplacementNamed(context, "/home");
    } else if (index == 1) {
      Navigator.pushReplacementNamed(context, "/history");
    }
    // Add more navigation destinations if needed.
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Home page background remains white.
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            // Drawer header with a dark background.
            DrawerHeader(
              decoration: const BoxDecoration(
                color: Color(0xFF2C3E50),
              ),
              child: Center(
                child: Text(
                  'Menu',
                  style: Theme.of(context)
                      .textTheme
                      .headlineSmall!
                      .copyWith(color: Colors.white),
                ),
              ),
            ),
            // Profile Navigation.
            ListTile(
              leading: const Icon(Icons.account_circle),
              title: const Text("Profile"),
              onTap: () {
                Navigator.pop(context); // Close the drawer.
                Navigator.pushReplacementNamed(context, "/profile");
              },
            ),
            // Logout Navigation.
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text("Logout"),
              onTap: () async {
                final prefs = await SharedPreferences.getInstance();
                await prefs.remove('auth_token'); // Remove stored token.
                Navigator.pushReplacementNamed(context, "/login");
              },
            ),
          ],
        ),
      ),
      appBar: AppBar(
        backgroundColor: Colors.white, // AppBar background set to white.
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Home",
          style: TextStyle(
            color: Colors.black,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(
              Icons.menu,
              color: Colors.black,
              size: 30,
            ),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.account_circle,
              color: Colors.black,
              size: 30,
            ),
            onPressed: () {
              Navigator.pushReplacementNamed(context, "/profile");
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Header area with a gradient background and logo.
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.white, Colors.grey.shade100],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  blurRadius: 6,
                  offset: const Offset(0, 3),
                ),
              ],
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
            child: Column(
              children: [
                Image.asset(
                  'assets/png/logo2.png',
                  height: 150,
                  fit: BoxFit.cover,
                ),
                const SizedBox(height: 10),
                const Text(
                  "Your Infrastructure Monitoring App",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          // Expanded list of issue cards wrapped in a RefreshIndicator.
          Expanded(
            child: RefreshIndicator(
              onRefresh: _loadTokenAndFetchReports,
              child: _reportFuture == null
                  ? ListView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      children: const [
                        SizedBox(
                          height: 200,
                          child: Center(child: CircularProgressIndicator()),
                        ),
                      ],
                    )
                  : FutureBuilder<List<ReportModel>>(
                      future: _reportFuture,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return ListView(
                            physics: const AlwaysScrollableScrollPhysics(),
                            children: const [
                              SizedBox(
                                height: 200,
                                child: Center(child: CircularProgressIndicator()),
                              ),
                            ],
                          );
                        } else if (snapshot.hasError) {
                          return ListView(
                            physics: const AlwaysScrollableScrollPhysics(),
                            children: [
                              SizedBox(
                                height: 200,
                                child: Center(
                                  child: Text('Error: ${snapshot.error}'),
                                ),
                              ),
                            ],
                          );
                        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                          return ListView(
                            physics: const AlwaysScrollableScrollPhysics(),
                            children: const [
                              SizedBox(
                                height: 200,
                                child: Center(child: Text('No reports found.')),
                              ),
                            ],
                          );
                        } else {
                          final reports = snapshot.data!;
                          return ListView.builder(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 10,
                            ),
                            itemCount: reports.length,
                            itemBuilder: (context, index) {
                              final report = reports[index];
                              return IssueCard(
                                report: report,
                                token: _token!, // Pass the extracted token.
                                onRefresh: _loadTokenAndFetchReports, // Callback to refresh.
                              );
                            },
                          );
                        }
                      },
                    ),
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
}

/// A widget that represents an individual issue report card.
///
/// Displays the report details (type and description) along with interactive like
/// and dislike buttons. Tapping on the card navigates to the detailed issue view.
class IssueCard extends StatefulWidget {
  /// The report data to be displayed.
  final ReportModel report;

  /// The authentication token used for API calls.
  final String token;

  /// Callback function to refresh the HomeScreen.
  final VoidCallback onRefresh;

  /// Creates an [IssueCard] widget.
  const IssueCard({
    super.key,
    required this.report,
    required this.token,
    required this.onRefresh,
  });

  @override
  State<IssueCard> createState() => _IssueCardState();
}

/// The state for [IssueCard] that manages like and dislike interactions.
class _IssueCardState extends State<IssueCard> {
  late int likes;
  late int dislikes;
  bool isLiked = false;
  bool isDisliked = false;

  @override
  void initState() {
    super.initState();
    likes = widget.report.thumbsUp;
    dislikes = widget.report.thumbsDown;
  }

  /// Toggles the like status for the report.
  ///
  /// If the report is liked, it will be unliked; if not, it will be liked.
  /// If the report was previously disliked, the dislike is removed.
  Future<void> _toggleLike() async {
    setState(() {
      if (isLiked) {
        likes--;
        isLiked = false;
      } else {
        likes++;
        isLiked = true;
        if (isDisliked) {
          dislikes--;
          isDisliked = false;
        }
      }
    });

    try {
      if (isLiked) {
        await HomeServices.thumbsUp(widget.report.id, widget.token);
      } else {
        await HomeServices.removeThumbsUp(widget.report.id, widget.token);
      }
      // Refresh the HomeScreen after a successful update.
      widget.onRefresh();
    } catch (error) {
      setState(() {
        // Revert UI changes if the API call fails.
        if (isLiked) {
          likes--;
          isLiked = false;
        } else {
          likes++;
          isLiked = true;
          if (isDisliked) {
            dislikes--;
            isDisliked = false;
          }
        }
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $error')),
      );
    }
  }

  /// Toggles the dislike status for the report.
  ///
  /// If the report is disliked, it will be undisliked; if not, it will be disliked.
  /// If the report was previously liked, the like is removed.
  Future<void> _toggleDislike() async {
    setState(() {
      if (isDisliked) {
        dislikes--;
        isDisliked = false;
      } else {
        dislikes++;
        isDisliked = true;
        if (isLiked) {
          likes--;
          isLiked = false;
        }
      }
    });

    try {
      if (isDisliked) {
        await HomeServices.thumbsDown(widget.report.id, widget.token);
      } else {
        await HomeServices.removeThumbsDown(widget.report.id, widget.token);
      }
      // Refresh the HomeScreen after a successful update.
      widget.onRefresh();
    } catch (error) {
      setState(() {
        // Revert UI changes if the API call fails.
        if (isDisliked) {
          dislikes--;
          isDisliked = false;
        } else {
          dislikes++;
          isDisliked = true;
          if (isLiked) {
            likes--;
            isLiked = false;
          }
        }
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $error')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      color: const Color(0xFF2C3E50),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: InkWell(
        borderRadius: BorderRadius.circular(15),
        onTap: () {
          // Navigate to the issue detail screen with the report ID.
          Navigator.pushNamed(
            context,
            "/issue_nearby",
            arguments: {"reportId": widget.report.id},
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Decorative vertical accent bar.
                Container(
                  width: 5,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(2),
                    gradient: const LinearGradient(
                      colors: [Colors.orangeAccent, Colors.amber],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                // Issue details column.
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.report.reportType,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        widget.report.description,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                // Like and dislike buttons column.
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: _toggleLike,
                      child: Row(
                        children: [
                          Icon(
                            Icons.thumb_up,
                            color: isLiked ? Colors.greenAccent : Colors.white,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            "$likes",
                            style: const TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    GestureDetector(
                      onTap: _toggleDislike,
                      child: Row(
                        children: [
                          Icon(
                            Icons.thumb_down,
                            color: isDisliked ? Colors.redAccent : Colors.white,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            "$dislikes",
                            style: const TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
