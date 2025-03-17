// import 'package:flutter/material.dart';

// class UserProfileScreen extends StatelessWidget {
//   const UserProfileScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFEBF8FF),
//       appBar: AppBar(
//         backgroundColor: const Color(0xFFEBF8FF),
//         elevation: 0,
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back, color: Colors.black),
//           onPressed: () {
//             Navigator.pushReplacementNamed(context, "/home");
//           },
//         ),
//       ),
//       body: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           // Profile Picture
//           const Center(
//             child: Stack(
//               children: [
//                 CircleAvatar(
//                   radius: 65,
//                   backgroundColor: Colors.white,
//                   child: CircleAvatar(
//                     radius: 60,
//                     backgroundImage: AssetImage("assets/png/profile01.png"), // Replace with network image if needed
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           const SizedBox(height: 15),

//           // Username
//           const Text(
//             "Hey, Sara!",
//             style: TextStyle(
//               fontSize: 24,
//               fontWeight: FontWeight.bold,
//               color: Colors.black87,
//             ),
//           ),
//           const SizedBox(height: 20),

//           // User Information Card
//           Container(
//             margin: const EdgeInsets.symmetric(horizontal: 20),
//             padding: const EdgeInsets.all(20),
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(20),
//               boxShadow: const [
//                 BoxShadow(
//                   color: Colors.black26,
//                   blurRadius: 5,
//                   offset: Offset(0, 3),
//                 ),
//               ],
//             ),
//             child: Column(
//               children: [
//                 _buildInfoRow("Name", "Sara Pinto Sampaio"),
//                 _buildInfoRow("NIC / EIC", "199833900024"),
//                 _buildInfoRow("Email", "sara.pinto@gmail.com"),
//                 _buildInfoRow("Mobile", "+94 771234567"),
//               ],
//             ),
//           ),
//           const SizedBox(height: 20),

//           // Logout Button
//           ElevatedButton.icon(
//             onPressed: () {
//               Navigator.pushReplacementNamed(context, "/login");// Add logout logic here
//             },
//             style: ElevatedButton.styleFrom(
//               backgroundColor: Colors.black,
//               padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(15),
//               ),
//             ),
//             icon: const Icon(Icons.logout, color: Colors.white),
//             label: const Text(
//               "Log Out",
//               style: TextStyle(fontSize: 18, color: Colors.white),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   // Custom Row for Displaying User Information
//   Widget _buildInfoRow(String label, String value) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 8.0),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Container(
//             padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
//             decoration: BoxDecoration(
//               color: Colors.grey.shade300,
//               borderRadius: BorderRadius.circular(10),
//             ),
//             child: Text(
//               label,
//               style: const TextStyle(
//                 fontSize: 14,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.black54,
//               ),
//             ),
//           ),
//           const SizedBox(height: 5),
//           Container(
//             padding: const EdgeInsets.all(15),
//             decoration: BoxDecoration(
//               color: const Color(0xFF2C3E50),
//               borderRadius: BorderRadius.circular(15),
//             ),
//             child: Text(
//               value,
//               style: const TextStyle(fontSize: 16, color: Colors.white),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
