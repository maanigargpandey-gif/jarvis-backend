import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

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
    await [
      Permission.microphone,
      Permission.camera,
      Permission.storage,
      Permission.location,
      Permission.locationAlways,
      Permission.manageExternalStorage,
    ].request();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : Colors.black87;
    final iconColor = isDark ? Colors.white70 : Colors.black54;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: iconColor),
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        title: Row(
          children: [
            IconButton(icon: Icon(Icons.cloud_done_outlined, color: iconColor), onPressed: () {}, tooltip: "Nexus Vault"),
            Text("JARVIS", style: TextStyle(color: textColor, fontWeight: FontWeight.w600, letterSpacing: 1.2)),
          ],
        ),
        actions: [
          IconButton(icon: Icon(Icons.visibility_outlined, color: iconColor), onPressed: () {}, tooltip: "Live Vision"),
          IconButton(icon: Icon(Icons.screen_share_outlined, color: iconColor), onPressed: () {}, tooltip: "Screen Share"),
          const SizedBox(width: 8),
        ],
      ),
      drawer: _buildCleanDrawer(isDark, textColor),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: isListening 
                ? _buildVoiceInterface(isDark)
                : _buildChatInterface(textColor),
            ),
            _buildSleekInputBar(isDark),
          ],
        ),
      ),
    );
  }

  Widget _buildVoiceInterface(bool isDark) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.graphic_eq, size: 80, color: isDark ? Colors.cyanAccent : Colors.blueAccent),
          const SizedBox(height: 20),
          Text("I'm listening...", style: TextStyle(fontSize: 18, color: isDark ? Colors.white54 : Colors.black54)),
        ],
      ),
    );
  }

  Widget _buildChatInterface(Color textColor) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Center(child: Text("Today", style: TextStyle(color: textColor.withOpacity(0.5), fontSize: 12))),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildSleekInputBar(bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF141414) : Colors.white,
        border: Border(top: BorderSide(color: isDark ? Colors.white10 : Colors.black12)),
      ),
      child: Row(
        children: [
          IconButton(icon: const Icon(Icons.add_circle_outline), color: isDark ? Colors.white54 : Colors.black54, onPressed: () {}),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: isDark ? Colors.white.withOpacity(0.05) : Colors.grey.shade200,
                borderRadius: BorderRadius.circular(24),
              ),
              child: TextField(
                controller: _textController,
                style: TextStyle(color: isDark ? Colors.white : Colors.black),
                decoration: InputDecoration(
                  hintText: 'Ask Jarvis...',
                  hintStyle: TextStyle(color: isDark ? Colors.white38 : Colors.black38),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          IconButton(
            icon: Icon(isListening ? Icons.mic_off : Icons.mic),
            color: isListening ? Colors.redAccent : (isDark ? Colors.white54 : Colors.black54),
            onPressed: () => setState(() => isListening = !isListening),
          ),
          IconButton(icon: const Icon(Icons.send), color: isDark ? Colors.white : Colors.black, onPressed: () {}),
        ],
      ),
    );
  }

  Widget _buildCleanDrawer(bool isDark, Color textColor) {
    return Drawer(
      backgroundColor: isDark ? const Color(0xFF0A0A0A) : Colors.white,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Icon(Icons.blur_on, size: 40, color: isDark ? Colors.white : Colors.black),
                const SizedBox(height: 10),
                Text('Jarvis OS', style: TextStyle(color: textColor, fontSize: 20, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          ListTile(leading: const Icon(Icons.music_note), title: const Text('Jio Sphere Audio'), onTap: () {}),
          ListTile(leading: const Icon(Icons.public), title: const Text('Cyber Portal'), onTap: () {}),
          ListTile(leading: const Icon(Icons.dashboard), title: const Text('Creator Dashboard'), onTap: () {}),
          const Divider(),
          ListTile(leading: const Icon(Icons.settings), title: const Text('Settings'), onTap: () {}),
        ],
      ),
    );
  }
}
