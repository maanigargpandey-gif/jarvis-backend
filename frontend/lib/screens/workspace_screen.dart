import 'package:flutter/material.dart';

class WorkspaceScreen extends StatelessWidget {
  final String mode;
  
  const WorkspaceScreen({super.key, required this.mode});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            _getModeIcon(),
            size: 80,
            color: Colors.cyanAccent.withOpacity(0.5),
          ),
          const SizedBox(height: 20),
          Text(
            '$_getModeTitle() Workspace',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Create and edit your content here',
            style: TextStyle(color: Colors.white38),
          ),
        ],
      ),
    );
  }

  IconData _getModeIcon() {
    switch (mode) {
      case 'document':
        return Icons.description;
      case 'code':
        return Icons.code;
      case 'creative':
        return Icons.brush;
      default:
        return Icons.workspaces;
    }
  }

  String _getModeTitle() {
    return mode[0].toUpperCase() + mode.substring(1);
  }
}
