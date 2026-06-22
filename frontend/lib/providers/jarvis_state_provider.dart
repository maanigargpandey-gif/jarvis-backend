import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/api_service.dart';

// ये हमारी सिक्योरिटी की लेयर्स हैं
enum SecurityStage { none, voiceVerified, faceVerified, authenticated }

class JarvisStateProvider extends ChangeNotifier {
  // Security State
  SecurityStage _authStage = SecurityStage.none;
  String _currentRole = "Guest";
  
  // Getters
  SecurityStage get authStage => _authStage;
  String get currentRole => _currentRole;
  bool get isLoggedIn => _authStage == SecurityStage.authenticated;

  JarvisStateProvider() { _initApp(); }

  Future<void> _initApp() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _currentRole = prefs.getString('jarvis_role') ?? "Guest";
    // ऐप रीस्टार्ट होने पर सिक्योरिटी रीसेट होगी (जैसा आपने कहा)
    _authStage = SecurityStage.none; 
    notifyListeners();
  }

  // सिक्योरिटी को आगे बढ़ाने का लॉजिक
  void updateSecurityStage(SecurityStage newStage) {
    _authStage = newStage;
    notifyListeners();
  }

  // रोल सेट करना
  Future<void> loginUser(String role) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('jarvis_role', role);
    _currentRole = role;
    // लॉगिन के बाद हम पहली लेयर (Voice) पर भेजेंगे
    notifyListeners();
  }

  // रिसेट/फॉरगेट पासवर्ड का लॉजिक (Level 4 - Fail Safe)
  Future<void> triggerPasswordReset() async {
    // यहाँ OTP वेरिफिकेशन का लॉजिक आएगा
    _authStage = SecurityStage.none;
    notifyListeners();
  }
}
