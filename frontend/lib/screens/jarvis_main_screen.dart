import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:permission_handler/permission_handler.dart';
import '../providers/jarvis_state_provider.dart';
import 'creator_dashboard.dart'; // नया डैशबोर्ड इम्पोर्ट किया

class JarvisMainScreen extends StatefulWidget {
  const JarvisMainScreen({super.key});

  @override
  _JarvisMainScreenState createState() => _JarvisMainScreenState();
}

class _JarvisMainScreenState extends State<JarvisMainScreen> {
  final TextEditingController _textController = TextEditingController();
  bool isListening = false;

  @override
  void initState() {
    super.initState();
    _requestPermissions();
  }

  Future<void> _requestPermissions() async {
    await [Permission.microphone, Permission.camera, Permission.storage].request();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : Colors.black87;
    
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: textColor),
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        title: Text("JARVIS OS", style: TextStyle(color: textColor, fontWeight: FontWeight.w600)),
      ),
      drawer: _buildCleanDrawer(isDark, textColor),
      body: Column(
        children: [
          Expanded(child: _buildChatInterface(textColor)),
          _buildSleekInputBar(isDark),
        ],
      ),
    );
  }

  Widget _buildChatInterface(Color textColor) {
    return Consumer<JarvisStateProvider>(
      builder: (context, provider, _) {
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: provider.messages.length,
          itemBuilder: (context, index) {
            final msg = provider.messages[index];
            return ListTile(
              title: Text(msg['sender'], style: TextStyle(fontWeight: FontWeight.bold, color: textColor.withOpacity(0.6))),
              subtitle: Text(msg['text'], style: TextStyle(color: textColor)),
            );
          },
        );
      },
    );
  }

  Widget _buildSleekInputBar(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: isDark ? const Color(0xFF141414) : Colors.white),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _textController,
              decoration: const InputDecoration(hintText: 'Ask Jarvis...', border: InputBorder.none),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send),
            onPressed: () {
              if (_textController.text.isNotEmpty) {
                Provider.of<JarvisStateProvider>(context, listen: false).processUserCommand(_textController.text);
                _textController.clear();
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildCleanDrawer(bool isDark, Color textColor) {
    final provider = Provider.of<JarvisStateProvider>(context);
    return Drawer(
      backgroundColor: isDark ? const Color(0xFF0A0A0A) : Colors.white,
      child: ListView(
        children: [
          DrawerHeader(child: Text('Jarvis OS', style: TextStyle(color: textColor, fontSize: 20))),
          ListTile(leading: const Icon(Icons.music_note), title: const Text('Jio Sphere Audio')),
          ListTile(leading: const Icon(Icons.public), title: const Text('Cyber Portal')),
          
          // क्रिएटर डैशबोर्ड का गेट (यहीं लॉजिक है)
          ListTile(
            leading: const Icon(Icons.dashboard), 
            title: const Text('Creator Dashboard'),
            onTap: () {
              if (provider.currentRole == 'Creator' || provider.currentRole == 'Owner') {
                Navigator.pop(context); // पहले Drawer बंद किया
                Navigator.push(context, MaterialPageRoute(builder: (_) => const CreatorDashboard()));
              } else {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Access Denied: Only Creators allowed")));
              }
            },
          ),
          const Divider(),
          ListTile(leading: const Icon(Icons.settings), title: const Text('Settings')),
        ],
      ),
    );
  }
}
