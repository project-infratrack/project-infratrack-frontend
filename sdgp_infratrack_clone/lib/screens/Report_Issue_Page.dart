import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:infratrack/components/bottom_navigation.dart';

class ReportIssueScreen extends StatefulWidget {
  const ReportIssueScreen({super.key});

  @override
  _ReportIssueScreenState createState() => _ReportIssueScreenState();
}

class _ReportIssueScreenState extends State<ReportIssueScreen> {
  String selectedIssue = "Choose Issue Type";
  final List<String> issueTypes = [
    "Potholes",
    "Overgrown trees",
    "Broken street lights",
  ];

  final TextEditingController _descriptionController = TextEditingController();
  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _selectedImage = File(image.path);
      });
    }
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // Gradient background for a modern look
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFE6F1FA), Color(0xFFD0E9F7)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent, // Show the gradient
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.account_circle,
                  color: Colors.black, size: 28),
              onPressed: () {
                // Handle account button press
              },
            ),
          ],
        ),
        body: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 40),
                const Text(
                  "Report an issue",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 25),
                _buildDropdownButton(),
                const SizedBox(height: 16),
                _buildTextField(),
                const SizedBox(height: 16),
                _buildUploadImageButton(),
                const SizedBox(height: 16),
                _buildMapPlaceholder(),
                const SizedBox(height: 16),
                _buildReportButton(),
              ],
            ),
          ),
        ),
        bottomNavigationBar: BottomNavigation(
          selectedIndex: 1,
          onItemTapped: (index) {
            // Handle navigation changes if needed
          },
        ),
      ),
    );
  }

  Widget _buildDropdownButton() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF2C3E50),
        borderRadius: BorderRadius.circular(8),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          isExpanded: true,
          dropdownColor: const Color(0xFF2C3E50),
          value: selectedIssue,
          icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
          style: const TextStyle(color: Colors.white, fontSize: 16),
          items: [
            const DropdownMenuItem(
              value: "Choose Issue Type",
              child: Text("Choose Issue Type",
                  style: TextStyle(color: Colors.white)),
            ),
            ...issueTypes.map((issue) => DropdownMenuItem(
                  value: issue,
                  child:
                      Text(issue, style: const TextStyle(color: Colors.white)),
                )),
          ],
          onChanged: (value) {
            setState(() {
              selectedIssue = value!;
            });
          },
        ),
      ),
    );
  }

  Widget _buildTextField() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFF2C3E50),
        borderRadius: BorderRadius.circular(8),
      ),
      child: TextField(
        controller: _descriptionController,
        maxLines: 4,
        style: const TextStyle(color: Colors.white, fontSize: 16),
        decoration: const InputDecoration(
          border: InputBorder.none,
          hintText: "Add an issue description*",
          hintStyle: TextStyle(color: Colors.white70, fontSize: 16),
        ),
      ),
    );
  }

  Widget _buildUploadImageButton() {
    return InkWell(
      onTap: _pickImage,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 20),
        decoration: BoxDecoration(
          color: const Color(0xFF2C3E50),
          borderRadius: BorderRadius.circular(8),
        ),
        child: _selectedImage == null
            ? const Column(
                children: [
                  Icon(Icons.cloud_upload, color: Colors.white, size: 32),
                  SizedBox(height: 8),
                  Text("Upload Image(s)*",
                      style: TextStyle(color: Colors.white, fontSize: 16)),
                ],
              )
            : ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.file(
                  _selectedImage!,
                  height: 150,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
      ),
    );
  }

  Widget _buildMapPlaceholder() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Image.asset(
        'assets/png/map_placeholder2.png',
        height: 180,
        width: double.infinity,
        fit: BoxFit.cover,
      ),
    );
  }

  Widget _buildReportButton() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.black,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
      ),
      onPressed: () {
        // Handle report submission
      },
      child: const Text(
        "Report Issue",
        style: TextStyle(color: Colors.white, fontSize: 16),
      ),
    );
  }
}
