import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/workspace_provider.dart';
import '../widgets/chat_dock.dart';

class WorkspaceSplitView extends StatelessWidget {
  const WorkspaceSplitView({super.key});

  @override
  Widget build(BuildContext context) {
    final workspaceProvider = Provider.of<WorkspaceProvider>(context);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // TOP 80% - The Active Workspace (Editor/Creative/Vault)
            Expanded(
              flex: 8,
              child: Container(
                color: Theme.of(context).scaffoldBackgroundColor,
                child: _buildActiveWorkspace(workspaceProvider.currentMode),
              ),
            ),
            
            // DIVIDER (Electric Blue line separating 80-20)
            Container(
              height: 2,
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF00E5FF).withOpacity(0.5),
                    blurRadius: 8,
                  )
                ],
                color: const Color(0xFF00E5FF),
              ),
            ),

            // BOTTOM 20% - AI Assistant Chat Dock (यहाँ चैट डॉक जोड़ दिया गया है)
            const Expanded(
              flex: 2,
              child: ChatDock(), 
            ),
          ],
        ),
      ),
    );
  }

  // Omni-UI Logic: 80% वाली स्क्रीन में क्या दिखेगा
  Widget _buildActiveWorkspace(WorkspaceMode mode) {
    switch (mode) {
      case WorkspaceMode.document:
        return const Center(
          child: Text("📝 DOCUMENT FORGE ACTIVE", style: TextStyle(fontSize: 20, color: Colors.white70)),
        );
      case WorkspaceMode.creative:
        return const Center(
          child: Text("🎨 MEDIA STUDIO 8K ACTIVE", style: TextStyle(fontSize: 20, color: Colors.white70)),
        );
      case WorkspaceMode.vault:
        return const Center(
          child: Text("🔒 NEXUS VAULT UNLOCKED", style: TextStyle(fontSize: 20, color: Colors.white70)),
        );
      case WorkspaceMode.code:
        return const Center(
          child: Text("⚙️ SELF-EVOLUTION ENGINE", style: TextStyle(fontSize: 20, color: Colors.white70)),
        );
      case WorkspaceMode.chat:
      default:
        return const Center(
          child: Text("🧠 NEURAL CORE STANDBY", style: TextStyle(fontSize: 20, color: Color(0xFF00FF41))),
        );
    }
  }
}
