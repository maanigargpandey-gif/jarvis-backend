import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/workspace_provider.dart';
import '../screens/chat_screen.dart';
import '../screens/workspace_screen.dart';

class WorkspaceSplitView extends StatelessWidget {
  const WorkspaceSplitView({super.key});

  @override
  Widget build(BuildContext context) {
    final workspaceProvider = Provider.of<WorkspaceProvider>(context);
    
    return Row(
      children: [
        // 🚀 TOP/LEFT 80% - Document, Content Editor, Vault, or Creative Workspace
        Expanded(
          flex: 8,
          child: WorkspaceScreen(
            mode: workspaceProvider.currentMode.toString(),
          ),
        ),
        
        // ⚡ DeepSeek Custom Divider Layer (Frosted/Subtle Split Boundary)
        Container(
          width: 2,
          color: const Color(0.12 * 0xFFFFFFFF), // Matches DeepSeek structure
        ),
        
        // 🧠 BOTTOM/RIGHT 20% - AI Chat Interface Permanently Docked
        const Expanded(
          flex: 2,
          child: ChatScreen(),
        ),
      ],
    );
  }
}
