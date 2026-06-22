import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../services/api_service.dart';
import '../services/music_service.dart';

enum ActiveTool { none, word, excel, ppt, pdf, video, photo, browser, music, geo }

class JarvisStateProvider extends ChangeNotifier {
  final _box = Hive.box('jarvis_data');
  final MusicService _musicService = MusicService();

  // स्टेट्स
  ActiveTool _activeTool = ActiveTool.none;
  String _aiOutput = "Jarvis System Online..."; // Neural Output (Step 13)
  bool _isMusicPlaying = false;

  ActiveTool get activeTool => _activeTool;
  String get aiOutput => _aiOutput;
  bool get isMusicPlaying => _isMusicPlaying;

  // 1. Neural Engine Sync (Step 13)
  Future<void> executeNeuralCommand(String command) async {
    _aiOutput = "Thinking...";
    notifyListeners();
    
    await for (final chunk in ApiService.streamAiResponse(command, "mani_jarvis_admin_786")) {
      _aiOutput = chunk;
      notifyListeners();
    }
  }

  // 2. Tool & Lifestyle Integration (Step 14)
  void setActiveTool(ActiveTool tool) {
    _activeTool = tool;
    
    // म्यूजिक या जिओ-स्फीयर ट्रिगर
    if (tool == ActiveTool.music) {
      _toggleMusic();
    }
    notifyListeners();
  }

  void _toggleMusic() {
    _isMusicPlaying = !_isMusicPlaying;
    if (_isMusicPlaying) {
      _musicService.playBackgroundMusic("https://www.example.com/ambient_music.mp3");
    } else {
      _musicService.stopMusic();
    }
    notifyListeners();
  }
}
