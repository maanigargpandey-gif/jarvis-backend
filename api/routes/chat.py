import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  // 1. आपका लाइव Hugging Face सर्वर लिंक (यहीं से ऐप सर्वर से बात करेगा)
  static const String baseUrl = "https://maanigargpande-jarvis-backend.hf.space/api"; 
  
  // 2. आपका असली मास्टर पासवर्ड / पिन (गॉड-मोड के लिए)
  static const String creatorToken = "1005@Maani"; 

  // 🛡️ मास्टर हेडर (हर रिक्वेस्ट में आपका यह पासवर्ड छिप कर जाएगा, ताकि कोई और एक्सेस न कर सके)
  static Map<String, String> get _headers => {
        "Content-Type": "application/json",
        "X-Creator-Token": creatorToken,
      };

  // 🧠 1. सेंड चैट / कमांड (To LLM Router)
  static Future<String> sendCommand(String prompt) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/chat/send"),
        headers: _headers,
        body: jsonEncode({
          "prompt": prompt,
          "user_id": "Mani_Pandey_God"
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['response']['message'] ?? "Command Executed.";
      } else {
        return "Error: ${response.statusCode} - Access Denied. Check HF Server.";
      }
    } catch (e) {
      return "Connection Error: Backend Offline or Link is wrong. ($e)";
    }
  }

  // 🎨 2. मीडिया जनरेशन (To Media Studio)
  static Future<Map<String, dynamic>> generateMedia(String prompt) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/media/generate"),
        headers: _headers,
        body: jsonEncode({"prompt": prompt}),
      );
      return jsonDecode(response.body);
    } catch (e) {
      return {"status": "error", "message": e.toString()};
    }
  }

  // 📱 3. सिस्टम चेक (Phone Doctor)
  static Future<Map<String, dynamic>> checkPhoneHealth() async {
    try {
      final response = await http.get(
        Uri.parse("$baseUrl/system/phone-health"),
        headers: _headers,
      );
      return jsonDecode(response.body);
    } catch (e) {
      return {"status": "error", "message": "Failed to reach Phone Doctor"};
    }
  }

  // 🔒 4. नेक्सस वॉल्ट (Encrypt/Decrypt Data)
  static Future<String> encryptVaultData(String rawData) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/vault/encrypt"),
        headers: _headers,
        body: jsonEncode({"data": rawData}),
      );
      if (response.statusCode == 200) {
        return jsonDecode(response.body)['encrypted_data'];
      }
      return "Encryption Failed";
    } catch (e) {
      return "Vault Error";
    }
  }
}
