import 'dart:async';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../services/api_service.dart';
import '../services/music_service.dart';
import '../services/evolution_engine.dart';
import '../services/auth_service.dart';
import '../services/background_service.dart';
import '../services/neural_diagnostics.dart';
import '../services/context_engine.dart';
import '../utils/app_hardener.dart';

enum ActiveTool { none, word, excel, ppt, pdf, video, photo, browser, music, geo, evolution }
enum ViewMode { user, creator }

class JarvisStateProvider extends ChangeNotifier {
  final _box = Hive.box('jarvis_data');
  final MusicService _musicService = MusicService();
  final EvolutionEngine _evolutionEngine = EvolutionEngine();
  final ContextEngine _contextEngine = ContextEngine();

  bool _isFullyAuthenticated = false;
  bool _isCreator = false;
  ViewMode _viewMode = ViewMode.user;
  String _aiOutput = "System Hardened & Ready.";
  String? _notificationMessage;
  String? _proactiveSuggestion;

  bool get isFullyAuthenticated => _isFullyAuthenticated;
  bool get isCreator => _isCreator;
  ViewMode get viewMode => _viewMode;
  String get aiOutput => _aiOutput;
  String? get notificationMessage => _notificationMessage;
  String? get proactiveSuggestion => _proactiveSuggestion;

  JarvisStateProvider() {
    AppHardener.lockSystemIntegrity();
    _initSystem();
  }

  void _initSystem() {
    _isFullyAuthenticated = _box.get('auth', defaultValue: false);
    String savedEmail = _box.get('email', defaultValue: "");
    String savedPhone = _box.get('phone', defaultValue: "");
    _isCreator = AuthService.isCreator(savedEmail, savedPhone);
    
    if (_isFullyAuthenticated) {
      JarvisBackgroundService.startBackgroundTask((msg) {
        _notificationMessage = msg;
        notifyListeners();
      });
    }
    notifyListeners();
  }

  // --- MASTER COMMAND CENTER ---
  
  void setActiveTool(ActiveTool tool) {
    _contextEngine.logAction(tool.name);
    _proactiveSuggestion = _contextEngine.getProactiveSuggestion();
    notifyListeners();
  }

  Future<void> logSystemFailure(String moduleName, String error) async {
    String? solution = await NeuralDiagnostics.analyzeError(moduleName, error);
    if (solution != null) {
      await _evolutionEngine.applyPatch(solution);
    } else {
      _notificationMessage = "DIAGNOSTIC FAILED: $moduleName requires manual patch.";
    }
    notifyListeners();
  }

  Future<void> triggerEvolution(String patchData) async {
    if (_isCreator) {
      await _evolutionEngine.applyPatch(patchData);
      _notificationMessage = null;
      _aiOutput = "System Evolution Complete.";
      notifyListeners();
    }
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
}
