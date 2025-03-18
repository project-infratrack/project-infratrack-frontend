import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:infratrack/components/bottom_navigation.dart';
import 'package:infratrack/components/map_picker_popup.dart';
import 'package:infratrack/services/report_issue_services.dart';

class ReportIssueScreen extends StatefulWidget {
  const ReportIssueScreen({super.key});

  @override
  State<ReportIssueScreen> createState() => _ReportIssueScreenState();
}

class _ReportIssueScreenState extends State<ReportIssueScreen> {
  String selectedIssue = "Choose Issue Type";
  final List<String> issueTypes = [
    "Pothole",
    "Overgrown trees",
    "Broken street lights",
  ];

  final TextEditingController _descriptionController = TextEditingController();
  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();

  // Initially set the default location.
  LatLng _selectedLocation = const LatLng(34.0522, -118.2437);
  bool _locationSelected = false; // Flag to track if a location was selected

  Future<void> _pickImageFromGallery() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _selectedImage = File(image.path);
      });
    }
  }

  Future<void> _pickImageFromCamera() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      setState(() {
        _selectedImage = File(image.path);
      });
    }
  }

  void _showImageSourceActionSheet() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Gallery'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImageFromGallery();
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Camera'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImageFromCamera();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  // Dropdown button for issue type.
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
              child: Text("Choose Issue Type", style: TextStyle(color: Colors.white)),
            ),
            ...issueTypes.map((issue) => DropdownMenuItem(
                  value: issue,
                  child: Text(issue, style: const TextStyle(color: Colors.white)),
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

  // Multi-line text field for issue description.
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

  // Upload image button with bottom sheet to choose image source.
  Widget _buildUploadImageButton() {
    return InkWell(
      onTap: _showImageSourceActionSheet,
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

  // Button to open the MapPickerPopup.
  Widget _buildMapSelector() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: _locationSelected ? Colors.green : Colors.blue,
          padding: const EdgeInsets.symmetric(vertical: 16),
        ),
        onPressed: () async {
          final LatLng? pickedLocation = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MapPickerPopup(
                initialLocation: _selectedLocation,
              ),
            ),
          );
          if (pickedLocation != null) {
            setState(() {
              _selectedLocation = pickedLocation;
              _locationSelected = true;
            });
          }
        },
        icon: const Icon(Icons.location_on),
        label: Text(
          _locationSelected ? "Location Selected" : "Select Location",
          style: const TextStyle(fontSize: 16),
        ),
      ),
    );
  }

  // Report submission button.
  Widget _buildReportButton() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.black,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
      ),
      onPressed: _submitReport,
      child: const Text(
        "Report Issue",
        style: TextStyle(color: Colors.white, fontSize: 16),
      ),
    );
  }

  // Gather all data and submit the report as form-data.
  Future<void> _submitReport() async {
    // Retrieve token and userId from SharedPreferences.
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token') ?? "";
    final userDataString = prefs.getString('user_data') ?? "{}";
    final userData = jsonDecode(userDataString);
    final userId = userData["userId"] ?? "unknown";

    // For form-data submission, we now pass the image file path.
    String imagePath = "";
    if (_selectedImage != null) {
      imagePath = _selectedImage!.path;
    }

    // Prepare location string.
    final latitudeStr = _selectedLocation.latitude.toString();
    final longitudeStr = _selectedLocation.longitude.toString();
    final locationStr = "Lat: $latitudeStr, Lng: $longitudeStr";

    // Debug prints.
    print("Issue: $selectedIssue");
    print("Description: ${_descriptionController.text}");
    print("Latitude: $latitudeStr, Longitude: $longitudeStr");
    print("Image Path: $imagePath");

    try {
      final result = await ReportIssueServices.submitReport(
        userId: userId,
        reportType: selectedIssue,
        description: _descriptionController.text,
        location: locationStr,
        image: imagePath, // Pass file path for form-data.
        latitude: _selectedLocation.latitude,
        longitude: _selectedLocation.longitude,
        priorityLevel: "Pending",
        thumbsUp: 0,
        thumbsDown: 0,
        thumbsUpUsers: [],
        thumbsDownUsers: [],
        token: token,
      );
      print("Report submitted: $result");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Report submitted successfully")),
      );
      Navigator.of(context).pop();
    } catch (error) {
      print("Error submitting report: $error");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error submitting report: $error")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // Gradient background.
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFE6F1FA), Color(0xFFD0E9F7)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
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
              icon: const Icon(Icons.account_circle, color: Colors.black, size: 28),
              onPressed: () {
                Navigator.pushReplacementNamed(context, "/profile");
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
                _buildMapSelector(),
                const SizedBox(height: 16),
                _buildReportButton(),
              ],
            ),
          ),
        ),
        bottomNavigationBar: BottomNavigation(
          selectedIndex: 2,
          onItemTapped: (index) {
            if (index == 0) {
              Navigator.pushReplacementNamed(context, "/home");
            } else if (index == 1) {
              Navigator.pushReplacementNamed(context, "/history");
            }
          },
        ),
      ),
    );
  }
}
