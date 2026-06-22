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
      appBar: AppBar(title: Text("God Mode: ${provider.activeTool.name.toUpperCase()}")),
      body: Stack(
        children: [
          // Row: Toolkit (Sidebar) + Main Area
          Row(
            children: [
              // Sidebar (Context-Aware)
              Container(
                width: 280,
                color: Colors.black87,
                child: _buildSidebar(provider.activeTool),
              ),
              // Main Workspace
              Expanded(
                child: Container(
                  color: Colors.grey[900],
                  child: Center(child: Text("Workspace: ${provider.activeTool.name}")),
                ),
              ),
            ],
          ),
          // Floating AI (Always on top)
          const AiAssistantOverlay(),
        ],
      ),
    );
  }

  Widget _buildSidebar(ActiveTool tool) {
    // यहाँ टूल के हिसाब से टूल्स बदलते हैं
    List<String> items = [];
    if (tool == ActiveTool.word) items = ["Bold", "Italic", "Font", "Highlight"];
    else if (tool == ActiveTool.video) items = ["Trim", "Cut", "Filters", "Effects"];
    else if (tool == ActiveTool.photo) items = ["AI Remove BG", "Crop", "Enhance"];
    
    return ListView(
      children: [
        ExpansionTile(
          initiallyExpanded: true,
          title: Text(tool.name.toUpperCase(), style: const TextStyle(color: Colors.white)),
          children: items.map((i) => ListTile(title: Text(i, style: const TextStyle(color: Colors.white70)))).toList(),
        ),
      ],
    );
  }
}
