// File: lib/services/diagnostic_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;

class DiagnosticService {
  static Future<String> testConnection(String email, String phone, String password) async {
    try {
      final response = await http.post(
        Uri.parse('https://your-hugging-face-url.hf.space/login'), // यहाँ अपना Hugging Face लिंक डालो
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'phone': phone,
          'password': password
        }),
      );
      
      if (response.statusCode == 200) {
        return "SUCCESS (200): Identity Verified. Server is Online.";
      } else {
        return "ERROR (${response.statusCode}): ${response.body}";
      }
    } catch (e) {
      return "FATAL ERROR: Server Unreachable. Check URL or Internet.";
    }
  }
}

