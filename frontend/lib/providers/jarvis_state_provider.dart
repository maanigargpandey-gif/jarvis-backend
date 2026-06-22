import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../services/api_service.dart';
import '../services/music_service.dart';
import '../services/background_service.dart';
import '../services/evolution_engine.dart'; // नया मॉड्यूल: इवोल्यूशन के लिए

enum ActiveTool { none, word, excel, ppt, pdf, video, photo, browser, music, geo, evolution }

class JarvisStateProvider extends ChangeNotifier {
  final _box = Hive.box('jarvis_data');
  final MusicService _musicService = MusicService();
  final EvolutionEngine _evolutionEngine = EvolutionEngine(); // सेल्फ इवोल्यूशन इंजन

  // 1. Core System State (Step 1-4: Security)
  bool _isFullyAuthenticated = false;
  bool get isFullyAuthenticated => _isFullyAuthenticated;

  // 2. UI & Tools (Step 8-14)
  ActiveTool _activeTool = ActiveTool.none;
  ActiveTool get activeTool => _activeTool;
  
  // 3. System Feedback (Step 13: Neural Engine)
  String _aiOutput = "System Synced & Online...";
  String get aiOutput => _aiOutput;

  // 4. Error/System Audit (Step 15: Stability)
  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  // 5. Creator Evolution (Step 15: Self Evolution Integration)
  bool _isEvolving = false;
  bool get isEvolving => _isEvolving;

  JarvisStateProvider() { _initSystem(); }

  // --- INTEGRATION LOGIC ---
  
  void _initSystem() {
    _isFullyAuthenticated = _box.get('auth', defaultValue: false);
    notifyListeners();
  }

  // Security Auth (Step 1-4)
  void completeAuth() {
    _isFullyAuthenticated = true;
    _box.put('auth', true);
    JarvisBackgroundService.startBackgroundTask();
    notifyListeners();
  }

  // Neural Engine Sync (Step 13)
  Future<void> executeNeuralCommand(String command) async {
    try {
      _aiOutput = "Thinking...";
      notifyListeners();
      await for (final chunk in ApiService.streamAiResponse(command, "mani_jarvis_admin_786")) {
        _aiOutput = chunk;
        notifyListeners();
      }
    } catch (e) {
      _triggerError("Neural Engine Error: ${e.toString()}");
    }
  }

  // Creator Dashboard Evolution Trigger (Step 15 Integration)
  Future<void> triggerEvolution(String patchData) async {
    _isEvolving = true;
    notifyListeners();
    try {
      // यहाँ वो कोड है जो सर्वर से लॉजिक फेच करके फ्रंट-एंड बदलता है
      await _evolutionEngine.applyPatch(patchData); 
      _aiOutput = "System Evolution Complete. New Logic Patched.";
    } catch (e) {
      _triggerError("Evolution Failed: ${e.toString()}");
    } finally {
      _isEvolving = false;
      notifyListeners();
    }
  }

  // Tool Switching & Music/Geo (Step 14 Integration)
  void setActiveTool(ActiveTool tool) {
    _activeTool = tool;
    if (tool == ActiveTool.music) _toggleMusic();
    if (tool == ActiveTool.geo) _activateGeoSphere(); // जिओ-स्फीयर ट्रिगर
    notifyListeners();
  }

  void _toggleMusic() {
    // म्यूजिक सर्विस और स्टेट का तालमेल
    _musicService.playBackgroundMusic("https://www.example.com/ambient_music.mp3");
  }

  void _activateGeoSphere() {
    // जिओ-स्फीयर लोकेशन इंटेलिजेंस
  }

  // Error/Stability Handler (Step 15)
  void _triggerError(String error) {
    _errorMessage = error;
    notifyListeners();
    Future.delayed(const Duration(seconds: 3), () {
      _errorMessage = null;
      notifyListeners();
    });
  }
}
