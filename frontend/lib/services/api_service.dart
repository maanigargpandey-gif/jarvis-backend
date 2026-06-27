import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/constants.dart';

class ApiService {
  static const String baseUrl = AppConstants.baseUrl;
  static const String apiV1 = AppConstants.apiVersion;

  static Future<Map<String, dynamic>> login({
    required String method,
    String? authData,
    String? pin,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl$apiV1/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'method': method,
        'auth_data': authData,
        'pin': pin,
      }),
    );
    return jsonDecode(response.body);
  }

  static Future<bool> verifyMfa({
    required String sessionToken,
    required String step,
    String? pin,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl$apiV1/auth/mfa/verify'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'session_token': sessionToken,
        'step': step,
        'pin': pin,
      }),
    );
    final data = jsonDecode(response.body);
    return data['status'] == 'step_completed' || data['status'] == 'mfa_complete';
  }

  static Future<Map<String, dynamic>> sendMessage({
    required String query,
    String workspaceMode = 'chat',
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl$apiV1/chat/send'),
      headers: {
        'Content-Type': 'application/json',
        'X-Creator-Token': AppConstants.adminToken,
      },
      body: jsonEncode({
        'query': query,
        'workspace_mode': workspaceMode,
      }),
    );
    return jsonDecode(response.body);
  }

  static Future<Map<String, dynamic>> generateHashtags({
    required String topic,
    String platform = 'instagram',
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl$apiV1/social/generate-hashtags'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'topic': topic,
        'platform': platform,
      }),
    );
    return jsonDecode(response.body);
  }

  static Future<Map<String, dynamic>> calculate(String expression) async {
    final response = await http.post(
      Uri.parse('$baseUrl$apiV1/memory/calculate'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'expression': expression}),
    );
    return jsonDecode(response.body);
  }

  static Future<Map<String, dynamic>> getAdminDashboard() async {
    final response = await http.get(
      Uri.parse('$baseUrl$apiV1/admin/dashboard'),
      headers: {
        'Content-Type': 'application/json',
        'X-Creator-Token': AppConstants.adminToken,
      },
    );
    return jsonDecode(response.body);
  }
}
