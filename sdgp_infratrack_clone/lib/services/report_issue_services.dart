// lib/services/report_issue_services.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:infratrack/helper/api_config.dart';

class ReportIssueServices {
  static Future<dynamic> submitReport({
    required String userId,
    required String reportType,
    required String description,
    required String location,
    required String image,
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

    final body = {
      "userId": userId,
      "reportType": reportType,
      "description": description,
      "location": location,
      "image": image,
      "latitude": latitude,
      "longitude": longitude,
      "priorityLevel": priorityLevel,
      "thumbsUp": thumbsUp,
      "thumbsDown": thumbsDown,
      "thumbsUpUsers": thumbsUpUsers,
      "thumbsDownUsers": thumbsDownUsers,
    };

    // Debug print to check what is being sent.
    print("Submitting report with body: ${jsonEncode(body)}");

    try {
      final response = await http.post(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(body),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        try {
          return jsonDecode(response.body);
        } on FormatException {
          return response.body;
        }
      } else {
        throw Exception(
          'Report submission failed. Status: ${response.statusCode}\nBody: ${response.body}',
        );
      }
    } catch (error) {
      rethrow;
    }
  }
}
