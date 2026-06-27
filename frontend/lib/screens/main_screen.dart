import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/theme_provider.dart';
import '../providers/workspace_provider.dart';
import '../config/routes.dart';
import '../widgets/animated_logo_background.dart';
import '../widgets/floating_input_pill.dart';
import '../widgets/workspace_split_view.dart';
import 'chat_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final workspaceProvider = Provider.of<WorkspaceProvider>(context);
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.themeMode == ThemeMode.dark;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0A0E21) : const Color(0xFFF5F5F7),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Builder(
          builder: (context) => IconButton(
            icon: Icon(Icons.menu, color: isDark ? Colors.white : const Color(0xFF2D3142)),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        title: Text(
          'ZARVISH',
          style: TextStyle(
            color: isDark ? Colors.white : const Color(0xFF2D3142),
            fontWeight: FontWeight.w600,
            letterSpacing: 2,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              themeProvider.themeMode == ThemeMode.dark
                  ? Icons.light_mode
                  : Icons.dark_mode,
              color: isDark ? Colors.white : const Color(0xFF2D3142),
            ),
            onPressed: themeProvider.toggleTheme,
          ),
          if (authProvider.isCreator)
            IconButton(
              icon: const Icon(Icons.dashboard, color: Colors.amberAccent),
              onPressed: () => Navigator.pushNamed(context, AppRoutes.admin),
            ),
        ],
      ),
      drawer: _buildDrawer(isDark),
      body: Stack(
        children: [
          // Animated Zarvish Logo Background
          const AnimatedLogoBackground(),
          
          // Main content
          if (workspaceProvider.isSplitView)
            const WorkspaceSplitView()
          else
            const ChatScreen(),
          
          // Floating Input Pill
          const Positioned(
            bottom: 20,
            left: 20,
            right: 20,
            child: FloatingInputPill(),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawer(bool isDark) {
    final authProvider = Provider.of<AuthProvider>(context);
    final workspaceProvider = Provider.of<WorkspaceProvider>(context);

    return Drawer(
      backgroundColor: isDark ? const Color(0xFF0A0A0A) : Colors.white,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: isDark
                    ? [const Color(0xFF7C4DFF), const Color(0xFF00E5FF)]
                    : [const Color(0xFF6C63FF), const Color(0xFF00BFA6)],
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const Icon(Icons.blur_on, size: 40, color: Colors.white),
                const SizedBox(height: 10),
                const Text(
                  'ZARVISH OS',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  authProvider.isCreator ? 'Creator Mode' : 'Guest Mode',
                  style: const TextStyle(color: Colors.white70, fontSize: 14),
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.chat),
            title: const Text('Chat'),
            selected: workspaceProvider.currentMode == WorkspaceMode.chat,
            onTap: () {
              workspaceProvider.setMode(WorkspaceMode.chat);
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.description),
            title: const Text('Document Editor'),
            onTap: () {
              workspaceProvider.setMode(WorkspaceMode.document);
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.code),
            title: const Text('Code Editor'),
            onTap: () {
              workspaceProvider.setMode(WorkspaceMode.code);
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.brush),
            title: const Text('Creative Studio'),
            onTap: () {
              workspaceProvider.setMode(WorkspaceMode.creative);
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.share),
            title: const Text('Social Manager'),
            onTap: () {
              Navigator.pushNamed(context, AppRoutes.social);
              Navigator.pop(context);
            },
          ),
          if (authProvider.isCreator) ...[
            const Divider(),
            ListTile(
              leading: const Icon(Icons.security, color: Colors.amberAccent),
              title: const Text('Credential Vault'),
              onTap: () {
                Navigator.pushNamed(context, AppRoutes.vault);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.dashboard, color: Colors.amberAccent),
              title: const Text('Admin Dashboard'),
              onTap: () {
                Navigator.pushNamed(context, AppRoutes.admin);
                Navigator.pop(context);
              },
            ),
          ],
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.redAccent),
            title: const Text('Logout'),
            onTap: () {
              authProvider.logout();
              Navigator.pushReplacementNamed(context, AppRoutes.login);
            },
          ),
        ],
      ),
    );
  }
}
