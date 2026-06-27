import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/chat_provider.dart';
import '../providers/theme_provider.dart';

class FloatingInputPill extends StatefulWidget {
  const FloatingInputPill({super.key});

  @override
  State<FloatingInputPill> createState() => _FloatingInputPillState();
}

class _FloatingInputPillState extends State<FloatingInputPill> {
  final _textController = TextEditingController();

  void _sendMessage() {
    if (_textController.text.trim().isEmpty) return;
    
    final chatProvider = Provider.of<ChatProvider>(context, listen: false);
    chatProvider.sendMessage(_textController.text.trim());
    _textController.clear();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final chatProvider = Provider.of<ChatProvider>(context);
    
    return themeProvider.glassMorphismContainer(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _textController,
                style: TextStyle(
                  color: themeProvider.themeMode == ThemeMode.dark
                      ? Colors.white
                      : Colors.black87,
                ),
                decoration: InputDecoration(
                  hintText: 'Ask Zarvish anything...',
                  hintStyle: TextStyle(
                    color: themeProvider.themeMode == ThemeMode.dark
                        ? Colors.white38
                        : Colors.black38,
                  ),
                  border: InputBorder.none,
                ),
                onSubmitted: (_) => _sendMessage(),
              ),
            ),
            if (chatProvider.isProcessing)
              const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            else
              IconButton(
                icon: const Icon(Icons.send_rounded, color: Color(0xFF7C4DFF)),
                onPressed: _sendMessage,
              ),
          ],
        ),
      ),
    );
  }
}

