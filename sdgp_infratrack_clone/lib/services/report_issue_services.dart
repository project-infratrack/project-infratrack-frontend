import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:infratrack/helper/api_config.dart';

class ReportIssueServices {
  /// Submits a new report as multipart/form-data.
  ///
  /// The backend expects a form-data request with the following fields:
  /// - userId
  /// - reportType
  /// - description
  /// - location
  /// - image (as a file upload)
  /// - latitude
  /// - longitude
  /// - priorityLevel
  /// - thumbsUp
  /// - thumbsDown
  /// - thumbsUpUsers (as JSON string)
  /// - thumbsDownUsers (as JSON string)
  /// 
  /// [token] is the Bearer token for authentication.
  static Future<dynamic> submitReport({
    required String userId,
    required String reportType,
    required String description,
    required String location,
    required String image, // File path for the image. Pass an empty string if no image.
    required double latitude,
    required double longitude,
    String priorityLevel = "Pending",
    int thumbsUp = 0,
    int thumbsDown = 0,
    List<String> thumbsUpUsers = const [],
    List<String> thumbsDownUsers = const [],
    required String token,
  }) async {
    final uri = Uri.parse('${ApiConfig.baseUrl}/users/report/submit');
    var request = http.MultipartRequest('POST', uri);

    // Set the Bearer token.
    request.headers['Authorization'] = 'Bearer $token';

    // Add all fields as strings.
    request.fields['userId'] = userId;
    request.fields['reportType'] = reportType;
    request.fields['description'] = description;
    request.fields['location'] = location;
    request.fields['latitude'] = latitude.toString();
    request.fields['longitude'] = longitude.toString();
    request.fields['priorityLevel'] = priorityLevel;
    request.fields['thumbsUp'] = thumbsUp.toString();
    request.fields['thumbsDown'] = thumbsDown.toString();
    request.fields['thumbsUpUsers'] = jsonEncode(thumbsUpUsers);
    request.fields['thumbsDownUsers'] = jsonEncode(thumbsDownUsers);

    // Attach image file if provided.
    if (image.isNotEmpty) {
      request.files.add(await http.MultipartFile.fromPath('image', image));
    } else {
      request.fields['image'] = "";
    }

    // Debug: Print the request fields.
    print("Submitting report with fields: ${request.fields}");

    try {
      final response = await request.send();
      final responseBody = await response.stream.bytesToString();
      if (response.statusCode == 200 || response.statusCode == 201) {
        try {
          return jsonDecode(responseBody);
        } on FormatException {
          return responseBody;
        }
      } else {
        throw Exception(
          'Report submission failed. Status: ${response.statusCode}\nBody: $responseBody',
        );
      }
    } catch (error) {
      rethrow;
    }
  }
}
