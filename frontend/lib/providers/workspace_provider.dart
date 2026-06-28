import 'package:flutter/material.dart';

// ये वो सारे मोड्स हैं जो आपने PDF में डिफाइन किए थे
enum WorkspaceMode { chat, document, creative, code, vault }

class WorkspaceProvider extends ChangeNotifier {
  // Default mode 'chat' रहेगा
  WorkspaceMode _currentMode = WorkspaceMode.chat;

  WorkspaceMode get currentMode => _currentMode;

  // Omni-UI Switcher: जब आप कमांड देंगे, ये फंक्शन कॉल होगा
  void changeMode(WorkspaceMode newMode) {
    if (_currentMode != newMode) {
      _currentMode = newMode;
      notifyListeners(); // पलक झपकते ही UI बदल जाएगा
    }
  }
}
