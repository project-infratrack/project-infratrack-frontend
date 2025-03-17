// lib/services/home_services.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:infratrack/helper/api_config.dart';
import 'package:infratrack/model/report_model.dart';

class HomeServices {
  /// GET /api/users/report/get-all
  static Future<List<ReportModel>> getAllReports(String token) async {
    final uri = Uri.parse('${ApiConfig.baseUrl}/users/report/get-all');
    try {
      final response = await http.get(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      print("Raw response: ${response.body}");

      if (response.body.isNotEmpty) {
        final List<dynamic> jsonList = jsonDecode(response.body);
        return jsonList.map((item) => ReportModel.fromJson(item)).toList();
      } else {
        throw Exception(
          'Failed to fetch reports. Status: ${response.statusCode}\nBody: ${response.body}',
        );
      }
    } catch (error) {
      rethrow;
    }
  }

  static Future<dynamic> thumbsUp(String reportId, String token) async {
    final uri = Uri.parse('${ApiConfig.baseUrl}/users/report/$reportId/thumbs-up');
    return _postWithoutBody(uri, token);

  }

  static Future<dynamic> thumbsDown(String reportId, String token) async {
    final uri = Uri.parse('${ApiConfig.baseUrl}/users/report/$reportId/thumbs-down');
    return _postWithoutBody(uri, token);
  }

  static Future<dynamic> removeThumbsUp(String reportId, String token) async {
    final uri = Uri.parse('${ApiConfig.baseUrl}/users/report/$reportId/remove-thumbs-up');
    return _postWithoutBody(uri, token);
   
  }

  static Future<dynamic> removeThumbsDown(String reportId, String token) async {
    final uri = Uri.parse('${ApiConfig.baseUrl}/users/report/$reportId/remove-thumbs-down');
    return _postWithoutBody(uri, token);
  }

  /// Helper for simple POST requests with no request body, including Bearer token
  static Future<dynamic> _postWithoutBody(Uri uri, String token) async {
    try {
      final response = await http.post(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        // Try to parse as JSON
        try {
          return jsonDecode(response.body);
        } catch (_) {
          // If not valid JSON, return raw body
          return response.body;
        }
      } else {
        throw Exception(
          '${response.body}',
        );
      }
    } catch (error) {
      rethrow;
    }
  }
}
