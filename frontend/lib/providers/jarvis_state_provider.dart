import 'package:flutter/material.dart';

enum AIState { idle, listening, processing, responding, error }
enum CreatorMode { standard, godMode }
enum WorkspaceMode { chat, browser, document, media, code }

class AIStateProvider extends ChangeNotifier {
  AIState _currentState = AIState.idle;
  CreatorMode _creatorMode = CreatorMode.standard;
  WorkspaceMode _workspaceMode = WorkspaceMode.chat;
  bool _isInputExpanded = false;
  String _currentQuery = '';
  List<ChatMessage> _messages = [];
  
  AIState get currentState => _currentState;
  CreatorMode get creatorMode => _creatorMode;
  WorkspaceMode get workspaceMode => _workspaceMode;
  bool get isInputExpanded => _isInputExpanded;
  String get currentQuery => _currentQuery;
  List<ChatMessage> get messages => _messages;
  
  void toggleInput() {
    _isInputExpanded = !_isInputExpanded;
    notifyListeners();
  }
  
  void setAIState(AIState state) {
    _currentState = state;
    notifyListeners();
  }
  
  void toggleCreatorMode() {
    _creatorMode = _creatorMode == CreatorMode.standard ? CreatorMode.godMode : CreatorMode.standard;
    notifyListeners();
  }
  
  void setWorkspaceMode(WorkspaceMode mode) {
    _workspaceMode = mode;
    notifyListeners();
  }
  
  void sendMessage(String content) {
    _messages.add(ChatMessage(content: content, isUser: true, timestamp: DateTime.now()));
    setAIState(AIState.processing);
    
    Future.delayed(const Duration(seconds: 2), () {
      _messages.add(ChatMessage(
        content: "I understand you're asking about: $content. Let me process that for you.",
        isUser: false,
        timestamp: DateTime.now(),
      ));
      setAIState(AIState.idle);
    });
    notifyListeners();
  }
  
  void shareMessage(int index) => print('📤 Sharing message at index: $index');
  void copyMessage(int index) => print('📋 Copying message at index: $index');
  void provideFeedback(int index, bool isPositive) => print('👍 Feedback for message $index');
  void regenerateResponse(int index) {
    print('🔄 Regenerating response for message index: $index');
    setAIState(AIState.processing);
  }
}

class ChatMessage {
  final String content;
  final bool isUser;
  final DateTime timestamp;
  final Map<String, dynamic>? metadata;
  
  ChatMessage({required this.content, required this.isUser, required this.timestamp, this.metadata});
}
