// File: lib/widgets/ai_assistant_overlay.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/jarvis_state_provider.dart';

class AiAssistantOverlay extends StatelessWidget {
  const AiAssistantOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    // Consumer का इस्तेमाल किया है ताकि Provider बदलते ही Overlay अपडेट हो जाए
    return Consumer<JarvisStateProvider>(
      builder: (context, provider, child) {
        return Positioned(
          bottom: 50,
          right: 20,
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.9),
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: Colors.green),
            ),
            child: Text(
              provider.aiOutput,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        );
      },
    );
  }
}
