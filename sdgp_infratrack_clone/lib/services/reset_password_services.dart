import 'dart:convert';
import 'package:http/http.dart' as http;
import '../helper/api_config.dart';

class ResetPasswordServices {
  static Future<bool> resetPassword({
    required String token,
    required String idNumber,
    required String newPassword,
    required String confirmPassword,
  }) async {
    final uri = Uri.parse('${ApiConfig.baseUrl}/users/reset-password');

    try {
      final response = await http.post(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token', // token comes from OTP verification
        },
        body: jsonEncode({
          'idNumber': idNumber,
          'newPassword': newPassword,
          'confirmPassword': confirmPassword,
        }),
      );

      // Debug print (optional, helps in development)
      print('Reset Password Response: ${response.statusCode} - ${response.body}');

      return response.statusCode == 200;
    } catch (e) {
      print('Error resetting password: $e');
      return false;
    }
  }
}
