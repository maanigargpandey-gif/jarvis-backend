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
            )
        ],
      ),
      body: Column(
        children: [
          // स्टेप 19: प्रोएक्टिव सजेशन बार
          if (provider.proactiveSuggestion != null)
            Container(
              color: Colors.blueAccent.withOpacity(0.3),
              padding: const EdgeInsets.all(10),
              child: Text("JARVIS SUGGESTS: ${provider.proactiveSuggestion}", style: const TextStyle(color: Colors.white)),
            ),
          Expanded(
            child: provider.viewMode == ViewMode.creator 
                ? _buildCreatorDashboard(provider) 
                : _buildStandardUserInterface(provider),
          ),
        ],
      ),
    );
  }

  Widget _buildStandardUserInterface(JarvisStateProvider provider) {
    return Stack(
      children: [
        Center(child: Text(provider.aiOutput, style: const TextStyle(color: Colors.white))),
        const AiAssistantOverlay(),
      ],
    );
  }

  Widget _buildCreatorDashboard(JarvisStateProvider provider) {
    return Container(
      color: Colors.black,
      child: ListView(
        children: [
          const Padding(padding: EdgeInsets.all(20), child: Text("CREATOR EVOLUTION DASHBOARD", style: TextStyle(color: Colors.greenAccent))),
          ListTile(
            title: const Text("EVOLVE SYSTEM", style: TextStyle(color: Colors.white)),
            onTap: () => provider.triggerEvolution('{"update": "system_patch_01"}'),
          ),
        ],
      ),
    );
  }
}
