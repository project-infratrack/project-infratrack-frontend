import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:infratrack/helper/api_config.dart';
import 'package:infratrack/model/report_model.dart';



class HomeServices {
  static Future<ReportModel> fetchReport() async {
    // Use ApiConfig to build your endpoint
    final uri = Uri.parse('${ApiConfig.baseUrl}/report');

    try {
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return ReportModel.fromJson(data);
      } else {
        throw Exception(
          'Failed to load report. Status code: ${response.statusCode}'
        );
      }
    } catch (error) {
      rethrow;
    }
  }
}
