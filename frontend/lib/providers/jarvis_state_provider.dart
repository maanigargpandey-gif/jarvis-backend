import 'package:flutter/material.dart';
import '../services/api_service.dart'; // इसे ऐड करें

enum AIState { idle, listening, processing, responding, error }
enum CreatorMode { standard, godMode }
enum WorkspaceMode { chat, browser, document, media, code }

class ChatMessage {
  final String content;
  final bool isUser;
  final DateTime timestamp;
  ChatMessage({required this.content, required this.isUser, required this.timestamp});
}

class AIStateProvider extends ChangeNotifier {
  AIState _currentState = AIState.idle;
  CreatorMode _creatorMode = CreatorMode.godMode;
  WorkspaceMode _workspaceMode = WorkspaceMode.chat;
  bool _isInputExpanded = false;
  List<ChatMessage> _messages = [];
  
  AIState get currentState => _currentState;
  CreatorMode get creatorMode => _creatorMode;
  WorkspaceMode get workspaceMode => _workspaceMode;
  bool get isInputExpanded => _isInputExpanded;
  List<ChatMessage> get messages => _messages;
  
  void toggleInput() {
    _isInputExpanded = !_isInputExpanded;
    notifyListeners();
  }
  
  void setWorkspaceMode(WorkspaceMode mode) {
    _workspaceMode = mode;
    notifyListeners();
  }

  // 👇 यहाँ असली API बाइंडिंग हुई है
  Future<void> sendMessage(String content) async {
    // 1. Add user message
    _messages.add(ChatMessage(content: content, isUser: true, timestamp: DateTime.now()));
    _currentState = AIState.processing;
    notifyListeners();
    
    // 2. Call Python Backend
    String modeString = _workspaceMode.toString().split('.').last;
    String aiResponse = await ApiService.sendMessageToJarvis(content, modeString);
    
    // 3. Show AI Response
    _messages.add(ChatMessage(content: aiResponse, isUser: false, timestamp: DateTime.now()));
    _currentState = AIState.idle;
    notifyListeners();
  }
}
