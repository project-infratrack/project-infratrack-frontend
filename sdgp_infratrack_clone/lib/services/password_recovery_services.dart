import 'dart:convert';
import 'package:http/http.dart' as http;
import '../helper/api_config.dart';

class PasswordRecoveryServices {
  static Future<bool> requestPasswordReset(String idNumber) async {
    final uri = Uri.parse('${ApiConfig.baseUrl}/users/forget-password');
    try {
      final response = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'idNumber': idNumber}),
      );
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  static Future<String?> verifyOtp(String idNumber, String otp) async {
    final uri = Uri.parse('${ApiConfig.baseUrl}/users/verify-otp');
    try {
      final response = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'idNumber': idNumber, 'otp': otp}),
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['token'];
      }
      return null;
    } catch (e) {
      return null;
    }
  }
}
