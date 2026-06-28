import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/workspace_provider.dart';

class AttachmentMenu extends StatelessWidget {
  const AttachmentMenu({super.key});

  @override
  Widget build(BuildContext context) {
    final workspaceProvider = Provider.of<WorkspaceProvider>(context, listen: false);

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: Color(0xFF1E1E1E), // डीपसीक का डिफ़ॉल्ट सरफेस कलर
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: GridView.count(
        shrinkWrap: true,
        crossAxisCount: 3,
        mainAxisSpacing: 24,
        crossAxisSpacing: 24,
        children: [
          _buildMenuIcon(context, Icons.photo_library, "Photos", () {}),
          _buildMenuIcon(context, Icons.camera_alt, "Camera", () {}),
          _buildMenuIcon(context, Icons.description, "Docs", () {
            workspaceProvider.changeMode(WorkspaceMode.document);
            Navigator.pop(context);
          }),
          _buildMenuIcon(context, Icons.security, "File Vault", () {
            workspaceProvider.changeMode(WorkspaceMode.vault);
            Navigator.pop(context);
          }),
          _buildMenuIcon(context, Icons.share, "Social", () {}),
          _buildMenuIcon(context, Icons.phone_in_talk, "Call Actions", () {}),
        ],
      ),
    );
  }

  Widget _buildMenuIcon(BuildContext context, IconData icon, String label, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
            radius: 28,
            backgroundColor: Colors.white10,
            child: Icon(icon, color: Colors.white, size: 28),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(color: Colors.white70, fontSize: 12),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
