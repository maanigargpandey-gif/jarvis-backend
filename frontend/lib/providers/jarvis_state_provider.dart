import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../services/api_service.dart';
import '../services/background_service.dart';

enum SecurityLevel { voice, face, biometrics, pin, recovery }
enum ActiveTool { none, word, excel, ppt, pdf, video, photo, browser }

class JarvisStateProvider extends ChangeNotifier {
  final _box = Hive.box('jarvis_data');

  // स्टेट्स
  SecurityLevel _currentLevel = SecurityLevel.voice;
  bool _isFullyAuthenticated = false;
  ActiveTool _activeTool = ActiveTool.none;
  bool _isListening = false;
  String _aiOutput = ""; // यह न्यूरल रिस्पॉन्स है

  // गेटर्स
  SecurityLevel get currentLevel => _currentLevel;
  bool get isFullyAuthenticated => _isFullyAuthenticated;
  ActiveTool get activeTool => _activeTool;
  bool get isListening => _isListening;
  String get aiOutput => _aiOutput;

  JarvisStateProvider() { _loadState(); }

  void _loadState() {
    _isFullyAuthenticated = _box.get('auth', defaultValue: false);
    notifyListeners();
  }

  void completeAuth() {
    _isFullyAuthenticated = true;
    _box.put('auth', true);
    JarvisBackgroundService.startBackgroundTask();
    notifyListeners();
  }

  void setActiveTool(ActiveTool tool) {
    _activeTool = tool;
    notifyListeners();
  }

  // न्यूरल इंजन कमांड (लाइव स्ट्रीम)
  Future<void> executeNeuralCommand(String command) async {
    _aiOutput = "Thinking...";
    notifyListeners();
    
    // स्ट्रीम लिसनर
    await for (final chunk in ApiService.streamAiResponse(command, "mani_jarvis_admin_786")) {
      _aiOutput = chunk;
      notifyListeners();
    }
  }

  void toggleListening() {
    _isListening = !_isListening;
    notifyListeners();
  }

  Future<void> logout() async {
    _isFullyAuthenticated = false;
    await _box.clear();
    notifyListeners();
  }
}
