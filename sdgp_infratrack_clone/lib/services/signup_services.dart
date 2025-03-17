import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:infratrack/helper/api_config.dart';

class SignUpServices {
  /// Registers a user by sending a POST request to /api/users/register.
  ///
  /// If the server returns valid JSON, the method returns the decoded JSON (Map or List).
  /// If the server returns plain text (e.g. "User registered successfully"), it returns the raw text.
  /// Otherwise, it throws an exception if the status code indicates an error.
  static Future registerUser({
    required String idNumber,
    required String firstName,
    required String lastName,
    required String username,
    required String email,
    required String password,
    required String mobileNumber,
  }) async {
    final uri = Uri.parse('${ApiConfig.baseUrl}/users/register');

    final body = {
      "idNumber": idNumber,
      "firstName": firstName,
      "lastName": lastName,
      "username": username,
      "email": email,
      "password": password,
      "mobileNumber": mobileNumber,
    };

    try {
      final response = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Registration was successful; try to parse as JSON
        try {
          return jsonDecode(response.body);
        } on FormatException {
          // If not valid JSON, just return the raw text
          return response.body;
        }
      } else {
        throw Exception(
          'Registration failed. Status: ${response.statusCode}\nBody: ${response.body}',
        );
      }
    } catch (error) {
      rethrow; // Let the UI handle the error
    }
  }
}
