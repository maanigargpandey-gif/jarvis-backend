import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/ai_state_provider.dart';

class MagicCorner extends StatelessWidget {
  const MagicCorner({super.key});
  @override
  Widget build(BuildContext context) {
    final aiProvider = Provider.of<AIStateProvider>(context);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _MagicIcon(icon: Icons.camera_alt, label: 'Live Vision', onTap: () {}), const SizedBox(width: 8),
        _MagicIcon(icon: Icons.screen_share, label: 'Screen Share', onTap: () {}), const SizedBox(width: 8),
        _CreatorModeToggle(isActive: aiProvider.creatorMode == CreatorMode.godMode, onToggle: () => aiProvider.toggleCreatorMode()),
      ],
    );
  }
}

class _MagicIcon extends StatefulWidget {
  final IconData icon; final String label; final VoidCallback onTap;
  const _MagicIcon({required this.icon, required this.label, required this.onTap});
  @override
  _MagicIconState createState() => _MagicIconState();
}

class _MagicIconState extends State<_MagicIcon> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  @override
  void initState() { super.initState(); _controller = AnimationController(duration: const Duration(milliseconds: 300), vsync: this); }
  @override
  void dispose() { _controller.dispose(); super.dispose(); }
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () { _controller.forward().then((_) => _controller.reverse()); widget.onTap(); },
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: Theme.of(context).colorScheme.primary.withOpacity(0.5), width: 1.5)),
        child: Icon(widget.icon, color: Theme.of(context).colorScheme.primary, size: 20),
      ),
    );
  }
}

class _CreatorModeToggle extends StatefulWidget {
  final bool isActive; final VoidCallback onToggle;
  const _CreatorModeToggle({required this.isActive, required this.onToggle});
  @override
  _CreatorModeToggleState createState() => _CreatorModeToggleState();
}

class _CreatorModeToggleState extends State<_CreatorModeToggle> with SingleTickerProviderStateMixin {
  late AnimationController _controller; late Animation<double> _glowAnimation;
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: const Duration(seconds: 2), vsync: this);
    _glowAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
    if (widget.isActive) _controller.repeat(reverse: true);
  }
  @override
  void didUpdateWidget(_CreatorModeToggle oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isActive && !oldWidget.isActive) _controller.repeat(reverse: true);
    else if (!widget.isActive && oldWidget.isActive) _controller.stop();
  }
  @override
  void dispose() { _controller.dispose(); super.dispose(); }
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onToggle,
      child: AnimatedBuilder(
        animation: _glowAnimation,
        builder: (context, child) {
          return Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: widget.isActive ? RadialGradient(colors: [Colors.amber.withOpacity(0.3 * _glowAnimation.value), Colors.amber.withOpacity(0.1 * _glowAnimation.value)]) : null,
              border: Border.all(color: widget.isActive ? Colors.amber : Colors.grey, width: 1.5),
              boxShadow: widget.isActive ? [BoxShadow(color: Colors.amber.withOpacity(0.3 * _glowAnimation.value), blurRadius: 12, spreadRadius: 2)] : null,
            ),
            child: Icon(Icons.auto_awesome, color: widget.isActive ? Colors.amber : Colors.grey, size: 20),
          );
        },
      ),
    );
  }
}
