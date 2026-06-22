import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = "https://maanigargpande-jarvis-backend.hf.space";
  
  static Map<String, String> getHeaders(String authToken) {
    return {
      "Content-Type": "application/json",
      "Authorization": "Bearer $authToken",
    };
  }

  // 1. लाइव कमांड ब्रिज
  static Future<Map<String, dynamic>> sendCommand({required String command, required String role, required String authToken}) async {
    try {
      final response = await http.post(Uri.parse('$baseUrl/process_command'),
        headers: getHeaders(authToken),
        body: jsonEncode({"command": command, "user_role": role}),
      ).timeout(const Duration(seconds: 30));
      return response.statusCode == 200 ? jsonDecode(response.body) : {"status": "error"};
    } catch (e) { return {"status": "error", "message": e.toString()}; }
  }

  // 2. क्रिएटर टूल्स कॉल करने का नया ब्रिज
  static Future<Map<String, dynamic>> callCreatorTool(String toolName, String authToken) async {
    try {
      final response = await http.post(Uri.parse('$baseUrl/creator_tool/$toolName'),
        headers: getHeaders(authToken),
      ).timeout(const Duration(seconds: 30));
      return response.statusCode == 200 ? jsonDecode(response.body) : {"status": "error"};
    } catch (e) { return {"status": "error", "message": e.toString()}; }
  }

  static Future<List<dynamic>> fetchVaultFiles(String role) async {
    try {
      final response = await http.post(Uri.parse('$baseUrl/get_nexus_files'),
        headers: getHeaders("mani_jarvis_admin_786"),
        body: jsonEncode({"user_role": role}),
      );
      return response.statusCode == 200 ? jsonDecode(response.body)['files'] : [];
    } catch (e) { return []; }
  }
}
