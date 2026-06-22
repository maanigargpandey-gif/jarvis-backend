import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/api_service.dart';

class JarvisStateProvider extends ChangeNotifier {
  String _currentRole = "Guest";
  bool _isLoggedIn = false;
  List<Map<String, dynamic>> _messages = [];
  List<dynamic> _files = []; // फाइल लिस्ट का नया स्टेट

  String get currentRole => _currentRole;
  bool get isLoggedIn => _isLoggedIn;
  List<dynamic> get files => _files;

  JarvisStateProvider() { _initApp(); }

  Future<void> _initApp() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _currentRole = prefs.getString('jarvis_role') ?? "Guest";
    _isLoggedIn = prefs.getBool('is_logged_in') ?? false;
    notifyListeners();
  }

  // फाइलें लोड करना (Server से)
  Future<void> loadVaultFiles() async {
    _files = await ApiService.fetchVaultFiles(_currentRole);
    notifyListeners();
  }

  Future<void> loginUser(String role) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('jarvis_role', role);
    await prefs.setBool('is_logged_in', true);
    _currentRole = role;
    _isLoggedIn = true;
    notifyListeners();
  }
  
  // ... (बाकी पुराने फंक्शन्स)
}
