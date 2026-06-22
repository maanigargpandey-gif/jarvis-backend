import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/api_service.dart';

// सिक्योरिटी की लेयर्स
enum SecurityLevel { voice, face, biometrics, pin, recovery }

class JarvisStateProvider extends ChangeNotifier {
  // --- स्टेट वेरिएबल्स ---
  String _currentRole = "Guest";
  bool _isLoggedIn = false;
  
  // सिक्योरिटी लेयर स्टेट
  SecurityLevel _currentLevel = SecurityLevel.voice;
  int _attemptCount = 0;
  bool _isFullyAuthenticated = false;

  // ऐप और चैट स्टेट
  List<Map<String, dynamic>> _messages = [];
  List<dynamic> _files = [];
  bool _isProcessing = false;

  // --- गेटर्स ---
  String get currentRole => _currentRole;
  bool get isLoggedIn => _isLoggedIn;
  SecurityLevel get currentLevel => _currentLevel;
  int get attemptCount => _attemptCount;
  bool get isFullyAuthenticated => _isFullyAuthenticated;
  List<Map<String, dynamic>> get messages => _messages;
  List<dynamic> get files => _files;
  bool get isProcessing => _isProcessing;

  JarvisStateProvider() {
    _initApp();
  }

  // ऐप इनिशियलाइजेशन
  Future<void> _initApp() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _currentRole = prefs.getString('jarvis_role') ?? "Guest";
    _isLoggedIn = prefs.getBool('is_logged_in') ?? false;
    _currentLevel = SecurityLevel.voice; // सुरक्षा के लिए हर बार रिसेट
    _isFullyAuthenticated = false;
    notifyListeners();
  }

  // लॉगिन और रोल सेट करना
  Future<void> loginUser(String role) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('jarvis_role', role);
    await prefs.setBool('is_logged_in', true);
    _currentRole = role;
    _isLoggedIn = true;
    notifyListeners();
  }

  // सिक्योरिटी फेल्योर लॉजिक (3-Attempt Rule)
  void recordFailure() {
    _attemptCount++;
    if (_attemptCount >= 3) {
      _escalateSecurity();
    }
    notifyListeners();
  }

  // सिक्योरिटी लेयर बदलना
  void _escalateSecurity() {
    _attemptCount = 0;
    if (_currentLevel == SecurityLevel.voice) {
      _currentLevel = SecurityLevel.face;
    } else if (_currentLevel == SecurityLevel.face) {
      _currentLevel = SecurityLevel.biometrics;
    } else if (_currentLevel == SecurityLevel.biometrics) {
      _currentLevel = SecurityLevel.pin;
    } else {
      _currentLevel = SecurityLevel.recovery;
    }
    notifyListeners();
  }

  // वेरिफिकेशन सक्सेसफुल
  void completeAuth() {
    _isFullyAuthenticated = true;
    notifyListeners();
  }

  // API के जरिए बैकएंड से बातचीत (Bridge)
  Future<void> processUserCommand(String text) async {
    if (text.trim().isEmpty) return;

    _messages.add({"sender": "user", "type": "text", "text": text});
    _isProcessing = true;
    notifyListeners();

    // ApiService का उपयोग
    final response = await ApiService.sendCommand(
      command: text,
      role: _currentRole,
      authToken: "mani_jarvis_admin_786",
    );
    
    _isProcessing = false;
    
    if (response['status'] == 'success') {
      _messages.add({"sender": "jarvis", "type": "text", "text": response['message']});
    } else {
      _messages.add({"sender": "jarvis", "type": "error", "text": "System Failure: ${response['message']}"});
    }
    notifyListeners();
  }

  // Vault फाइलें लोड करना
  Future<void> loadVaultFiles() async {
    _files = await ApiService.fetchVaultFiles(_currentRole);
    notifyListeners();
  }

  // लॉग आउट
  Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    _isLoggedIn = false;
    _currentLevel = SecurityLevel.voice;
    _isFullyAuthenticated = false;
    _currentRole = "Guest";
    notifyListeners();
  }
}
