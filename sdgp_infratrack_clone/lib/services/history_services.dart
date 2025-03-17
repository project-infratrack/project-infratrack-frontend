import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:infratrack/helper/api_config.dart';
import 'package:infratrack/model/history_report_model.dart';

class HistoryServices {
  /// GET /api/users/report/get-by-user
  /// Returns a list of HistoryReportModel objects for the current user.
  static Future<List<HistoryReportModel>> getUserReports(String token) async {
    final uri = Uri.parse('${ApiConfig.baseUrl}/users/report/get-by-user');

    try {
      final response = await http.get(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = jsonDecode(response.body);
        return jsonList
            .map((e) => HistoryReportModel.fromJson(e))
            .toList();
      } else {
        throw Exception(
          'Failed to fetch user reports. Status: ${response.statusCode}\nBody: ${response.body}',
        );
      }
    } catch (error) {
      rethrow;
    }
  }
}
