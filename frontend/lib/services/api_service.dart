import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = "https://maanigargpande-jarvis-backend.hf.space";
  
  // Neural Engine से डेटा स्ट्रीम करने का लॉजिक
  static Stream<String> streamAiResponse(String command, String authToken) async* {
    final url = Uri.parse('$baseUrl/stream_response');
    final response = await http.post(
      url,
      headers: {"Authorization": "Bearer $authToken", "Content-Type": "application/json"},
      body: jsonEncode({"command": command}),
    );

    if (response.statusCode == 200) {
      // बैकएंड से आता हुआ डेटा प्रोसेस करना
      yield response.body; 
    } else {
      yield "Neural Engine Error: Connection Failed";
    }
  }

  static Future<Map<String, dynamic>> sendCommand({required String command, required String role, required String authToken}) async {
    return {"status": "success", "message": "Neural Engine Synced"};
  }
}
