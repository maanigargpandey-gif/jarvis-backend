import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/ai_state_provider.dart';
import '../providers/theme_provider.dart';

class SidebarMenu extends StatelessWidget {
  const SidebarMenu({super.key});
  @override
  Widget build(BuildContext context) {
    final aiProvider = Provider.of<AIStateProvider>(context);
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Drawer(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft, end: Alignment.bottomRight,
            colors: [Theme.of(context).colorScheme.primary.withOpacity(0.1), Theme.of(context).colorScheme.secondary.withOpacity(0.1)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              DrawerHeader(
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: Theme.of(context).colorScheme.primary, width: 2)),
                      child: const Icon(Icons.auto_awesome, size: 40, color: Color(0xFF7C4DFF)),
                    ),
                    const SizedBox(height: 12),
                    Text('Zarvish OS', style: TextStyle(fontFamily: 'Rajdhani', fontSize: 24, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.primary)),
                    const Text('Self-Evolving AI', style: TextStyle(fontFamily: 'Inter', fontSize: 12, color: Colors.grey)),
                  ],
                ),
              ),
              _MenuTile(icon: Icons.chat_bubble_outline, title: 'Chat', isSelected: aiProvider.workspaceMode == WorkspaceMode.chat, onTap: () { aiProvider.setWorkspaceMode(WorkspaceMode.chat); Navigator.pop(context); }),
              _MenuTile(icon: Icons.language, title: 'Browser', isSelected: aiProvider.workspaceMode == WorkspaceMode.browser, onTap: () { aiProvider.setWorkspaceMode(WorkspaceMode.browser); Navigator.pop(context); Navigator.pushNamed(context, '/omni-workspace'); }),
              _MenuTile(icon: Icons.description_outlined, title: 'Documents', isSelected: aiProvider.workspaceMode == WorkspaceMode.document, onTap: () { aiProvider.setWorkspaceMode(WorkspaceMode.document); Navigator.pop(context); }),
              _MenuTile(icon: Icons.movie_outlined, title: 'Media Studio', isSelected: aiProvider.workspaceMode == WorkspaceMode.media, onTap: () { aiProvider.setWorkspaceMode(WorkspaceMode.media); Navigator.pop(context); }),
              _MenuTile(icon: Icons.code, title: 'Code Editor', isSelected: aiProvider.workspaceMode == WorkspaceMode.code, onTap: () { aiProvider.setWorkspaceMode(WorkspaceMode.code); Navigator.pop(context); }),
              const Divider(),
              _MenuTile(icon: Icons.brightness_6, title: 'Toggle Theme', onTap: () => themeProvider.toggleTheme()),
              _MenuTile(icon: themeProvider.isGlassMorphismEnabled ? Icons.blur_on : Icons.blur_off, title: 'Glass Effect', onTap: () => themeProvider.setGlassMorphism(!themeProvider.isGlassMorphismEnabled)),
              const Spacer(),
              const Padding(padding: EdgeInsets.all(16.0), child: Text('v1.0.0 | Self-Evolving Core', style: TextStyle(fontSize: 10, color: Colors.grey, fontFamily: 'Inter'))),
            ],
          ),
        ),
      ),
    );
  }
}

class _MenuTile extends StatelessWidget {
  final IconData icon; final String title; final VoidCallback onTap; final bool isSelected;
  const _MenuTile({required this.icon, required this.title, required this.onTap, this.isSelected = false});
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: isSelected ? Theme.of(context).colorScheme.primary : Colors.grey),
      title: Text(title, style: TextStyle(fontFamily: 'Inter', fontWeight: isSelected ? FontWeight.bold : FontWeight.normal, color: isSelected ? Theme.of(context).colorScheme.primary : null)),
      onTap: onTap, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      selected: isSelected, selectedTileColor: Theme.of(context).colorScheme.primary.withOpacity(0.1),
    );
  }
}
