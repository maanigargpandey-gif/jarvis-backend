import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;

class ApiService {
  // तुम्हारा लाइव Hugging Face का URL
  static const String baseUrl = "https://maanigargpande-jarvis-backend.hf.space";
  
  // तुम्हारा ऑथेंटिकेशन टोकन
  static const String authToken = "mani_jarvis_admin_786"; 

  // 1. प्रोसेस कमांड भेजने का लॉजिक
  static Future<Map<String, dynamic>> processCommand(String command, String role) async {
    final url = Uri.parse('$baseUrl/process_command');

    try {
      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $authToken",
          "X-API-KEY": authToken 
        },
        body: jsonEncode({
          "command": command,
          "user_role": role,
          "attachments": [1]
        }),
      ).timeout(const Duration(seconds: 60));

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        return {
          "status": "error",
          "message": "System Error: ${response.statusCode}",
          "type": "text"
        };
      }
    } on TimeoutException {
      return {
        "status": "evolving",
        "message": "JARVIS is evolving. Please wait...",
        "type": "text"
      };
    } catch (e) {
      return {
        "status": "error",
        "message": "Connection to Nexus failed. Check server.",
        "type": "text"
      };
    }
  }

  // 2. Nexus Vault में फाइल सेव करने का लॉजिक
  static Future<Map<String, dynamic>> saveToNexusVault(String filePath, String role) async {
    final url = Uri.parse('$baseUrl/process_command'); 

    try {
      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $authToken"
        },
        body: jsonEncode({
          "command": "save_to_nexus",
          "user_role": role,
          "details": {"path": filePath}
        }),
      ).timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        return {"status": "error", "message": "Failed to lock in Nexus Vault."};
      }
    } catch (e) {
      return {"status": "error", "message": "Vault connection error."};
    }
  }
}
