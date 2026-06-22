import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/api_service.dart';

class JarvisStateProvider extends ChangeNotifier {
  // 1. Core State
  String _currentRole = "Guest"; // डिफ़ॉल्ट Guest
  bool _isLoggedIn = false;      // क्या यूजर लॉग इन है?
  List<Map<String, dynamic>> _messages = [];

  // Getters
  String get currentRole => _currentRole;
  bool get isLoggedIn => _isLoggedIn;
  List<Map<String, dynamic>> get messages => _messages;

  JarvisStateProvider() {
    _initApp();
  }

  Future<void> _initApp() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _currentRole = prefs.getString('jarvis_role') ?? "Guest";
    _isLoggedIn = prefs.getBool('is_logged_in') ?? false;
    notifyListeners();
  }

  // लॉगिन के बाद रोल सेट करने का फंक्शन
  Future<void> loginUser(String role) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('jarvis_role', role);
    await prefs.setBool('is_logged_in', true);
    _currentRole = role;
    _isLoggedIn = true;
    notifyListeners();
  }

  // लॉग आउट करने का फंक्शन (आगे काम आएगा)
  Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    _isLoggedIn = false;
    _currentRole = "Guest";
    notifyListeners();
  }

  // ... (आपका बाकी पुराना processUserCommand लॉजिक यहाँ रहेगा)
}
