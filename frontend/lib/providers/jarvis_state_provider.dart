import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../services/background_service.dart';

enum SecurityLevel { voice, face, biometrics, pin, recovery }
enum ActiveTool { none, word, excel, ppt, pdf, video, photo, browser }

class JarvisStateProvider extends ChangeNotifier {
  final _box = Hive.box('jarvis_data');

  SecurityLevel _currentLevel = SecurityLevel.voice;
  bool _isFullyAuthenticated = false;
  ActiveTool _activeTool = ActiveTool.none;
  bool _isListening = false;

  SecurityLevel get currentLevel => _currentLevel;
  bool get isFullyAuthenticated => _isFullyAuthenticated;
  ActiveTool get activeTool => _activeTool;
  bool get isListening => _isListening;

  JarvisStateProvider() { _loadState(); }

  // डेटाबेस से पिछला स्टेटस लोड करना
  void _loadState() {
    _isFullyAuthenticated = _box.get('auth', defaultValue: false);
    notifyListeners();
  }

  // सिक्योरिटी पास होने पर डेटा सेव करना
  void completeAuth() {
    _isFullyAuthenticated = true;
    _box.put('auth', true); 
    JarvisBackgroundService.startBackgroundTask();
    notifyListeners();
  }

  // टूल सेट करना और सेव करना
  void setActiveTool(ActiveTool tool) {
    _activeTool = tool;
    _box.put('last_tool', tool.index); // टूल का नंबर सेव कर लिया
    notifyListeners();
  }

  // फ्लोटिंग AI
  void toggleListening() {
    _isListening = !_isListening;
    notifyListeners();
  }

  // लॉगआउट पर सब कुछ डिलीट कर देना
  Future<void> logout() async {
    _isFullyAuthenticated = false;
    await _box.clear();
    notifyListeners();
  }
}
