import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/api_service.dart';

class JarvisStateProvider extends ChangeNotifier {
  String _currentRole = "Guest"; 
  bool _isLoggedIn = false;
  List<Map<String, dynamic>> _messages = [];
  bool _isProcessing = false;

  String get currentRole => _currentRole;
  bool get isLoggedIn => _isLoggedIn;
  List<Map<String, dynamic>> get messages => _messages;
  bool get isProcessing => _isProcessing;

  JarvisStateProvider() {
    _initApp();
  }

  Future<void> _initApp() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _currentRole = prefs.getString('jarvis_role') ?? "Guest";
    _isLoggedIn = prefs.getBool('is_logged_in') ?? false;
    notifyListeners();
  }

  // लॉगिन के बाद रोल सेट करना
  Future<void> loginUser(String role) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('jarvis_role', role);
    await prefs.setBool('is_logged_in', true);
    _currentRole = role;
    _isLoggedIn = true;
    notifyListeners();
  }

  // लॉग आउट
  Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    _isLoggedIn = false;
    _currentRole = "Guest";
    notifyListeners();
  }

  Future<void> processUserCommand(String text) async {
    if (text.trim().isEmpty) return;
    _messages.add({"sender": "user", "type": "text", "text": text});
    _isProcessing = true;
    notifyListeners();

    final response = await ApiService.processCommand(text, _currentRole);
    
    _isProcessing = false;
    _messages.add({
      "sender": "jarvis",
      "type": response['type'] ?? 'text',
      "text": response['message'] ?? "System anomaly."
    });
    notifyListeners();
  }
}
