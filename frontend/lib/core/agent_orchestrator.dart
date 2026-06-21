import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AgentOrchestrator extends ChangeNotifier {
  List<Map<String, String>> chatHistory = [];
  bool isThinking = false;

  // Hugging Face API Setup
  final String hfApiUrl = 'https://api-inference.huggingface.co/models/YOUR_MODEL_NAME'; // अपना मॉडल नाम यहाँ डालें
  final String hfApiKey = 'Bearer YOUR_HUGGING_FACE_API_KEY'; // अपनी API Key यहाँ डालें

  void addMessage(String sender, String message) {
    chatHistory.add({'sender': sender, 'message': message});
    notifyListeners();
  }

  Future<void> processCommand(String command) async {
    addMessage('User', command);
    isThinking = true;
    notifyListeners();

    // AI Agent Orchestration Logic - कमांड को पहचानना
    String response = "";
    
    if (command.toLowerCase().contains("form") || command.toLowerCase().contains("csc")) {
      response = "[System: Executing CSC Automation Protocol...]";
      // यहाँ हम भविष्य में CSC Automation का फंक्शन कॉल करेंगे
    } else if (command.toLowerCase().contains("call")) {
      response = "[System: Accessing Call Manager...]";
      // यहाँ Call Manager का फंक्शन कॉल होगा
    } else if (command.toLowerCase().contains("media") || command.toLowerCase().contains("studio")) {
      response = "[System: Initializing Media Studio...]";
      // यहाँ Media Studio का फंक्शन कॉल होगा
    } else {
      // Default: Send to Hugging Face LLM
      response = await fetchHuggingFaceResponse(command);
    }

    isThinking = false;
    addMessage('Jarvis', response);
    notifyListeners();
  }

  Future<String> fetchHuggingFaceResponse(String input) async {
    try {
      final response = await http.post(
        Uri.parse(hfApiUrl),
        headers: {
          'Authorization': hfApiKey,
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          "inputs": input,
          "parameters": {"max_new_tokens": 250}
        }),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data[0]['generated_text'] ?? "Error generating response.";
      } else {
        return "System Warning: Backend connection failed. Status: ${response.statusCode}";
      }
    } catch (e) {
      return "System Error: Unable to reach Hugging Face backend. Exception: $e";
    }
  }
}
