import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/background_service.dart';

enum SecurityLevel { voice, face, biometrics, pin, recovery }
enum ActiveTool { none, word, excel, ppt, pdf, video, photo, browser }

class JarvisStateProvider extends ChangeNotifier {
  // 1. Security State (Steps 1-4)
  SecurityLevel _currentLevel = SecurityLevel.voice;
  bool _isFullyAuthenticated = false;
  
  // 2. God Mode / UI State (Steps 8-10)
  ActiveTool _activeTool = ActiveTool.none;
  bool _isListening = false;
  
  // 3. System State (Step 11)
  bool _isSystemRunning = false;

  // Getters
  SecurityLevel get currentLevel => _currentLevel;
  bool get isFullyAuthenticated => _isFullyAuthenticated;
  ActiveTool get activeTool => _activeTool;
  bool get isListening => _isListening;
  bool get isSystemRunning => _isSystemRunning;

  JarvisStateProvider() { _initApp(); }

  Future<void> _initApp() async {
    _currentLevel = SecurityLevel.voice;
    notifyListeners();
  }

  // Security Logic
  void completeAuth() {
    _isFullyAuthenticated = true;
    _startSystem(); // ऑथेंटिकेशन के बाद बैकग्राउंड सिस्टम चालू
    notifyListeners();
  }

  // Background System Start
  void _startSystem() {
    _isSystemRunning = true;
    JarvisBackgroundService.startBackgroundTask();
    notifyListeners();
  }

  // Tool Switching
  void setActiveTool(ActiveTool tool) {
    _activeTool = tool;
    notifyListeners();
  }

  // Floating AI Logic
  void toggleListening() {
    _isListening = !_isListening;
    notifyListeners();
  }

  // API Call Execution (Integrated)
  Future<void> executeCommand(String command) async {
    // यहाँ API कॉल आएगी जो हम स्टेप 5-7 में बना चुके हैं
    debugPrint("Executing: $command");
    notifyListeners();
  }
}
