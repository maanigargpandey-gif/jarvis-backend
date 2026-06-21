import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/jarvis_state_provider.dart';
import '../widgets/artifact_editor_overlay.dart'; // इसे हम इसके बाद बनाएंगे

class JarvisMainScreen extends StatefulWidget {
  const JarvisMainScreen({Key? key}) : super(key: key);

  @override
  _JarvisMainScreenState createState() => _JarvisMainScreenState();
}

class _JarvisMainScreenState extends State<JarvisMainScreen> with SingleTickerProviderStateMixin {
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  late AnimationController _bgController;

  @override
  void initState() {
    super.initState();
    _bgController = AnimationController(vsync: this, duration: const Duration(seconds: 4))..repeat(reverse: true);
  }

  @override
  void dispose() {
    _bgController.dispose();
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _sendMessage(BuildContext context) {
    if (_textController.text.trim().isEmpty) return;
    
    // प्रोवाइडर को कमांड भेजना
    context.read<JarvisStateProvider>().processUserCommand(_textController.text.trim());
    _textController.clear();
    
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(_scrollController.position.maxScrollExtent, duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Provider से सारा स्टेट लेना (Theme, Messages, Role)
    final state = context.watch<JarvisStateProvider>();

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text('JARVIS CORE', style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 2, color: state.accentColor, fontFamily: 'Courier')),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: state.accentColor),
        actions: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(child: Text(state.currentRole, style: TextStyle(color: state.accentColor, fontWeight: FontWeight.bold))),
          )
        ],
      ),
      body: Stack(
        children: [
          // 🌌 डायनामिक 'गिरगिट' बैकग्राउंड एनिमेशन
          AnimatedBuilder(
            animation: _bgController,
            builder: (context, child) {
              return Container(
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    center: const Alignment(0, -0.2),
                    radius: 1.4 + (_bgController.value * 0.15),
                    colors: [
                      state.bgBlendColor.withOpacity(0.5 + (_bgController.value * 0.2)),
                      const Color(0xFF0A0A0A),
                    ],
                    stops: const [0.0, 1.0],
                  ),
                ),
              );
            },
          ),
          
          SafeArea(
            child: Column(
              children: [
                // 💬 चैट लिस्ट
                Expanded(
                  child: ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(16),
                    itemCount: state.messages.length,
                    itemBuilder: (context, i) {
                      final msg = state.messages[i];
                      bool isUser = msg['sender'] == 'user';
                      bool isSystem = msg['sender'] == 'system';
                      
                      if (isSystem) {
                        return Center(child: Padding(padding: const EdgeInsets.symmetric(vertical: 8.0), child: Text(msg['text'], style: const TextStyle(color: Colors.white54, fontSize: 12, fontStyle: FontStyle.italic))));
                      }

                      return Container(
                        margin: const EdgeInsets.only(bottom: 20),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
                          children: [
                            if (!isUser) CircleAvatar(backgroundColor: Colors.white12, child: Icon(Icons.blur_on, color: state.accentColor, size: 20)),
                            if (!isUser) const SizedBox(width: 10),
                            Flexible(
                              child: Column(
                                crossAxisAlignment: isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                                children: [
                                  // Text Message
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                                    decoration: BoxDecoration(
                                      color: isUser ? state.accentColor.withOpacity(0.15) : Colors.black65,
                                      border: Border.all(color: isUser ? state.accentColor.withOpacity(0.4) : Colors.white10),
                                      borderRadius: BorderRadius.circular(16).copyWith(
                                        bottomRight: isUser ? const Radius.circular(0) : const Radius.circular(16),
                                        topLeft: !isUser ? const Radius.circular(0) : const Radius.circular(16),
                                      ),
                                    ),
                                    child: Text(msg['text']!, style: const TextStyle(fontSize: 15, color: Colors.white, height: 1.4)),
                                  ),
                                  
                                  // 📂 Claude-Style Artifact Card (अगर फ़ाइल है)
                                  if (msg['type'] != 'text' && !isUser) ...[
                                    const SizedBox(height: 8),
                                    _buildArtifactCard(context, state, msg),
                                  ]
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                
                // ⏳ Self-Evolution Loading Indicator
                if (state.isEvolving)
                  Container(
                    padding: const EdgeInsets.all(8),
                    color: state.accentColor.withOpacity(0.1),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: state.accentColor)),
                        const SizedBox(width: 10),
                        Text("JARVIS is evolving the system core...", style: TextStyle(color: state.accentColor, fontFamily: 'Courier', fontSize: 12)),
                      ],
                    ),
                  ),
                  
                if (state.isProcessing && !state.isEvolving)
                   const Padding(padding: EdgeInsets.all(8.0), child: CircularProgressIndicator(color: Colors.white54)),

                // ⌨️ Input Area
                _buildInputArea(context, state),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 🗂️ Artifact Card Builder
  Widget _buildArtifactCard(BuildContext context, JarvisStateProvider state, Map<String, dynamic> msg) {
    return Container(
      width: 320,
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF141414),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: state.accentColor.withOpacity(0.5), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.insert_drive_file, color: state.accentColor, size: 28),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(msg['fileName'] ?? "Generated Artifact", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis),
                    Text(msg['fileSize'] ?? "Unknown Size", style: TextStyle(color: Colors.grey.shade400, fontSize: 11)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Action Buttons (Nexus Vault & Editor)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenedy,
            children: [
              TextButton.icon(
                onPressed: () {
                  // ओवरले एडिटर ओपन करें
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    builder: (_) => ArtifactEditorOverlay(fileName: msg['fileName'], fileType: msg['type'], themeColor: state.accentColor, fileUrl: msg['fileUrl']),
                  );
                },
                icon: Icon(Icons.edit, color: state.accentColor, size: 16),
                label: Text("Open Tools", style: TextStyle(color: state.accentColor, fontSize: 12)),
              ),
              TextButton.icon(
                onPressed: () => context.read<JarvisStateProvider>().saveArtifactToNexus(msg['fileUrl'] ?? msg['fileName']),
                icon: const Icon(Icons.cloud_upload, color: Colors.white70, size: 16),
                label: const Text("Save to Nexus", style: TextStyle(color: Colors.white70, fontSize: 12)),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildInputArea(BuildContext context, JarvisStateProvider state) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: const BoxDecoration(color: Color(0xFF0D0D0D), border: Border(top: BorderSide(color: Colors.white10, width: 0.5))),
      child: Row(
        children: [
          IconButton(icon: Icon(Icons.add_circle_outline, color: state.accentColor), onPressed: () {}),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(color: Colors.white.withOpacity(0.05), borderRadius: BorderRadius.circular(24)),
              child: TextField(
                controller: _textController,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(hintText: 'Command Jarvis...', hintStyle: TextStyle(color: Colors.white38), border: InputBorder.none),
                onSubmitted: (_) => _sendMessage(context),
              ),
            ),
          ),
          IconButton(icon: Icon(Icons.mic, color: state.accentColor), onPressed: () {}),
          CircleAvatar(backgroundColor: state.accentColor, radius: 20, child: IconButton(icon: const Icon(Icons.send, color: Colors.black, size: 18), onPressed: () => _sendMessage(context))),
        ],
      ),
    );
  }
}
