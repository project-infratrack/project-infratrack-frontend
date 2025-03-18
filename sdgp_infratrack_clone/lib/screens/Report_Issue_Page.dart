import 'dart:io';
import 'dart:convert';
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

  LatLng _selectedLocation = const LatLng(34.0522, -118.2437);
  bool _locationSelected = false;

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

  Future<void> _submitReport() async {
    // Validate required fields
    if (selectedIssue == "Choose Issue Type") {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select an issue type.")),
      );
      return;
    }
    if (_descriptionController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter an issue description.")),
      );
      return;
    }
    if (!_locationSelected) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select a location.")),
      );
      return;
    }
    if (_selectedImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please upload an image.")),
      );
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token') ?? "";
    final userDataString = prefs.getString('user_data') ?? "{}";
    final userData = jsonDecode(userDataString);
    final userId = userData["userId"] ?? "unknown";

    final imagePath = _selectedImage!.path;
    final latitudeStr = _selectedLocation.latitude.toString();
    final longitudeStr = _selectedLocation.longitude.toString();
    final locationStr = "Lat: $latitudeStr, Lng: $longitudeStr";

    try {
      final result = await ReportIssueServices.submitReport(
        userId: userId,
        reportType: selectedIssue,
        description: _descriptionController.text,
        location: locationStr,
        image: imagePath,
        latitude: _selectedLocation.latitude,
        longitude: _selectedLocation.longitude,
        priorityLevel: "Pending",
        thumbsUp: 0,
        thumbsDown: 0,
        thumbsUpUsers: [],
        thumbsDownUsers: [],
        token: token,
      );
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Report submitted successfully")),
      );
      Navigator.of(context).pop();
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error submitting report: $error")),
      );
    }
  }

  /// The container that holds all input fields
  Widget _buildInputFieldsContainer() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: Offset(2, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildDropdownButton(),
          const SizedBox(height: 16),
          _buildTextField(),
          const SizedBox(height: 16),
          _buildUploadImageButton(),
          const SizedBox(height: 16),
          _buildMapSelector(),
        ],
      ),
    );
  }

  /// Drop-down for issue type
  Widget _buildDropdownButton() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(8),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          isExpanded: true,
          dropdownColor: Colors.grey[200],
          value: selectedIssue,
          icon: const Icon(Icons.arrow_drop_down, color: Colors.black),
          style: const TextStyle(color: Colors.black, fontSize: 16),
          items: [
            // "Choose Issue Type" always black
            const DropdownMenuItem(
              value: "Choose Issue Type",
              child: Text("Choose Issue Type"),
            ),
            // For each real issue, if it is the selected item, text is blue
            ...issueTypes.map((issue) {
              return DropdownMenuItem<String>(
                value: issue,
                child: Text(
                  issue,
                  style: TextStyle(
                    color: issue == selectedIssue ? Colors.blue : Colors.black,
                  ),
                ),
              );
            }).toList(),
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

  /// Text field for description
  Widget _buildTextField() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(8),
      ),
      child: TextField(
        controller: _descriptionController,
        maxLines: 4,
        style: const TextStyle(color: Colors.black, fontSize: 16),
        decoration: const InputDecoration.collapsed(
          hintText: "Add an issue description*",
          hintStyle: TextStyle(color: Colors.black54, fontSize: 16),
        ),
      ),
    );
  }

  /// Image upload
  Widget _buildUploadImageButton() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(8),
      ),
      child: InkWell(
        onTap: _showImageSourceActionSheet,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
          child: _selectedImage == null
              ? Column(
                  children: const [
                    Icon(Icons.cloud_upload, color: Colors.black, size: 36),
                    SizedBox(height: 8),
                    Text("Upload Image(s)*",
                        style: TextStyle(color: Colors.black, fontSize: 16)),
                  ],
                )
              : ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.file(
                    _selectedImage!,
                    height: 160,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
        ),
      ),
    );
  }

  /// Map location button
  Widget _buildMapSelector() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(8),
      ),
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: _locationSelected ? Colors.green : Colors.blue,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(vertical: 14),
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
        icon: const Icon(Icons.location_on, size: 24),
        label: Text(
          _locationSelected ? "Location Selected" : "Select Location",
          style: const TextStyle(fontSize: 16),
        ),
      ),
    );
  }

  /// Narrow black "Report Issue" button, placed below the container
  Widget _buildReportIssueButtonNarrow() {
    return Padding(
      padding: const EdgeInsets.only(top: 40),
      child: Align(
        alignment: Alignment.center,
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            minWidth: 140,
            maxWidth: 180,
          ),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
            ),
            onPressed: _submitReport,
            child: const Text(
              "Report Issue",
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // Keep the same background gradient
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
            onPressed: () => Navigator.of(context).pop(),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.account_circle, color: Colors.black, size: 28),
              onPressed: () => Navigator.pushReplacementNamed(context, "/profile"),
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              // Title near the top
              const SizedBox(height: 20),
              const Text(
                "Report an issue",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
              // Extra spacing so container is visually centered
              const SizedBox(height: 40),
              // Container holding the input fields
              Container(
                width: double.infinity,
                margin: const EdgeInsets.symmetric(horizontal: 16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 6,
                      offset: Offset(2, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildDropdownButton(),
                    const SizedBox(height: 16),
                    _buildTextField(),
                    const SizedBox(height: 16),
                    _buildUploadImageButton(),
                    const SizedBox(height: 16),
                    _buildMapSelector(),
                  ],
                ),
              ),
              // The narrower black "Report Issue" button placed further down
              _buildReportIssueButtonNarrow(),
              const SizedBox(height: 30),
            ],
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
