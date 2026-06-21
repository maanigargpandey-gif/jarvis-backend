import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/jarvis_state_provider.dart';

class ArtifactEditorOverlay extends StatelessWidget {
  final String fileName;
  final String fileType;
  final String fileUrl;
  final Color themeColor;

  const ArtifactEditorOverlay({
    Key? key,
    required this.fileName,
    required this.fileType,
    required this.fileUrl,
    required this.themeColor,
  }) : super(key: key);

  // डायनामिक टूल्स (तुम्हारे वीडियो वाले बैकएंड के हिसाब से)
  List<String> _getTools() {
    switch (fileType.toLowerCase()) {
      case 'video': return ['Timeline', 'Cut', 'Effects', 'Remove BG (AI)', 'Face Lock (AI)'];
      case 'excel': return ['Home', 'Formulas', 'Data', 'Clean Data (AI)', 'Analyze (AI)'];
      case 'doc': return ['Format', 'Layout', 'Review', 'Rewrite (AI)', 'Summary (AI)'];
      case 'photo': return ['Crop', 'Filters', 'Upscale 8K (AI)', '3D Clothes Try-on (AI)'];
      case 'music': return ['Beats', 'Vocals', 'Mixer', 'Isolate Voice (AI)'];
      default: return ['View', 'Details', 'Share'];
    }
  }

  void _triggerAITool(BuildContext context, String toolName) {
    // अगर यूज़र AI टूल (जो बैकएंड में डमी हो सकता है) दबाता है, तो हम सीधा प्रोवाइडर को कमांड भेजते हैं
    Navigator.pop(context); // पहले ओवरले बंद करो
    
    final command = "Execute [$toolName] protocol on file: $fileName";
    
    // यह कमांड सीधे तुम्हारे ai_brain.py में जाएगी। अगर फीचर नहीं है, तो self_evolution.py ट्रिगर होगा!
    context.read<JarvisStateProvider>().processUserCommand(command);
  }

  @override
  Widget build(BuildContext context) {
    final tools = _getTools();

    return Container(
      height: MediaQuery.of(context).size.height * 0.85, // 85% स्क्रीन (तुम्हारे लाल पेन वाले मार्क के हिसाब से)
      decoration: const BoxDecoration(
        color: Color(0xFF0A0A0A),
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
            decoration: BoxDecoration(
              color: const Color(0xFF141414),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
              border: Border(bottom: BorderSide(color: themeColor.withOpacity(0.3))),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(child: Text(fileName, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis)),
                IconButton(icon: const Icon(Icons.keyboard_arrow_down, color: Colors.white54), onPressed: () => Navigator.pop(context)),
              ],
            ),
          ),

          // Toolbar (CapCut / MS Office Style)
          Container(
            height: 55,
            decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: Colors.white10))),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              itemCount: tools.length,
              itemBuilder: (context, index) {
                bool isAITool = tools[index].contains('(AI)');
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                  child: InkWell(
                    onTap: () => _triggerAITool(context, tools[index]),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: isAITool ? themeColor.withOpacity(0.2) : Colors.transparent,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: isAITool ? themeColor : Colors.white24),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        tools[index],
                        style: TextStyle(color: isAITool ? themeColor : Colors.white70, fontSize: 13, fontWeight: isAITool ? FontWeight.bold : FontWeight.normal),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // Main View Engine
          Expanded(
            child: Container(
              width: double.infinity,
              color: Colors.black,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.memory, size: 60, color: themeColor.withOpacity(0.2)),
                    const SizedBox(height: 20),
                    Text("Rendering ${fileType.toUpperCase()} Engine...", style: TextStyle(color: themeColor.withOpacity(0.5), fontFamily: 'Courier', letterSpacing: 1.5)),
                    const SizedBox(height: 10),
                    const Text("Select a tool from the top bar to apply changes.", style: TextStyle(color: Colors.white38, fontSize: 12)),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
