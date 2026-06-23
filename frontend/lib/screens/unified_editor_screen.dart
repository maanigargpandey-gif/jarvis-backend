import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/jarvis_state_provider.dart';
import '../widgets/ai_assistant_overlay.dart';

class UnifiedEditorScreen extends StatelessWidget {
  const UnifiedEditorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<JarvisStateProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(provider.viewMode == ViewMode.creator ? "CREATOR MODE: ACTIVE" : "JARVIS OS"),
        actions: [
          if (provider.isCreator)
            IconButton(
              icon: Icon(provider.viewMode == ViewMode.creator ? Icons.smart_toy : Icons.admin_panel_settings),
              onPressed: () => provider.toggleViewMode(),
            ),
        ],
      ),
      // Stack का इस्तेमाल किया है ताकि Overlay ऊपर आ सके
      body: Stack(
        children: [
          // मेन कंटेंट
          provider.viewMode == ViewMode.creator 
              ? _buildCreatorDashboard(provider) 
              : _buildStandardUserInterface(provider),
          
          // AI Assistant Overlay यहाँ फिक्स्ड है
          const AiAssistantOverlay(),
        ],
      ),
    );
  }

  Widget _buildStandardUserInterface(Provider) {
    return const Center(child: Text("Main OS Interface", style: TextStyle(color: Colors.white)));
  }

  Widget _buildCreatorDashboard(provider) {
    return Container(
      color: Colors.black,
      child: ListView(
        children: [
          ListTile(
            title: const Text("EVOLVE SYSTEM", style: TextStyle(color: Colors.white)),
            onTap: () => provider.triggerEvolution('{"update": "system_patch_01"}'),
          ),
        ],
      ),
    );
  }
}
