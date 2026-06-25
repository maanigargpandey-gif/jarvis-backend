import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/ai_state_provider.dart';
import '../providers/voice_provider.dart';
import '../widgets/glowing_waveform.dart';

class OmniWorkspaceScreen extends StatefulWidget {
  const OmniWorkspaceScreen({super.key});
  @override
  _OmniWorkspaceScreenState createState() => _OmniWorkspaceScreenState();
}

class _OmniWorkspaceScreenState extends State<OmniWorkspaceScreen> {
  final TextEditingController _commandController = TextEditingController();
  @override
  void dispose() { _commandController.dispose(); super.dispose(); }
  
  @override
  Widget build(BuildContext context) {
    final aiProvider = Provider.of<AIStateProvider>(context);
    final voiceProvider = Provider.of<VoiceProvider>(context);
    
    return Scaffold(
      appBar: AppBar(
        title: Text('Omni Workspace - ${aiProvider.workspaceMode.toString().split('.').last}', style: const TextStyle(fontFamily: 'Rajdhani', fontWeight: FontWeight.bold)),
        leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => Navigator.pop(context)),
        actions: [
          IconButton(icon: const Icon(Icons.fullscreen), onPressed: () {}),
          IconButton(icon: const Icon(Icons.more_vert), onPressed: () {}),
        ],
      ),
      body: Column(
        children: [
          Expanded(flex: 8, child: _buildWorkspaceContent(aiProvider)),
          Expanded(
            flex: 2,
            child: Container(
              decoration: BoxDecoration(color: Theme.of(context).colorScheme.surface, border: Border(top: BorderSide(color: Theme.of(context).colorScheme.primary.withOpacity(0.3), width: 1))),
              child: Column(
                children: [
                  if (voiceProvider.isListening) Padding(padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0), child: GlowingWaveform(isActive: voiceProvider.isListening, height: 30, color: Theme.of(context).colorScheme.secondary)),
                  Expanded(
                    child: Row(
                      children: [
                        const SizedBox(width: 16),
                        GestureDetector(
                          onTap: () => voiceProvider.toggleListening(),
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(shape: BoxShape.circle, gradient: LinearGradient(colors: [Theme.of(context).colorScheme.primary, Theme.of(context).colorScheme.secondary])),
                            child: Icon(voiceProvider.isListening ? Icons.mic : Icons.mic_none, color: Colors.white),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: TextField(
                            controller: _commandController, style: const TextStyle(fontFamily: 'Inter'),
                            decoration: InputDecoration(
                              hintText: 'Give voice commands while viewing...', hintStyle: const TextStyle(color: Colors.grey), border: InputBorder.none,
                              suffixIcon: IconButton(icon: const Icon(Icons.send), onPressed: () { if (_commandController.text.isNotEmpty) { aiProvider.sendMessage(_commandController.text); _commandController.clear(); } }),
                            ),
                          ),
                        ),
                        PopupMenuButton<String>(
                          icon: const Icon(Icons.more_horiz),
                          itemBuilder: (context) => [
                            const PopupMenuItem(value: 'summarize', child: Row(children: [Icon(Icons.summarize, size: 18), SizedBox(width: 8), Text('Summarize')])),
                            const PopupMenuItem(value: 'translate', child: Row(children: [Icon(Icons.translate, size: 18), SizedBox(width: 8), Text('Translate')])),
                            const PopupMenuItem(value: 'analyze', child: Row(children: [Icon(Icons.analytics, size: 18), SizedBox(width: 8), Text('Analyze')])),
                          ],
                        ),
                        const SizedBox(width: 8),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildWorkspaceContent(AIStateProvider aiProvider) {
    switch (aiProvider.workspaceMode) {
      case WorkspaceMode.browser: return _buildBrowserView();
      case WorkspaceMode.document: return _buildDocumentView();
      case WorkspaceMode.media: return _buildMediaStudio();
      case WorkspaceMode.code: return _buildCodeEditor();
      default: return _buildBrowserView();
    }
  }
  
  Widget _buildBrowserView() {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(8.0), color: Colors.grey.shade100,
            child: Row(
              children: [
                IconButton(icon: const Icon(Icons.arrow_back, size: 20), onPressed: () {}),
                IconButton(icon: const Icon(Icons.arrow_forward, size: 20), onPressed: () {}),
                IconButton(icon: const Icon(Icons.refresh, size: 20), onPressed: () {}),
                Expanded(child: Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)), child: const Text('https://zarvish.ai/workspace', style: TextStyle(fontSize: 14, color: Colors.grey)))),
              ],
            ),
          ),
          Expanded(child: Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(Icons.language, size: 80, color: Theme.of(context).colorScheme.primary.withOpacity(0.3)), const SizedBox(height: 16), const Text('Browser View Active', style: TextStyle(fontFamily: 'Rajdhani', fontSize: 24, fontWeight: FontWeight.bold)), const SizedBox(height: 8), const Text('Use voice commands to navigate', style: TextStyle(color: Colors.grey))]))),
        ],
      ),
    );
  }
  
  Widget _buildDocumentView() => Container(color: Colors.white, child: Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(Icons.description_outlined, size: 80, color: Theme.of(context).colorScheme.primary.withOpacity(0.3)), const SizedBox(height: 16), const Text('Document View', style: TextStyle(fontFamily: 'Rajdhani', fontSize: 24)), const SizedBox(height: 8), const Text('AI-powered document analysis', style: TextStyle(color: Colors.grey))])));
  
  Widget _buildMediaStudio() => Container(color: const Color(0xFF1A1A2E), child: Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(Icons.movie_creation_outlined, size: 80, color: Colors.white.withOpacity(0.3)), const SizedBox(height: 16), const Text('Media Studio', style: TextStyle(fontFamily: 'Rajdhani', fontSize: 24, color: Colors.white)), const SizedBox(height: 8), const Text('AI-powered media creation', style: TextStyle(color: Colors.white70))])));
  
  Widget _buildCodeEditor() {
    return Container(
      color: const Color(0xFF1E1E1E),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(8.0), color: const Color(0xFF2D2D2D),
            child: Row(children: [const Text('main.dart', style: TextStyle(color: Colors.white, fontFamily: 'Inter')), const Spacer(), IconButton(icon: const Icon(Icons.play_arrow, color: Colors.green, size: 20), onPressed: () {}), IconButton(icon: const Icon(Icons.save, color: Colors.white70, size: 20), onPressed: () {})]),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _codeLine('void main() {', 0), _codeLine('  print("Zarvish OS Running");', 1), _codeLine('  runApp(const ZarvishOS());', 1), _codeLine('}', 0),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _codeLine(String text, int indent) => Padding(padding: EdgeInsets.only(left: indent * 20.0, top: 4.0), child: Text(text, style: const TextStyle(fontFamily: 'monospace', fontSize: 14, color: Color(0xFFD4D4D4))));
}
