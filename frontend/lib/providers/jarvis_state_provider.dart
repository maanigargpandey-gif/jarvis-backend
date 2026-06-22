import 'dart:async';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../services/api_service.dart';
import '../services/evolution_engine.dart';
import '../services/music_service.dart';

class JarvisStateProvider extends ChangeNotifier {
  final _box = Hive.box('jarvis_data');
  final EvolutionEngine _evolutionEngine = EvolutionEngine();
  
  // 1-15 स्टेप्स का डेटा
  bool _isFullyAuthenticated = false;
  ActiveTool _activeTool = ActiveTool.none;
  String _aiOutput = "System Synced.";
  
  // स्टेप 16: ऑब्जर्वर स्टेट
  List<Map<String, dynamic>> _pendingUpgrades = [];
  List<Map<String, dynamic>> get pendingUpgrades => _pendingUpgrades;

  JarvisStateProvider() {
    _initSystem();
    _startEcosystemObserver(); // स्टेप 16 का स्कैन लूप शुरू
  }

  void _initSystem() {
    _isFullyAuthenticated = _box.get('auth', defaultValue: false);
    notifyListeners();
  }

  // स्टेप 16: सिस्टम खुद को स्कैन करता है
  void _startEcosystemObserver() {
    Timer.periodic(const Duration(minutes: 5), (timer) async {
      if (_isFullyAuthenticated) {
        final upgrade = await _evolutionEngine.scanForUpgrades();
        if (upgrade != null && upgrade['available'] == true) {
          _pendingUpgrades.add(upgrade);
          notifyListeners(); // क्रिएटर डैशबोर्ड को नोटिफिकेशन भेजने के लिए ट्रिगर
          debugPrint("Jarvis Observer: Found new upgrade! Creator notified.");
        }
      }
    });
  }

  // क्रिएटर का फाइनल कमांड (Evolution Trigger)
  Future<void> executeCreatorCommand(String patchData) async {
    await _evolutionEngine.applyPatch(patchData);
    _pendingUpgrades.clear(); // कमांड मिलने के बाद लिस्ट क्लियर
    notifyListeners();
  }

  // बाकी 1-15 स्टेप्स की फंक्शनलिटी यहाँ बरकरार है...
}
