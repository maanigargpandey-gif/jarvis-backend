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
        title: Text(provider.viewMode == ViewMode.creator ? "CREATOR MODE" : "JARVIS OS"),
        actions: [
          if (provider.isCreator)
            Stack(
              children: [
                IconButton(
                  icon: Icon(provider.viewMode == ViewMode.creator ? Icons.smart_toy : Icons.admin_panel_settings),
                  onPressed: () => provider.toggleViewMode(),
                ),
                // स्टेप 17: Notification Indicator
                if (provider.notificationMessage != null)
                  Positioned(
                    right: 8, top: 8,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                    ),
                  ),
              ],
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
        Center(child: Text(provider.aiOutput, style: const TextStyle(color: Colors.white))),
        const AiAssistantOverlay(),
      ],
    );
  }

  Widget _buildCreatorDashboard(JarvisStateProvider provider) {
    return Container(
      color: Colors.black,
      child: Column(
        children: [
          if (provider.notificationMessage != null)
            Container(
              color: Colors.amber.withOpacity(0.2),
              padding: const EdgeInsets.all(16),
              child: Text("ALERT: ${provider.notificationMessage}", style: const TextStyle(color: Colors.amber)),
            ),
          ListTile(
            title: const Text("EVOLVE SYSTEM", style: TextStyle(color: Colors.white)),
            onTap: () => provider.triggerEvolution('{"update": "system_patch_01"}'),
          ),
        ],
      ),
    );
  }
}
