import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/workspace_provider.dart';

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

            // BOTTOM 20% - AI Assistant Chat Dock
            Expanded(
              flex: 2,
              child: Container(
                color: const Color(0xFF1E1E24), // Frosted Glass / Ash grey panel
                padding: const EdgeInsets.all(8.0),
                child: const Center(
                  child: Text(
                    "AI Assistant Chat Interface\n(Mic & '+' Attachment Menu will be here)",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white54),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Omni-UI Logic: 80% वाली स्क्रीन में क्या दिखेगा, ये यहाँ से तय होगा
  Widget _buildActiveWorkspace(WorkspaceMode mode) {
    switch (mode) {
      case WorkspaceMode.document:
        return const Center(child: Text("📝 DOCUMENT FORGE MODE ACTIVE", style: TextStyle(fontSize: 20)));
      case WorkspaceMode.creative:
        return const Center(child: Text("🎨 MEDIA STUDIO 8K ACTIVE", style: TextStyle(fontSize: 20)));
      case WorkspaceMode.vault:
        return const Center(child: Text("🔒 NEXUS VAULT UNLOCKED", style: TextStyle(fontSize: 20)));
      case WorkspaceMode.chat:
      default:
        return const Center(child: Text("🧠 NEURAL CORE STANDBY", style: TextStyle(fontSize: 20)));
    }
  }
}
