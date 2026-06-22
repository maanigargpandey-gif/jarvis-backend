import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  // हगिंग फेस का प्रोडक्शन बेस यूआरएल
  static const String baseUrl = "https://maanigargpande-jarvis-backend.hf.space";
  
  // API की सिक्योरिटी हेडर (इसे अपने बैकएंड के env से सिंक रखना)
  static Map<String, String> getHeaders(String authToken) {
    return {
      "Content-Type": "application/json",
      "Authorization": "Bearer $authToken",
      "X-API-KEY": authToken,
      "Connection": "keep-alive" // ताकि कनेक्शन बार-बार टूटे नहीं
    };
  }

  // लाइव कमांड ब्रिज (OS का मेन कम्युनिकेशन चैनल)
  static Future<Map<String, dynamic>> sendCommand({
    required String command,
    required String role,
    required String authToken,
  }) async {
    final url = Uri.parse('$baseUrl/process_command');
    
    try {
      final response = await http.post(
        url,
        headers: getHeaders(authToken),
        body: jsonEncode({
          "command": command,
          "user_role": role,
          "timestamp": DateTime.now().toIso8601String(), // सिक्योरिटी के लिए टाइमस्टैम्प
        }),
      ).timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        return {"status": "error", "message": "Backend sync failed: ${response.statusCode}"};
      }
    } catch (e) {
      return {"status": "error", "message": "Connection Lost: $e"};
    }
  }
}
