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
          // यह बटन सिर्फ तभी दिखेगा जब AuthService क्रिएटर को पहचान लेगा
          if (provider.isCreator)
            IconButton(
              icon: Icon(provider.viewMode == ViewMode.creator ? Icons.smart_toy : Icons.admin_panel_settings),
              onPressed: () => provider.toggleViewMode(),
            )
        ],
      ),
      body: provider.viewMode == ViewMode.creator 
          ? _buildCreatorDashboard(provider) 
          : _buildStandardUserInterface(provider),
    );
  }

  Widget _buildStandardUserInterface(JarvisStateProvider provider) {
    return Stack(
      children: [
        Row(
          children: [
            Container(width: 280, color: Colors.black87, child: _buildSidebar(provider)),
            Expanded(child: Center(child: Text(provider.aiOutput, style: const TextStyle(color: Colors.white)))),
          ],
        ),
        const AiAssistantOverlay(),
      ],
    );
  }

  Widget _buildCreatorDashboard(JarvisStateProvider provider) {
    return Container(
      color: Colors.black,
      child: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(20.0),
            child: Text("CREATOR EVOLUTION DASHBOARD", style: TextStyle(color: Colors.greenAccent, fontSize: 22, fontWeight: FontWeight.bold)),
          ),
          Expanded(
            child: ListView(
              children: [
                ListTile(
                  leading: const Icon(Icons.code, color: Colors.white),
                  title: const Text("EVOLVE SYSTEM (PUSH PATCH)", style: TextStyle(color: Colors.white)),
                  onTap: () => provider.triggerEvolution('{"update": "system_patch_01"}'),
                ),
                ListTile(
                  leading: const Icon(Icons.settings, color: Colors.white),
                  title: const Text("SYSTEM STABILITY AUDIT", style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSidebar(JarvisStateProvider provider) {
    return ListView(
      children: [
        ExpansionTile(
          initiallyExpanded: true,
          title: const Text("TOOLS", style: TextStyle(color: Colors.white)),
          children: ActiveTool.values.map((tool) => ListTile(
            title: Text(tool.name.toUpperCase(), style: const TextStyle(color: Colors.white70)),
            onTap: () => provider.setActiveTool(tool),
          )).toList(),
        ),
      ],
    );
  }
}
