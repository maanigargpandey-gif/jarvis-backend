import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum SecurityLevel { voice, face, biometrics, pin, recovery }

class JarvisStateProvider extends ChangeNotifier {
  SecurityLevel _currentLevel = SecurityLevel.voice;
  int _attemptCount = 0;
  bool _isFullyAuthenticated = false;

  SecurityLevel get currentLevel => _currentLevel;
  int get attemptCount => _attemptCount;
  bool get isFullyAuthenticated => _isFullyAuthenticated;

  // वेरिफिकेशन फेल होने का लॉजिक (3-Attempt Rule)
  void recordFailure() {
    _attemptCount++;
    if (_attemptCount >= 3) {
      _escalateSecurity();
    }
    notifyListeners();
  }

  void _escalateSecurity() {
    _attemptCount = 0; // लिमिट रीसेट
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

  void completeAuth() {
    _isFullyAuthenticated = true;
    notifyListeners();
  }
}
