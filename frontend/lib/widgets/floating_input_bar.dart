import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/ai_state_provider.dart';
import '../providers/voice_provider.dart';
import 'glass_morphic_container.dart';
import 'glowing_waveform.dart';

class FloatingInputBar extends StatefulWidget {
  const FloatingInputBar({super.key});
  @override
  _FloatingInputBarState createState() => _FloatingInputBarState();
}

class _FloatingInputBarState extends State<FloatingInputBar> with SingleTickerProviderStateMixin {
  late AnimationController _expandController;
  late Animation<double> _expandAnimation;
  final TextEditingController _textController = TextEditingController();
  
  @override
  void initState() {
    super.initState();
    _expandController = AnimationController(duration: const Duration(milliseconds: 300), vsync: this);
    _expandAnimation = CurvedAnimation(parent: _expandController, curve: Curves.easeInOut);
  }
  
  @override
  void dispose() { _expandController.dispose(); _textController.dispose(); super.dispose(); }
  
  void _toggleExpand() {
    final aiProvider = Provider.of<AIStateProvider>(context, listen: false);
    if (aiProvider.isInputExpanded) _expandController.reverse(); else _expandController.forward();
    aiProvider.toggleInput();
  }
  
  void _sendMessage() {
    if (_textController.text.trim().isNotEmpty) {
      Provider.of<AIStateProvider>(context, listen: false).sendMessage(_textController.text);
      _textController.clear();
      _toggleExpand();
    }
  }
  
  @override
  Widget build(BuildContext context) {
    final aiProvider = Provider.of<AIStateProvider>(context);
    final voiceProvider = Provider.of<VoiceProvider>(context);
    
    return Positioned(
      bottom: 32, left: 16, right: 16,
      child: GestureDetector(
        onTap: () { if (!aiProvider.isInputExpanded) _toggleExpand(); },
        child: AnimatedBuilder(
          animation: _expandAnimation,
          builder: (context, child) {
            return Container(
              constraints: BoxConstraints(maxHeight: aiProvider.isInputExpanded ? 200 : 60),
              child: GlassMorphicContainer(
                borderRadius: 30, blur: 20, opacity: 0.2,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                child: aiProvider.isInputExpanded ? _buildExpandedInput(aiProvider, voiceProvider) : _buildCollapsedBubble(aiProvider),
              ),
            );
          },
        ),
      ),
    );
  }
  
  Widget _buildCollapsedBubble(AIStateProvider aiProvider) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.auto_awesome, color: Theme.of(context).colorScheme.primary, size: 24),
        const SizedBox(width: 12),
        const Text('Ask Zarvish anything...', style: TextStyle(color: Colors.white70, fontSize: 16, fontFamily: 'Inter')),
      ],
    );
  }
  
  Widget _buildExpandedInput(AIStateProvider aiProvider, VoiceProvider voiceProvider) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (voiceProvider.isListening) GlowingWaveform(isActive: voiceProvider.isListening, height: 30, color: Theme.of(context).colorScheme.secondary),
        if (voiceProvider.isListening) const SizedBox(height: 12),
        TextField(
          controller: _textController, autofocus: true, maxLines: null,
          style: const TextStyle(color: Colors.white, fontFamily: 'Inter'),
          decoration: InputDecoration(
            hintText: 'Type your query or speak...', hintStyle: const TextStyle(color: Colors.white54), border: InputBorder.none,
            prefixIcon: IconButton(icon: const Icon(Icons.attach_file, color: Colors.white70), onPressed: () {}),
            suffixIcon: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(voiceProvider.isListening ? Icons.mic : Icons.mic_none, color: voiceProvider.isListening ? Theme.of(context).colorScheme.secondary : Colors.white70),
                  onPressed: () => voiceProvider.toggleListening(),
                ),
                IconButton(icon: const Icon(Icons.send, color: Colors.white70), onPressed: _sendMessage),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

