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
      appBar: AppBar(title: const Text("Neural Engine: Active")),
      body: Stack(
        children: [
          Row(
            children: [
              // Sidebar: Context-Aware Tools
              Container(width: 280, color: Colors.black87, child: _buildSidebar(provider.activeTool)),
              
              // Main Canvas + Live Neural Output
              Expanded(
                child: Container(
                  color: Colors.grey[900],
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      const Text("Workspace Area", style: TextStyle(color: Colors.white)),
                      const SizedBox(height: 20),
                      // न्यूरल रिस्पॉन्स यहाँ दिखेगा
                      Container(
                        padding: const EdgeInsets.all(15),
                        color: Colors.blueGrey.withOpacity(0.3),
                        child: Text(provider.aiOutput, style: const TextStyle(color: Colors.greenAccent, fontSize: 16)),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const AiAssistantOverlay(),
        ],
      ),
    );
  }

  Widget _buildSidebar(ActiveTool tool) {
    List<String> items = [];
    if (tool == ActiveTool.word) items = ["Bold", "Italic", "Font", "Highlight"];
    else if (tool == ActiveTool.video) items = ["Trim", "Cut", "Filters"];
    
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
