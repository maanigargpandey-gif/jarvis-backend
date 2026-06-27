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
        // 80% - Document/Content Editor
        Expanded(
          flex: 8,
          child: WorkspaceScreen(
            mode: workspaceProvider.currentMode.toString(),
          ),
        ),
        
        // Divider
        Container(
          width: 2,
          color: Colors.white10,
        ),
        
        // 20% - AI Chat Input
        Expanded(
          flex: 2,
          child: const ChatScreen(),
        ),
      ],
    );
  }
}
