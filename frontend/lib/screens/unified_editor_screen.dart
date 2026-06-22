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
      appBar: AppBar(title: const Text("God Mode: Neural Integrated")),
      body: Stack(
        children: [
          Row(
            children: [
              // Sidebar: Smart Toolkit (Step 14 integrated)
              Container(width: 280, color: Colors.black87, child: _buildSidebar(provider)),
              
              // Main Canvas + Neural Live Output (Step 13 integrated)
              Expanded(
                child: Container(
                  color: Colors.grey[900],
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      // Neural Output Window
                      Container(
                        height: 150,
                        padding: const EdgeInsets.all(15),
                        color: Colors.blueGrey.withOpacity(0.2),
                        child: Text(provider.aiOutput, style: const TextStyle(color: Colors.greenAccent)),
                      ),
                      const Expanded(child: Center(child: Text("Main Canvas: Active Tool View"))),
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

  Widget _buildSidebar(JarvisStateProvider provider) {
    return ListView(
      children: [
        _buildExpansion("Office Tools", [ActiveTool.word, ActiveTool.excel, ActiveTool.pdf], provider),
        _buildExpansion("Media & Neural", [ActiveTool.video, ActiveTool.photo], provider),
        _buildExpansion("Live Systems", [ActiveTool.music, ActiveTool.geo, ActiveTool.browser], provider),
      ],
    );
  }

  Widget _buildExpansion(String title, List<ActiveTool> tools, JarvisStateProvider provider) {
    return ExpansionTile(
      initiallyExpanded: true,
      title: Text(title, style: const TextStyle(color: Colors.white)),
      children: tools.map((tool) => ListTile(
        title: Text(tool.name.toUpperCase(), style: const TextStyle(color: Colors.white70)),
        onTap: () => provider.setActiveTool(tool),
      )).toList(),
    );
  }
}
