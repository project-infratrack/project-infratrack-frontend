// import 'package:flutter/material.dart';
// import '../components/bottom_navigation.dart'; // Import the navigation bar

// class HomeScreen extends StatefulWidget {
//   const HomeScreen({super.key});

//   @override
//   HomeScreenState createState() => HomeScreenState();
// }

// class HomeScreenState extends State<HomeScreen> {
//   int _selectedIndex = 0;
//   bool _isDarkMode = false; // State variable for dark mode toggle

//   void _onItemTapped(int index) {
//     setState(() {
//       _selectedIndex = index;
//     });
//     if (index == 0) {
//       Navigator.pushReplacementNamed(context, "/home");
//     } else if (index == 1) {
//       Navigator.pushReplacementNamed(context, "/history");
//     }
//     // Add more navigation destinations as needed.
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white, // Home page background remains white.
//       // Drawer for menu options.
//       drawer: Drawer(
//         child: ListView(
//           padding: EdgeInsets.zero,
//           children: [
//             // Drawer header with your original dark color.
//             DrawerHeader(
//               decoration: const BoxDecoration(
//                 color: Color(0xFF2C3E50),
//               ),
//               child: Center(
//                 child: Text(
//                   'Menu',
//                   style: Theme.of(context)
//                       .textTheme
//                       .headlineSmall!
//                       .copyWith(color: Colors.white),
//                 ),
//               ),
//             ),
//             // Dark Mode Toggle.
//             ListTile(
//               leading: const Icon(Icons.brightness_6),
//               title: const Text("Dark Mode"),
//               trailing: Switch(
//                 value: _isDarkMode,
//                 onChanged: (bool value) {
//                   setState(() {
//                     _isDarkMode = value;
//                     // TODO: Integrate your dark mode logic here.
//                   });
//                 },
//               ),
//             ),
//             // Profile Navigation.
//             ListTile(
//               leading: const Icon(Icons.account_circle),
//               title: const Text("Profile"),
//               onTap: () {
//                 Navigator.pop(context); // Close the drawer.
//                 Navigator.pushReplacementNamed(context, "/profile");
//               },
//             ),
//             // Logout Navigation.
//             ListTile(
//               leading: const Icon(Icons.logout),
//               title: const Text("Logout"),
//               onTap: () {
//                 Navigator.pop(context); // Close the drawer.
//                 Navigator.pushReplacementNamed(context, "/login");
//               },
//             ),
//           ],
//         ),
//       ),
//       appBar: AppBar(
//         backgroundColor: Colors.white, // AppBar background set to white.
//         elevation: 0,
//         centerTitle: true,
//         title: const Text(
//           "Home",
//           style: TextStyle(
//             color: Colors.black,
//             fontSize: 22,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         // Use a Builder to get a proper context for opening the drawer.
//         leading: Builder(
//           builder: (context) => IconButton(
//             icon: const Icon(
//               Icons.menu,
//               color: Colors.black,
//               size: 30,
//             ),
//             onPressed: () {
//               Scaffold.of(context).openDrawer();
//             },
//           ),
//         ),
//         actions: [
//           IconButton(
//             icon: const Icon(
//               Icons.account_circle,
//               color: Colors.black,
//               size: 30,
//             ),
//             onPressed: () {
//               Navigator.pushReplacementNamed(context, "/profile");
//             },
//           ),
//         ],
//       ),
//       body: Column(
//         children: [
//           // Redesigned header area with a light gradient, drop shadow, and animation.
//           Container(
//             width: double.infinity,
//             padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
//             decoration: BoxDecoration(
//               gradient: LinearGradient(
//                 colors: [Colors.white, Colors.grey.shade100],
//                 begin: Alignment.topLeft,
//                 end: Alignment.bottomRight,
//               ),
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.grey.withOpacity(0.2),
//                   blurRadius: 6,
//                   offset: const Offset(0, 3),
//                 ),
//               ],
//               borderRadius: const BorderRadius.only(
//                 bottomLeft: Radius.circular(20),
//                 bottomRight: Radius.circular(20),
//               ),
//             ),
//             child: Center(
//               child: TweenAnimationBuilder<double>(
//                 tween: Tween<double>(begin: 0, end: 1),
//                 duration: const Duration(milliseconds: 800),
//                 curve: Curves.easeOutBack,
//                 builder: (context, value, child) {
//                   return Transform.scale(
//                     scale: value,
//                     child: child,
//                   );
//                 },
//                 child: Image.asset(
//                   'assets/png/logo2.png',
//                   height: 150,
//                 ),
//               ),
//             ),
//           ),
//           const SizedBox(height: 10),
//           // Expanded List of Issue Cards.
//           Expanded(
//             child: ListView(
//               padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
//               children: const [
//                 IssueCard(
//                   title: "Pothole in Nugegoda",
//                   description:
//                       "A blocked drainage system in Kohuwala is leading to waterlogging during rains.",
//                   initialLikes: 10,
//                   initialDislikes: 2,
//                 ),
//                 IssueCard(
//                   title: "Overgrown Tree",
//                   description:
//                       "The tree is obstructing the road and needs trimming for safety.",
//                   initialLikes: 15,
//                   initialDislikes: 1,
//                 ),
//                 IssueCard(
//                   title: "Broken Streetlight",
//                   description:
//                       "The streetlight near the main square is not functioning, creating safety concerns.",
//                   initialLikes: 8,
//                   initialDislikes: 0,
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//       // Bottom Navigation Bar.
//       bottomNavigationBar: BottomNavigation(
//         selectedIndex: _selectedIndex,
//         onItemTapped: _onItemTapped,
//       ),
//     );
//   }
// }

