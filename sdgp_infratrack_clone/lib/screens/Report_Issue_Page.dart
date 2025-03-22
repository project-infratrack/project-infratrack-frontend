import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:infratrack/components/bottom_navigation.dart';
import 'package:infratrack/components/map_picker_popup.dart';
import 'package:infratrack/services/report_issue_services.dart';
import '../services/ImageValidationService.dart';

/// Screen for reporting infrastructure issues.
///
/// Allows users to:
/// - Select an issue type
/// - Add a description
/// - Upload an image (with image validation)
/// - Select a location via map picker
/// - Submit the issue report to the backend
class ReportIssueScreen extends StatefulWidget {
  const ReportIssueScreen({super.key});

  @override
  State<ReportIssueScreen> createState() => _ReportIssueScreenState();
}

class _ReportIssueScreenState extends State<ReportIssueScreen> {
  /// Currently selected issue type.
  String selectedIssue = "Choose Issue Type";

  /// Available issue types for dropdown selection.
  final List<String> issueTypes = [
    "Pothole",
    "Overgrown trees",
    "Broken street lights",
  ];

  /// Controller for issue description input.
  final TextEditingController _descriptionController = TextEditingController();

  /// Stores the selected image file.
  File? _selectedImage;

  final ImagePicker _picker = ImagePicker();

  /// Stores the selected location coordinates.
  LatLng _selectedLocation = const LatLng(34.0522, -118.2437);

  /// Indicates if a location has been selected.
  bool _locationSelected = false;

  /// Image validation status.
  bool _isImageValidated = false;

  /// Whether image validation is in progress.
  bool _isValidating = false;

  /// Message to display image validation result.
  String _validationMessage = "";

  /// Validates the selected image using [ImageValidationService].
  Future<void> _validateAndSetImage(File image) async {
    setState(() {
      _selectedImage = image;
      _isValidating = true;
      _isImageValidated = false;
      _validationMessage = "Validating image...";
    });

    try {
      final result = await ImageValidationService.validateImage(image);
      final bool isPotholeDetected = result['pothole_detected'] ?? false;

      setState(() {
        _isValidating = false;
        _isImageValidated = isPotholeDetected;
        _validationMessage = isPotholeDetected
            ? "Image validated: Issue detected"
            : "Invalid image: No issue detected";
      });
    } catch (e) {
      setState(() {
        _isValidating = false;
        _isImageValidated = false;
        _validationMessage = "Validation failed: $e";
      });
    }
  }

  /// Opens gallery to pick an image.
  Future<void> _pickImageFromGallery() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      await _validateAndSetImage(File(image.path));
    }
  }

  /// Opens camera to take a new picture.
  Future<void> _pickImageFromCamera() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      await _validateAndSetImage(File(image.path));
    }
  }

  /// Shows a bottom sheet to choose image source (Gallery or Camera).
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

  /// Submits the report after validating all required fields.
  Future<void> _submitReport() async {
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
    if (!_isImageValidated) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please upload a valid image showing an infrastructure issue.")),
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

  // ------------------------- UI Builders -------------------------

  /// Builds container holding input fields (dropdown, textfield, image upload, map selector).
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

  /// Builds the dropdown for selecting issue type.
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
            const DropdownMenuItem(
              value: "Choose Issue Type",
              child: Text("Choose Issue Type"),
            ),
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

  /// Builds the description text field.
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

  /// Builds the image upload section with validation message.
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
              : Column(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.file(
                        _selectedImage!,
                        height: 160,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(height: 8),
                    if (_isValidating)
                      const CircularProgressIndicator()
                    else
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            _isImageValidated
                                ? Icons.check_circle
                                : Icons.error,
                            color: _isImageValidated ? Colors.green : Colors.red,
                          ),
                          const SizedBox(width: 8),
                          Flexible(
                            child: Text(
                              _validationMessage,
                              style: TextStyle(
                                color: _isImageValidated
                                    ? Colors.green
                                    : Colors.red,
                                fontSize: 14,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
        ),
      ),
    );
  }

  /// Builds button to select location from map.
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

  /// Builds "Report Issue" submit button.
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

  /// Builds main UI.
  @override
  Widget build(BuildContext context) {
    return Container(
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
              icon:
                  const Icon(Icons.account_circle, color: Colors.black, size: 28),
              onPressed: () =>
                  Navigator.pushReplacementNamed(context, "/profile"),
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
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
              const SizedBox(height: 40),
              _buildInputFieldsContainer(),
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
