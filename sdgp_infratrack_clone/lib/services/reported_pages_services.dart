// lib/services/reported_pages_services.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:infratrack/helper/api_config.dart';
import 'package:infratrack/model/view_report_model.dart';

class ReportedPagesServices {
  /// GET /api/users/report/history/{reportId}
  /// Retrieves report details for the given reportId.
  static Future<ViewReportsModel> getReportById(String reportId, String token) async {
    final uri = Uri.parse('${ApiConfig.baseUrl}/users/report/history/$reportId');
    final response = await http.get(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return ViewReportsModel.fromJson(data);
    } else {
      throw Exception(
        'Failed to load report. Status: ${response.statusCode}\nBody: ${response.body}',
      );
    }
  }
}
