// lib/services/image_validation_service.dart
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:io' show Platform;
import 'package:http/http.dart' as http;

class ImageValidationService {


  static String get validationEndpoint {
    // For Android emulator, 10.0.2.2 points to host machine's localhost
    if (Platform.isAndroid) {
      return 'http://10.0.2.2:8000/predict';
    }
    // For iOS simulator
    else if (Platform.isIOS) {
      return 'http://localhost:8000/predict';
    }
    else {
      return 'http://127.0.0.1:8000/predict';
    }
  }

  static Future<Map<String, dynamic>> validateImage(File imageFile) async {
    // Create a multipart request
    var request = http.MultipartRequest('POST', Uri.parse(validationEndpoint));

    // Attach the image file
    request.files.add(await http.MultipartFile.fromPath('file', imageFile.path));

    try {
      // Send the request with timeout
      final streamedResponse = await request.send().timeout(
          const Duration(seconds: 20),
          onTimeout: () {
            throw TimeoutException('Request timed out after 20 seconds');
          }
      );

      // Process the response
      if (streamedResponse.statusCode == 200) {
        final responseBody = await streamedResponse.stream.bytesToString();
        return jsonDecode(responseBody);
      } else {
        throw Exception('Server returned ${streamedResponse.statusCode}: ${streamedResponse.reasonPhrase}');
      }
    } on SocketException catch (e) {
      throw Exception('Network error: Check if the server is running and accessible (${e.message})');
    } on TimeoutException catch (_) {
      throw Exception('Connection timed out: Server might be unreachable or overloaded');
    } catch (e) {
      throw Exception('Error validating image: $e');
    }
  }

  // For testing connectivity
  static Future<bool> testConnection() async {
    try {
      final response = await http.get(
        Uri.parse(validationEndpoint.replaceAll('/predict', '/health')),
      ).timeout(const Duration(seconds: 5));

      return response.statusCode == 200;
    } catch (_) {
      return false;
    }
  }
}