// File: lib/services/auth_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:hive_flutter/hive_flutter.dart';

class AuthService {
  static const String serverUrl = "http://localhost:5000";
  static const String masterEmail = "maanigargpandey@gmail.com";

  static Future<bool> login(String email, String phone, String password) async {
    final response = await http.post(
      Uri.parse('$serverUrl/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email,
        'phone': phone,
        'password': password
      }),
    );

    if (response.statusCode == 200) {
      var box = Hive.box('jarvis_data');
      box.put('email', email);
      box.put('auth', true);
      return true;
    }
    return false;
  }
}
