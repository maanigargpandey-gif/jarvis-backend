import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/api_service.dart';

enum SecurityLevel { voice, face, biometrics, pin, recovery }
enum ActiveTool { none, word, excel, ppt, pdf, video, photo, browser }

class JarvisStateProvider extends ChangeNotifier {
  // 1. Security State (Steps 1-4)
  SecurityLevel _currentLevel = SecurityLevel.voice;
  bool _isFullyAuthenticated = false;
  
  // 2. God Mode / UI State (Steps 8-10)
  ActiveTool _activeTool = ActiveTool.none;
  bool _isListening = false;
  bool _isProcessing = false;
  
  // Getters
  SecurityLevel get currentLevel => _currentLevel;
  bool get isFullyAuthenticated => _isFullyAuthenticated;
  ActiveTool get activeTool => _activeTool;
  bool get isListening => _isListening;
  bool get isProcessing => _isProcessing;

  JarvisStateProvider() { _initApp(); }

  Future<void> _initApp() async {
    // सिक्योरिटी और सेटिंग्स लोड करना
    _currentLevel = SecurityLevel.voice;
    notifyListeners();
  }

  // Security Logic
  void completeAuth() {
    _isFullyAuthenticated = true;
    notifyListeners();
  }

  // God Mode Tool Switching
  void setActiveTool(ActiveTool tool) {
    _activeTool = tool;
    notifyListeners();
  }

  // Floating AI Logic
  void toggleListening() {
    _isListening = !_isListening;
    notifyListeners();
  }

  // API Integration (Steps 5-7)
  Future<void> executeCommand(String command) async {
    _isProcessing = true;
    notifyListeners();
    // API Call here...
    _isProcessing = false;
    notifyListeners();
  }
}
