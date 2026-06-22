import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = "https://maanigargpande-jarvis-backend.hf.space";
  static const String authToken = "mani_jarvis_admin_786";

  // फाइलें फेच करने का नया फंक्शन
  static Future<List<dynamic>> fetchVaultFiles(String role) async {
    final url = Uri.parse('$baseUrl/get_nexus_files');
    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json", "Authorization": "Bearer $authToken"},
        body: jsonEncode({"user_role": role}),
      );
      if (response.statusCode == 200) {
        return jsonDecode(response.body)['files'];
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  // पुराने फंक्शन्स वैसे ही रहेंगे (processCommand, etc.)
  // ... (बाकी कोड वही है)
}
