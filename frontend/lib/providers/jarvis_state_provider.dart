import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../services/api_service.dart';
import '../services/music_service.dart';
import '../services/evolution_engine.dart';
import '../services/auth_service.dart';

enum ActiveTool { none, word, excel, ppt, pdf, video, photo, browser, music, geo, evolution }
enum ViewMode { user, creator }

class JarvisStateProvider extends ChangeNotifier {
  final _box = Hive.box('jarvis_data');
  final MusicService _musicService = MusicService();
  final EvolutionEngine _evolutionEngine = EvolutionEngine();

  bool _isFullyAuthenticated = false;
  bool _isCreator = false;
  ViewMode _viewMode = ViewMode.user;
  ActiveTool _activeTool = ActiveTool.none;
  String _aiOutput = "System Online.";

  bool get isFullyAuthenticated => _isFullyAuthenticated;
  bool get isCreator => _isCreator;
  ViewMode get viewMode => _viewMode;
  ActiveTool get activeTool => _activeTool;
  String get aiOutput => _aiOutput;

  JarvisStateProvider() {
    _initSystem();
  }

  void _initSystem() {
    _isFullyAuthenticated = _box.get('auth', defaultValue: false);
    String savedEmail = _box.get('email', defaultValue: "");
    String savedPhone = _box.get('phone', defaultValue: "");
    
    // यहाँ AuthService से क्रिएटर स्टेटस कंफर्म हो रहा है
    _isCreator = AuthService.isCreator(savedEmail, savedPhone);
    notifyListeners();
  }

  void login(String email, String phone) {
    _box.put('auth', true);
    _box.put('email', email);
    _box.put('phone', phone);
    
    _isCreator = AuthService.isCreator(email, phone);
    _isFullyAuthenticated = true;
    notifyListeners();
  }

  void toggleViewMode() {
    if (_isCreator) {
      _viewMode = (_viewMode == ViewMode.user) ? ViewMode.creator : ViewMode.user;
      notifyListeners();
    }
  }

  Future<void> executeNeuralCommand(String command) async {
    _aiOutput = "Processing...";
    notifyListeners();
    await for (final chunk in ApiService.streamAiResponse(command, "mani_jarvis_admin_786")) {
      _aiOutput = chunk;
      notifyListeners();
    }
  }

  void setActiveTool(ActiveTool tool) {
    _activeTool = tool;
    notifyListeners();
  }

  Future<void> triggerEvolution(String patchData) async {
    if (_isCreator) {
      await _evolutionEngine.applyPatch(patchData);
      _aiOutput = "System Evolved.";
      notifyListeners();
    }
  }
}
