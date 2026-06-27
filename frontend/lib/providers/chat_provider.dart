import 'package:flutter/material.dart';
import '../services/api_service.dart';

class ChatMessage {
  final String content;
  final bool isUser;
  final DateTime timestamp;
  final String? provider;

  ChatMessage({
    required this.content,
    required this.isUser,
    required this.timestamp,
    this.provider,
  });
}

class ChatProvider extends ChangeNotifier {
  List<ChatMessage> _messages = [];
  bool _isProcessing = false;
  String _currentMode = 'chat';

  List<ChatMessage> get messages => _messages;
  bool get isProcessing => _isProcessing;
  String get currentMode => _currentMode;

  void setMode(String mode) {
    _currentMode = mode;
    notifyListeners();
  }

  Future<void> sendMessage(String content) async {
    _messages.add(ChatMessage(
      content: content,
      isUser: true,
      timestamp: DateTime.now(),
    ));
    _isProcessing = true;
    notifyListeners();

    try {
      final response = await ApiService.sendMessage(
        query: content,
        workspaceMode: _currentMode,
      );

      _messages.add(ChatMessage(
        content: response['reply'] ?? 'No response',
        isUser: false,
        timestamp: DateTime.now(),
        provider: response['provider'],
      ));
    } catch (e) {
      _messages.add(ChatMessage(
        content: 'Error: ${e.toString()}',
        isUser: false,
        timestamp: DateTime.now(),
      ));
    }

    _isProcessing = false;
    notifyListeners();
  }

  void clearChat() {
    _messages.clear();
    notifyListeners();
  }
}

