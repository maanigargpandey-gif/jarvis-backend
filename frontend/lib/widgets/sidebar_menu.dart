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
      backgroundColor: const Color(0xFF121215), // DeepSeek's Dark Ash Grey Theme
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          // 👑 DeepSeek's Original Profile / Login Header (Merged with God-Mode)
          UserAccountsDrawerHeader(
            decoration: const BoxDecoration(
              color: Color(0xFF0A0A0C), // Deep Black
              border: Border(bottom: BorderSide(color: Color(0xFF00FF41), width: 2)), // Hacker Green Border
            ),
            currentAccountPicture: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFF00E5FF), width: 2),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF00E5FF).withOpacity(0.3),
                    blurRadius: 10,
                  )
                ],
              ),
              child: const CircleAvatar(
                backgroundColor: Color(0xFF1E1E24),
                // यहाँ आप अपनी असली फोटो लगा सकते हैं: backgroundImage: NetworkImage('YOUR_PHOTO_URL_HERE'),
                child: Icon(Icons.person, color: Color(0xFF00E5FF), size: 40), 
              ),
            ),
            accountName: const Text(
              "MANI PANDEY",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                letterSpacing: 2,
                fontSize: 18,
              ),
            ),
            accountEmail: const Text(
              "maanigargpandey@gmail.com\nGOD-MODE ACTIVE",
              style: TextStyle(
                color: Color(0xFF00FF41), // Hacker Green
                fontSize: 12,
              ),
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
          
          const Divider(color: Colors.white10),
          
          // 🚪 5. DEEPSEEK SESSION TERMINATE (LOGOUT)
          _buildDrawerItem(context, Icons.logout, "Terminate Session", () {
            // Logout logic will go here
            Navigator.pop(context);
          }, color: Colors.redAccent),
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
        style: const TextStyle(
          color: Colors.white38,
          fontSize: 12,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.5,
        ),
      ),
    );
  }

  Widget _buildDrawerItem(BuildContext context, IconData icon, String title, VoidCallback onTap, {Color? color}) {
    return ListTile(
      leading: Icon(icon, color: color ?? const Color(0xFF00E5FF)), // Electric Blue Icon or Red
      title: Text(title, style: TextStyle(color: color ?? Colors.white70)),
      onTap: onTap,
      hoverColor: const Color(0xFF00FF41).withOpacity(0.1),
    );
  }
}
