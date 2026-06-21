import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/api_service.dart';

class JarvisStateProvider extends ChangeNotifier {
  // 1. Core State Variables
  String _currentRole = "Creator";
  List<Map<String, dynamic>> _messages = [];
  bool _isProcessing = false;
  bool _isEvolving = false; // बैकएंड सेल्फ-इवोल्यूशन ट्रैक करने के लिए

  // 2. Girgit UI Theme Colors (डिफ़ॉल्ट साइबर ब्लू/स्यान)
  Color _accentColor = Colors.cyanAccent;
  Color _bgBlendColor = const Color(0xFF1E3A8A); 

  // Getters (UI को डेटा देने के लिए)
  String get currentRole => _currentRole;
  List<Map<String, dynamic>> get messages => _messages;
  bool get isProcessing => _isProcessing;
  bool get isEvolving => _isEvolving;
  Color get accentColor => _accentColor;
  Color get bgBlendColor => _bgBlendColor;

  JarvisStateProvider() {
    _loadUserRole();
    // ऐप खुलते ही वेलकम मैसेज
    _messages.add({
      "sender": "jarvis",
      "type": "text",
      "text": "System Online. Secure connection to Nexus established. Awaiting command."
    });
  }

  // रोल लोड करना (Local Storage से)
  Future<void> _loadUserRole() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _currentRole = prefs.getString('jarvis_role') ?? "Guest";
    notifyListeners();
  }

  // रोल सेट करना (लॉगिन के टाइम)
  Future<void> setRole(String role) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('jarvis_role', role);
    _currentRole = role;
    notifyListeners();
  }

  // 🦎 Girgital Theme Logic (फ़ाइल के प्रकार के हिसाब से रंग बदलना)
  void updateThemeForFileType(String type) {
    switch (type.toLowerCase()) {
      case 'excel':
        _accentColor = Colors.greenAccent;
        _bgBlendColor = const Color(0xFF064E3B);
        break;
      case 'doc':
      case 'word':
        _accentColor = Colors.blueAccent;
        _bgBlendColor = const Color(0xFF1E3A8A);
        break;
      case 'pdf':
        _accentColor = Colors.redAccent;
        _bgBlendColor = const Color(0xFF7F1D1D);
        break;
      case 'ppt':
        _accentColor = Colors.orangeAccent;
        _bgBlendColor = const Color(0xFF7C2D12);
        break;
      case 'video':
        _accentColor = Colors.purpleAccent;
        _bgBlendColor = const Color(0xFF4C1D95);
        break;
      case 'music':
      case 'audio':
        _accentColor = Colors.tealAccent;
        _bgBlendColor = const Color(0xFF0F766E);
        break;
      case 'photo':
      case 'image':
        _accentColor = Colors.pinkAccent;
        _bgBlendColor = const Color(0xFF831843);
        break;
      case 'code':
        _accentColor = Colors.yellowAccent;
        _bgBlendColor = const Color(0xFF713F12);
        break;
      default:
        _accentColor = Colors.cyanAccent;
        _bgBlendColor = const Color(0xFF1E3A8A);
    }
    notifyListeners();
  }

  // 🚀 बैकएंड को कमांड भेजना और रिस्पॉन्स हैंडल करना
  Future<void> processUserCommand(String text) async {
    if (text.trim().isEmpty) return;

    // यूज़र का मैसेज UI में जोड़ें
    _messages.add({"sender": "user", "type": "text", "text": text});
    _isProcessing = true;
    _isEvolving = false;
    updateThemeForFileType("text"); // डिफ़ॉल्ट थीम पर वापस आएँ
    notifyListeners();

    // ApiService (Step 2) को कॉल करें
    final response = await ApiService.processCommand(text, _currentRole);

    // अगर बैकएंड 60 सेकंड से ज़्यादा ले रहा है (Self-Evolution Triggered)
    if (response['status'] == 'evolving') {
      _isEvolving = true;
      _messages.add({
        "sender": "jarvis",
        "type": "text",
        "text": response['message'] // "JARVIS is evolving..." मैसेज
      });
      notifyListeners();
      return; // यहाँ हम UI को अटकाएंगे नहीं, यूज़र कुछ और कर सकता है
    }

    _isProcessing = false;
    _isEvolving = false;

    // बैकएंड से सक्सेस रिस्पॉन्स
    if (response['status'] == 'success' || response['status'] == 'completed') {
      String replyType = response['file_format'] ?? response['type'] ?? 'text';
      
      // थीम अपडेट करें नए आउटपुट के हिसाब से
      if (replyType != 'text') {
         updateThemeForFileType(replyType);
      }

      // जार्विस का आउटपुट सेव करें
      _messages.add({
        "sender": "jarvis",
        "type": replyType,
        "text": response['message'] ?? "Task completed successfully.",
        "fileName": response['file_name'] ?? "",
        "fileSize": response['file_size'] ?? "Unknown Size",
        "fileUrl": response['download_link'] ?? response['file_path'] ?? "" // Nexus Vault/Editor के लिए
      });
    } else {
      // एरर हैंडलिंग
      _messages.add({
        "sender": "jarvis",
        "type": "text",
        "text": response['message'] ?? "System encountered an anomaly."
      });
      _accentColor = Colors.redAccent; // एरर पर लाल रंग
    }

    notifyListeners();
  }

  // 💾 Nexus Vault में सेव करने का फंक्शन
  Future<void> saveArtifactToNexus(String filePath) async {
    final response = await ApiService.saveToNexusVault(filePath, _currentRole);
    
    // UI में एक छोटा सिस्टम मैसेज दिखाएं
    _messages.add({
      "sender": "system",
      "type": "text",
      "text": response['status'] == 'success' 
          ? "Artifact successfully locked in Nexus Vault."
          : "Failed to save artifact: ${response['message']}"
    });
    notifyListeners();
  }
}
