import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/jarvis_state_provider.dart';
import '../services/api_service.dart';

class AiAssistantOverlay extends StatelessWidget {
  const AiAssistantOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<JarvisStateProvider>(context);

    // यह ओवरले हमेशा स्क्रीन के नीचे रहेगा
    return Positioned(
      bottom: 20,
      right: 20,
      child: Material(
        color: Colors.transparent,
        child: Container(
          width: 300,
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.8),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.greenAccent),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text("JARVIS AI", style: TextStyle(color: Colors.greenAccent, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              // यहाँ AI का रिस्पॉन्स लाइव आएगा
              Text(
                provider.aiOutput, 
                style: const TextStyle(color: Colors.white),
                maxLines: 5,
                overflow: TextOverflow.ellipsis,
              ),
              if (provider.isCreator)
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: ElevatedButton(
                    onPressed: () => provider.executeNeuralCommand("Test API Connection"),
                    child: const Text("Run API Diagnostic"),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
