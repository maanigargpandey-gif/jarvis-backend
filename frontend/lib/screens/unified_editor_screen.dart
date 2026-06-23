// File: lib/screens/unified_editor_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/jarvis_state_provider.dart';
import '../widgets/ai_assistant_overlay.dart';
import '../services/diagnostic_service.dart'; // यह फाइल हमने अभी बनाई थी

class UnifiedEditorScreen extends StatelessWidget {
  const UnifiedEditorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Provider को एक्सेस कर रहे हैं
    final provider = Provider.of<JarvisStateProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          provider.isCreator ? "CREATOR MODE: ACTIVE (Mani Pandey)" : "JARVIS OS",
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.black,
        actions: [
          // क्रिएटर के लिए मोड स्विच
          if (provider.isCreator)
            IconButton(
              icon: const Icon(Icons.smart_toy, color: Colors.greenAccent),
              onPressed: () {
                // यहाँ मोड स्विच का लॉजिक हो सकता है
              },
            ),
        ],
      ),
      body: Stack(
        children: [
          // 1. मेन कंटेंट लेयर
          Container(
            color: Colors.black,
            child: provider.isCreator 
                ? _buildCreatorDashboard(context, provider) 
                : _buildStandardUserInterface(context),
          ),
          
          // 2. AI ओवरले लेयर (हमेशा ऊपर)
          const AiAssistantOverlay(),
        ],
      ),
    );
  }

  // साधारण यूजर के लिए इंटरफेस
  Widget _buildStandardUserInterface(BuildContext context) {
    return const Center(
      child: Text(
        "Standard User Interface", 
        style: TextStyle(color: Colors.white, fontSize: 18)
      ),
    );
  }

  // क्रिएटर डैशबोर्ड (इसमें डायग्नोस्टिक बटन है)
  Widget _buildCreatorDashboard(BuildContext context, JarvisStateProvider provider) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        const Text(
          "Welcome, Mani Pandey",
          style: TextStyle(color: Colors.greenAccent, fontSize: 22, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 20),
        
        // डायग्नोस्टिक बटन (इंटीग्रेटेड)
        Card(
          color: Colors.grey[900],
          child: ListTile(
            leading: const Icon(Icons.bug_report, color: Colors.amber),
            title: const Text("RUN DIAGNOSTIC TEST", style: TextStyle(color: Colors.white)),
            subtitle: const Text("Verify system identity and server link", style: TextStyle(color: Colors.white70)),
            onTap: () async {
              // बटन दबाते ही डायग्नोस्टिक चलेगा
              String result = await DiagnosticService.testConnection(
                "maanigargpandey@gmail.com", 
                "+91 86041 41005", 
                "1005@Maani"
              );
              // रिजल्ट को AI ओवरले में भेजेंगे
              provider.updateAiOutput(result);
            },
          ),
        ),
        
        const SizedBox(height: 20),
        
        // इवोल्यूशन बटन
        ListTile(
          leading: const Icon(Icons.upgrade, color: Colors.blueAccent),
          title: const Text("EVOLVE SYSTEM", style: TextStyle(color: Colors.white)),
          onTap: () {
            provider.updateAiOutput("Evolution Protocol Initiated...");
          },
        ),
      ],
    );
  }
}
