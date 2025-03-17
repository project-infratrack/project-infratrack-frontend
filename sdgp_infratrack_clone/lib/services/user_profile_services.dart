// lib/services/user_profile_services.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:infratrack/helper/api_config.dart';
import 'package:infratrack/model/user_profile_model.dart';

class UserProfileServices {
  /// GET /api/users/profile
  /// Returns a UserProfile object for the logged-in user.
  static Future<UserProfile> getUserProfile(String token) async {
    final uri = Uri.parse('${ApiConfig.baseUrl}/users/profile');
    try {
      final response = await http.get(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return UserProfile.fromJson(data);
      } else {
        throw Exception(
          'Failed to fetch user profile. Status: ${response.statusCode}\nBody: ${response.body}',
        );
      }
    } catch (error) {
      rethrow;
    }
  }

  /// PUT /api/users/profile
  /// Updates the user profile data.
  /// Accepts a UserProfile object and returns the updated UserProfile.
  static Future<UserProfile> updateUserProfile(UserProfile profile, String token) async {
    final uri = Uri.parse('${ApiConfig.baseUrl}/users/profile');
    try {
      final response = await http.put(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(profile.toJson()),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return UserProfile.fromJson(data);
      } else {
        throw Exception(
          'Failed to update user profile. Status: ${response.statusCode}\nBody: ${response.body}',
        );
      }
    } catch (error) {
      rethrow;
    }
  }
}
