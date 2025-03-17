import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:infratrack/helper/api_config.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginServices {
  /// Sends a POST request to the /users/login endpoint.
  static Future userLogin(String idNumber, String password) async {
    final uri = Uri.parse('${ApiConfig.baseUrl}/users/login');

    final body = {
      "idNumber": idNumber,
      "password": password,
    };

    try {
      final response = await http.post(
        uri,
        body: jsonEncode(body),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        // Parse the JSON response
        final data = jsonDecode(response.body);
        final token = data["token"] as String?;

        if (token != null && token.isNotEmpty) {
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('auth_token', token);
        }

        return data;
      } else {
        throw Exception("Login failed");
      }
    } catch (error) {
      rethrow;
    }
  }
}
