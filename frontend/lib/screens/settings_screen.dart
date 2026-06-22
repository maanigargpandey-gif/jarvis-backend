import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/jarvis_state_provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Jarvis OS Settings")),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildSectionHeader("Security"),
          SwitchListTile(
            title: const Text("Enable Face/Voice Lock"),
            value: true, // इसे बाद में प्रोवाइडर से जोड़ेंगे
            onChanged: (val) {},
          ),
          _buildSectionHeader("Personalization"),
          ListTile(
            title: const Text("Theme Mode"),
            trailing: const Icon(Icons.palette),
            onTap: () {
              // थीम स्विच लॉजिक यहाँ आएगा
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text("Logout (End Session)"),
            onTap: () {
              Provider.of<JarvisStateProvider>(context, listen: false).logout();
              Navigator.pop(context); // सेटिंग्स से बाहर
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.blueAccent)),
    );
  }
}

