import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/workspace_provider.dart';
import '../screens/in_app_browser.dart';

class SidebarMenu extends StatelessWidget {
  const SidebarMenu({super.key});

  @override
  Widget build(BuildContext context) {
    final workspaceProvider = Provider.of<WorkspaceProvider>(context, listen: false);

    return Drawer(
      backgroundColor: const Color(0xFF121215), // Dark Ash Grey Theme
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          // 👑 Creator Header
          DrawerHeader(
            decoration: const BoxDecoration(
              color: Color(0xFF0A0A0C), // Deep Black
              border: Border(bottom: BorderSide(color: Color(0xFF00FF41), width: 2)), // Hacker Green Border
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color(0xFF1E1E24),
                    border: Border.all(color: const Color(0xFF00E5FF), width: 1.5),
                  ),
                  child: const Icon(Icons.security, color: Color(0xFF00E5FF), size: 30),
                ),
                const SizedBox(height: 10),
                const Text(
                  "MANI PANDEY", 
                  style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold, letterSpacing: 2),
                ),
                const Text(
                  "GOD-MODE ACTIVE", 
                  style: TextStyle(color: Color(0xFF00FF41), fontSize: 12),
                ),
              ],
            ),
          ),

          // 📂 1. CORE MODULES
          _buildCategoryTitle("CORE MODULES"),
          _buildDrawerItem(context, Icons.document_scanner, "Document Forge", () {
            workspaceProvider.changeMode(WorkspaceMode.document);
            Navigator.pop(context);
          }),
          _buildDrawerItem(context, Icons.brush, "Media Studio 8K", () {
            workspaceProvider.changeMode(WorkspaceMode.creative);
            Navigator.pop(context);
          }),
          _buildDrawerItem(context, Icons.travel_explore, "Cyber Cash Browser", () {
            Navigator.pop(context);
            Navigator.push(context, MaterialPageRoute(builder: (context) => const InAppBrowser()));
          }),

          const Divider(color: Colors.white10),

          // 📞 2. COMMUNICATION & IDENTITY
          _buildCategoryTitle("COMMUNICATION & IDENTITY"),
          _buildDrawerItem(context, Icons.phone_in_talk, "Call Manager", () {}),
          _buildDrawerItem(context, Icons.face_retouching_natural, "Biometric Lock", () {}),

          const Divider(color: Colors.white10),

          // 🔒 3. STORAGE
          _buildCategoryTitle("STORAGE"),
          _buildDrawerItem(context, Icons.lock, "Nexus Vault", () {
            workspaceProvider.changeMode(WorkspaceMode.vault);
            Navigator.pop(context);
          }),

          const Divider(color: Colors.white10),

          // ⚙️ 4. CREATOR TOOLS
          _buildCategoryTitle("CREATOR TOOLS"),
          _buildDrawerItem(context, Icons.settings_ethernet, "Self-Evolution Engine", () {
            workspaceProvider.changeMode(WorkspaceMode.code);
            Navigator.pop(context);
          }),
          _buildDrawerItem(context, Icons.terminal, "n8n Workflows", () {}),
        ],
      ),
    );
  }

  // UI Helpers
  Widget _buildCategoryTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, top: 16, bottom: 8),
      child: Text(
        title,
        style: const TextStyle(color: Colors.white38, fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 1.5),
      ),
    );
  }

  Widget _buildDrawerItem(BuildContext context, IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: const Color(0xFF00E5FF)), // Electric Blue Icon
      title: Text(title, style: const TextStyle(color: Colors.white70)),
      onTap: onTap,
      hoverColor: const Color(0xFF00FF41).withOpacity(0.1),
    );
  }
}
