import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  // अपने लाइव बैकएंड का URL यहाँ डालें (जैसे Ngrok या क्लाउड URL)
  static const String baseUrl = "https://your-backend-url.com"; 
  
  // बैकएंड सिक्योरिटी टोकन
  static const String authToken = "YOUR_JARVIS_AUTH_TOKEN"; 

  // 1. मेन कमांड प्रोसेसिंग (विथ इवोल्यूशन टाइमआउट हैंडलिंग)
  static Future<Map<String, dynamic>> processCommand(String command, String role) async {
    final url = Uri.parse('$baseUrl/process_command');
    
    try {
      // Self-Evolution के कारण टाइमआउट को 60 सेकंड रखा है
      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $authToken",
          "X-API-KEY": authToken // तुम्हारे बैकएंड में X-API-KEY भी है
        },
        body: jsonEncode({
          "command": command,
          "user_role": role,
          "attachments": [] 
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
        "message": "JARVIS is evolving and writing new code for this feature. Please wait...",
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
          "Authorization": "Bearer $authToken",
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
