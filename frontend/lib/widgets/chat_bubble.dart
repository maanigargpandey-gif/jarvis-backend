import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/ai_state_provider.dart';

class ChatBubble extends StatelessWidget {
  final String content;
  final bool isUser;
  final int index;
  final DateTime timestamp;
  
  const ChatBubble({super.key, required this.content, required this.isUser, required this.index, required this.timestamp});
  
  @override
  Widget build(BuildContext context) {
    final aiProvider = Provider.of<AIStateProvider>(context, listen: false);
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Column(
        crossAxisAlignment: isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
            children: [
              if (!isUser) ...[
                const CircleAvatar(radius: 18, backgroundColor: Color(0xFF7C4DFF), child: Icon(Icons.auto_awesome, color: Colors.white, size: 20)),
                const SizedBox(width: 8),
              ],
              Flexible(
                child: Container(
                  constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: isUser ? [const Color(0xFF6C63FF), const Color(0xFF7C4DFF)] : [Colors.grey.shade200, Colors.grey.shade200]),
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(20), topRight: const Radius.circular(20),
                      bottomLeft: Radius.circular(isUser ? 20 : 0), bottomRight: Radius.circular(isUser ? 0 : 20),
                    ),
                  ),
                  child: Text(content, style: GoogleFonts.inter(color: isUser ? Colors.white : Colors.black87, fontSize: 16, height: 1.5)),
                ),
              ),
              if (isUser) ...[
                const SizedBox(width: 8),
                const CircleAvatar(radius: 18, backgroundColor: Color(0xFF00BFA6), child: Icon(Icons.person, color: Colors.white, size: 20)),
              ],
            ],
          ),
          if (!isUser) ...[
            const SizedBox(height: 8),
            ActionRow(
              onShare: () => aiProvider.shareMessage(index),
              onCopy: () => aiProvider.copyMessage(index),
              onFeedback: (isPositive) => aiProvider.provideFeedback(index, isPositive),
              onRetry: () => aiProvider.regenerateResponse(index),
            ),
          ],
        ],
      ),
    );
  }
}

class ActionRow extends StatelessWidget {
  final VoidCallback onShare, onCopy, onRetry;
  final Function(bool) onFeedback;
  const ActionRow({super.key, required this.onShare, required this.onCopy, required this.onFeedback, required this.onRetry});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 44.0),
      child: Row(
        children: [
          _ActionIcon(icon: Icons.share, label: 'Share', onTap: onShare), const SizedBox(width: 16),
          _ActionIcon(icon: Icons.copy, label: 'Copy', onTap: onCopy), const SizedBox(width: 16),
          _ActionIcon(icon: Icons.thumb_up_outlined, label: 'Like', onTap: () => onFeedback(true)), const SizedBox(width: 16),
          _ActionIcon(icon: Icons.thumb_down_outlined, label: 'Dislike', onTap: () => onFeedback(false)), const SizedBox(width: 16),
          _ActionIcon(icon: Icons.refresh, label: 'Retry', onTap: onRetry),
        ],
      ),
    );
  }
}

class _ActionIcon extends StatefulWidget {
  final IconData icon; final String label; final VoidCallback onTap;
  const _ActionIcon({required this.icon, required this.label, required this.onTap});
  @override
  _ActionIconState createState() => _ActionIconState();
}

class _ActionIconState extends State<_ActionIcon> with SingleTickerProviderStateMixin {
  late AnimationController _controller; late Animation<double> _scaleAnimation;
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: const Duration(milliseconds: 200), vsync: this);
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(_controller);
  }
  @override
  void dispose() { _controller.dispose(); super.dispose(); }
  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: InkWell(
        onTap: () { _controller.forward().then((_) => _controller.reverse()); widget.onTap(); },
        borderRadius: BorderRadius.circular(20),
        child: Tooltip(
          message: widget.label,
          child: Container(
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(color: Theme.of(context).colorScheme.surface.withOpacity(0.5), borderRadius: BorderRadius.circular(20)),
            child: Icon(widget.icon, size: 18, color: Theme.of(context).colorScheme.primary),
          ),
        ),
      ),
    );
  }
}

