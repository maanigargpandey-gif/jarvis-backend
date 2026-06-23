import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../services/auth_service.dart';

class JarvisStateProvider extends ChangeNotifier {
  final _box = Hive.box('jarvis_data');
  bool _isCreator = false;
  String _aiOutput = "System Ready - Mani Pandey";

  bool get isCreator => _isCreator;
  String get aiOutput => _aiOutput;
  bool get isFullyAuthenticated => _box.get('auth', defaultValue: false);

  JarvisStateProvider() {
    _initIdentity();
  }

  void _initIdentity() {
    String savedEmail = _box.get('email', defaultValue: "");
    _isCreator = (savedEmail == AuthService.masterEmail);
    notifyListeners();
  }

  Future<void> loginUser(String email) async {
    await _box.put('auth', true);
    await _box.put('email', email);
    _isCreator = (email == AuthService.masterEmail);
    notifyListeners();
  }

  void updateAiOutput(String message) {
    _aiOutput = message;
    notifyListeners();
  }
}
