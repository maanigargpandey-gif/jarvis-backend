import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/jarvis_state_provider.dart';
import 'creator_dashboard.dart';
import 'settings_screen.dart';

class JarvisMainScreen extends StatefulWidget {
  const JarvisMainScreen({super.key});

  @override
  _JarvisMainScreenState createState() => _JarvisMainScreenState();
}

class _JarvisMainScreenState extends State<JarvisMainScreen> {
  final TextEditingController _textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("JARVIS OS")),
      drawer: _buildDrawer(context),
      body: Column(
        children: [
          Expanded(
            child: Consumer<JarvisStateProvider>(
              builder: (context, provider, _) => ListView.builder(
                itemCount: provider.messages.length,
                itemBuilder: (context, index) => ListTile(
                  title: Text(provider.messages[index]['sender']),
                  subtitle: Text(provider.messages[index]['text']),
                ),
              ),
            ),
          ),
          _buildInputBar(context),
        ],
      ),
    );
  }

  Widget _buildDrawer(BuildContext context) {
    final provider = Provider.of<JarvisStateProvider>(context);
    return Drawer(
      child: ListView(
        children: [
          const DrawerHeader(child: Center(child: Text("JARVIS OS"))),
          ListTile(
            leading: const Icon(Icons.dashboard),
            title: const Text('Creator Dashboard'),
            onTap: () {
              if (provider.currentRole == 'Creator' || provider.currentRole == 'Owner') {
                Navigator.push(context, MaterialPageRoute(builder: (_) => const CreatorDashboard()));
              } else {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Access Denied")));
              }
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Settings'),
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SettingsScreen())),
          ),
        ],
      ),
    );
  }

  Widget _buildInputBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(child: TextField(controller: _textController)),
          IconButton(
            icon: const Icon(Icons.send),
            onPressed: () {
              Provider.of<JarvisStateProvider>(context, listen: false).processUserCommand(_textController.text);
              _textController.clear();
            },
          ),
        ],
      ),
    );
  }
}
