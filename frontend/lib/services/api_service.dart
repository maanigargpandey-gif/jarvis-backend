import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  // TODO: यहाँ अपना असली Hugging Face / Render URL डालना (जैसे https://maanigarg...hf.space)
  static const String baseUrl = "https://maanigargpande-jarvis-backend.hf.space/"; 
  
  // तुम्हारा मास्टर पासवर्ड जो auth.py से मैच करेगा
  static const String creatorToken = "1005@Maani";

  static Future<String> sendMessageToJarvis(String query, String workspaceMode) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/chat'),
        headers: {
          'Content-Type': 'application/json',
          'X-Creator-Token': creatorToken, // Security Lock
        },
        body: jsonEncode({
          'query': query,
          'workspace_mode': workspaceMode,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['reply'] ?? "No response received.";
      } else if (response.statusCode == 401 || response.statusCode == 403) {
        return "⚠️ Authentication Failed. Creator token is invalid.";
      } else {
        return "⚠️ Error: Server responded with status ${response.statusCode}";
      }
    } catch (e) {
      return "⚠️ Connection Error: Is the backend server running? ($e)";
    }
  }
}
