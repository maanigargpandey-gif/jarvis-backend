import 'package:flutter/material.dart';

class ContextEngine {
  // यह फाइल तुम्हारे हर एक्शन को रिकॉर्ड करती है और 'प्रोएक्टिव' सुझाव बनाती है
  final Map<String, int> _usageFrequency = {};

  void logAction(String toolName) {
    _usageFrequency[toolName] = (_usageFrequency[toolName] ?? 0) + 1;
    debugPrint("ContextEngine: Logged action for $toolName");
  }

  String? getProactiveSuggestion() {
    // अगर कोई टूल बहुत ज्यादा यूज हो रहा है, तो उसका सुझाव दो
    String? topTool;
    int maxUsage = 0;
    
    _usageFrequency.forEach((key, value) {
      if (value > maxUsage) {
        maxUsage = value;
        topTool = key;
      }
    });

    if (maxUsage > 3) {
      return "Seems like you are using $topTool frequently. Should I pin it to dashboard?";
    }
    return null;
  }
}