// //-------------------
// // IssueCard Widget with onTap navigating to "/issue_nearby"
// //-------------------
// class IssueCard extends StatefulWidget {
//   final String title;
//   final String description;
//   final int initialLikes;
//   final int initialDislikes;

//   const IssueCard({
//     super.key,
//     required this.title,
//     required this.description,
//     required this.initialLikes,
//     required this.initialDislikes,
//   });

//   @override
//   State<IssueCard> createState() => _IssueCardState();
// }

// class _IssueCardState extends State<IssueCard> {
//   late int likes;
//   late int dislikes;
//   bool isLiked = false;
//   bool isDisliked = false;

//   @override
//   void initState() {
//     super.initState();
//     likes = widget.initialLikes;
//     dislikes = widget.initialDislikes;
//   }

//   void _toggleLike() {
//     setState(() {
//       if (isLiked) {
//         likes--;
//         isLiked = false;
//       } else {
//         likes++;
//         isLiked = true;
//         if (isDisliked) {
//           dislikes--;
//           isDisliked = false;
//         }
//       }
//     });
//   }

//   void _toggleDislike() {
//     setState(() {
//       if (isDisliked) {
//         dislikes--;
//         isDisliked = false;
//       } else {
//         dislikes++;
//         isDisliked = true;
//         if (isLiked) {
//           likes--;
//           isLiked = false;
//         }
//       }
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       elevation: 4,
//       color: const Color(0xFF2C3E50),
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(15),
//       ),
//       margin: const EdgeInsets.symmetric(vertical: 8),
//       child: InkWell(
//         borderRadius: BorderRadius.circular(15),
//         onTap: () {
//           Navigator.pushNamed(context, "/issue_nearby");
//         },
//         child: Padding(
//           padding: const EdgeInsets.all(16),
//           child: IntrinsicHeight(
//             child: Row(
//               crossAxisAlignment: CrossAxisAlignment.stretch,
//               children: [
//                 // Decorative vertical accent bar.
//                 Container(
//                   width: 5,
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(2),
//                     gradient: const LinearGradient(
//                       colors: [Colors.orangeAccent, Colors.amber],
//                       begin: Alignment.topCenter,
//                       end: Alignment.bottomCenter,
//                     ),
//                   ),
//                 ),
//                 const SizedBox(width: 12),
//                 // Issue Details Column.
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       // Title.
//                       Text(
//                         widget.title,
//                         style: const TextStyle(
//                           fontSize: 18,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.white,
//                         ),
//                       ),
//                       const SizedBox(height: 8),
//                       // Description.
//                       Text(
//                         widget.description,
//                         style: const TextStyle(
//                           fontSize: 14,
//                           color: Colors.white70,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 const SizedBox(width: 16),
//                 // Like and Dislike Buttons Column.
//                 Column(
//                   children: [
//                     GestureDetector(
//                       onTap: _toggleLike,
//                       child: Row(
//                         children: [
//                           Icon(
//                             Icons.thumb_up,
//                             color: isLiked ? Colors.greenAccent : Colors.white,
//                           ),
//                           const SizedBox(width: 4),
//                           Text(
//                             "$likes",
//                             style: const TextStyle(color: Colors.white),
//                           ),
//                         ],
//                       ),
//                     ),
//                     const SizedBox(height: 12),
//                     GestureDetector(
//                       onTap: _toggleDislike,
//                       child: Row(
//                         children: [
//                           Icon(
//                             Icons.thumb_down,
//                             color: isDisliked ? Colors.redAccent : Colors.white,
//                           ),
//                           const SizedBox(width: 4),
//                           Text(
//                             "$dislikes",
//                             style: const TextStyle(color: Colors.white),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
