import 'package:flutter/material.dart';

enum WorkspaceMode { chat, document, code, creative, social }

class WorkspaceProvider extends ChangeNotifier {
  WorkspaceMode _currentMode = WorkspaceMode.chat;
  bool _isSplitView = false;
  double _splitRatio = 0.8; // 80/20 split

  WorkspaceMode get currentMode => _currentMode;
  bool get isSplitView => _isSplitView;
  double get splitRatio => _splitRatio;

  void setMode(WorkspaceMode mode) {
    _currentMode = mode;
    _isSplitView = mode != WorkspaceMode.chat;
    notifyListeners();
  }

  void toggleSplitView() {
    _isSplitView = !_isSplitView;
    notifyListeners();
  }

  void setSplitRatio(double ratio) {
    _splitRatio = ratio.clamp(0.2, 0.9);
    notifyListeners();
  }
}

