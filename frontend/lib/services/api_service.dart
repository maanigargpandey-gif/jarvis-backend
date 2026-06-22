import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = "https://maanigargpande-jarvis-backend.hf.space";
  
  // Neural Engine से डेटा स्ट्रीम करने का लॉजिक (Step 13)
  static Stream<String> streamAiResponse(String command, String authToken) async* {
    final url = Uri.parse('$baseUrl/stream_response');
    
    // यहाँ हम सर्वर से लाइव रिस्पॉन्स मंगवा रहे हैं
    final response = await http.post(
      url,
      headers: {"Authorization": "Bearer $authToken", "Content-Type": "application/json"},
      body: jsonEncode({"command": command}),
    );

    if (response.statusCode == 200) {
      yield response.body; 
    } else {
      yield "Neural Engine Error: Connection Failed";
    }
  }
}
