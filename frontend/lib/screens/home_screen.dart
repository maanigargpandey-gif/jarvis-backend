import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/ai_state_provider.dart';
import '../providers/theme_provider.dart';
import '../widgets/magic_corner.dart';
import '../widgets/sidebar_menu.dart';
import '../widgets/chat_bubble.dart';
import '../widgets/floating_input_bar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ScrollController _scrollController = ScrollController();
  @override
  void dispose() { _scrollController.dispose(); super.dispose(); }
  
  @override
  Widget build(BuildContext context) {
    final aiProvider = Provider.of<AIStateProvider>(context);
    final themeProvider = Provider.of<ThemeProvider>(context);
    
    return Scaffold(
      drawer: const SidebarMenu(),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft, end: Alignment.bottomRight,
            colors: Theme.of(context).brightness == Brightness.dark
                ? [const Color(0xFF0A0E21), const Color(0xFF1A1A2E)] : [const Color(0xFFF5F5F5), const Color(0xFFE8E8E8)],
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              Column(
                children: [
                  Builder(
                    builder: (context) => Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(icon: const Icon(Icons.menu, size: 28), onPressed: () => Scaffold.of(context).openDrawer()),
                          Text('Zarvish', style: TextStyle(fontFamily: 'Rajdhani', fontSize: 24, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.primary)),
                          const MagicCorner(),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: aiProvider.messages.isEmpty
                        ? _buildEmptyState()
                        : ListView.builder(
                            controller: _scrollController, padding: const EdgeInsets.only(bottom: 120),
                            itemCount: aiProvider.messages.length,
                            itemBuilder: (context, index) {
                              final msg = aiProvider.messages[index];
                              return ChatBubble(content: msg.content, isUser: msg.isUser, index: index, timestamp: msg.timestamp);
                            },
                          ),
                  ),
                ],
              ),
              const FloatingInputBar(),
              if (aiProvider.currentState == AIState.processing)
                Positioned(
                  top: 100, left: 0, right: 0,
                  child: Center(
                    child: themeProvider.glassMorphismContainer(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: Theme.of(context).colorScheme.primary)),
                            const SizedBox(width: 12), const Text('Zarvish is thinking...', style: TextStyle(fontFamily: 'Inter')),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(shape: BoxShape.circle, gradient: LinearGradient(colors: [Theme.of(context).colorScheme.primary, Theme.of(context).colorScheme.secondary])),
            child: const Icon(Icons.auto_awesome, size: 64, color: Colors.white),
          ),
          const SizedBox(height: 24),
          Text('Welcome to Zarvish OS', style: TextStyle(fontFamily: 'Rajdhani', fontSize: 28, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.primary)),
          const SizedBox(height: 12),
          const Text('Your Self-Evolving AI Assistant', style: TextStyle(fontFamily: 'Inter', fontSize: 16, color: Colors.grey)),
          const SizedBox(height: 48),
          Wrap(
            spacing: 12, runSpacing: 12, alignment: WrapAlignment.center,
            children: [
              _SuggestionChip(icon: Icons.lightbulb_outline, label: 'Create a business plan', onTap: () => Provider.of<AIStateProvider>(context, listen: false).sendMessage('Create a business plan')),
              _SuggestionChip(icon: Icons.code, label: 'Write a Python script', onTap: () => Provider.of<AIStateProvider>(context, listen: false).sendMessage('Write a Python script')),
              _SuggestionChip(icon: Icons.image, label: 'Generate an image', onTap: () => Provider.of<AIStateProvider>(context, listen: false).sendMessage('Generate an image')),
            ],
          ),
        ],
      ),
    );
  }
}

class _SuggestionChip extends StatelessWidget {
  final IconData icon; final String label; final VoidCallback onTap;
  const _SuggestionChip({required this.icon, required this.label, required this.onTap});
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap, borderRadius: BorderRadius.circular(24),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(border: Border.all(color: Theme.of(context).colorScheme.primary.withOpacity(0.3)), borderRadius: BorderRadius.circular(24)),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 18, color: Theme.of(context).colorScheme.primary),
            const SizedBox(width: 8), Text(label, style: TextStyle(fontFamily: 'Inter', color: Theme.of(context).colorScheme.primary)),
          ],
        ),
      ),
    );
  }
}
