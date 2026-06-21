import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:local_auth/local_auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const JarvisApp());
}

class JarvisApp extends StatelessWidget {
  const JarvisApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'JARVIS AI OS',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0A0A0A),
        primaryColor: Colors.cyanAccent,
        fontFamily: 'Roboto',
      ),
      // एंट्री पॉइंट अब बायोमेट्रिक गेट है
      home: AuthGate(),
    );
  }
}

// ==========================================
// 🛡️ SECURITY CORE (Biometric Entry)
// ==========================================
class AuthGate extends StatefulWidget {
  @override
  _AuthGateState createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  final LocalAuthentication auth = LocalAuthentication();
  bool isAuthenticated = false;

  @override
  void initState() {
    super.initState();
    _authenticate();
  }

  Future<void> _authenticate() async {
    try {
      final bool canAuthenticateWithBiometrics = await auth.canCheckBiometrics;
      final bool canAuthenticate = canAuthenticateWithBiometrics || await auth.isDeviceSupported();

      if (canAuthenticate) {
        final bool didAuthenticate = await auth.authenticate(
          localizedReason: 'Jarvis Core: Biometric Verification Required',
          options: const AuthenticationOptions(biometricOnly: false),
        );
        setState(() => isAuthenticated = didAuthenticate);
        if (didAuthenticate) _checkExistingProfile();
      } else {
        setState(() => isAuthenticated = true);
        _checkExistingProfile();
      }
    } catch (e) {
      setState(() => isAuthenticated = true);
      _checkExistingProfile();
    }
  }

  // चेक करें कि क्या यूजर पहले ही लॉगिन कर चुका है
  Future<void> _checkExistingProfile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? role = prefs.getString('jarvis_role');
    if (role != null && role.isNotEmpty) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => JarvisChatScreen(role: role)));
    } else {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const ProfileSelector()));
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!isAuthenticated) {
      return Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.lock_outline, color: Colors.redAccent, size: 80),
              const SizedBox(height: 20),
              const Text("SYSTEM LOCKED", style: TextStyle(color: Colors.redAccent, fontSize: 24, fontFamily: 'Courier', fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      );
    }
    // लोड होने के दौरान खाली स्क्रीन
    return const Scaffold(backgroundColor: Colors.black, body: Center(child: CircularProgressIndicator(color: Colors.cyanAccent)));
  }
}

// ==========================================
// 🌌 ANIMATED BACKGROUND (Breathing Core)
// ==========================================
class AnimatedAIGradient extends StatefulWidget {
  final Widget child;
  const AnimatedAIGradient({super.key, required this.child});

  @override
  State<AnimatedAIGradient> createState() => _AnimatedAIGradientState();
}

class _AnimatedAIGradientState extends State<AnimatedAIGradient> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(seconds: 4))..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Container(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: const Alignment(0, -0.2),
                  radius: 1.5 + (_controller.value * 0.15),
                  colors: [
                    const Color(0xFF1E3A8A).withOpacity(0.5 + (_controller.value * 0.2)),
                    const Color(0xFF4C1D95).withOpacity(0.3),
                    const Color(0xFF0A0A0A),
                  ],
                  stops: const [0.0, 0.5, 1.0],
                ),
              ),
            );
          },
        ),
        widget.child,
      ],
    );
  }
}

// ==========================================
// 1. PROFILE SELECTOR
// ==========================================
class ProfileSelector extends StatelessWidget {
  const ProfileSelector({super.key});

  void _goToChat(BuildContext context, String role) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('jarvis_role', role);
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => JarvisChatScreen(role: role)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedAIGradient(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.blur_on, size: 90, color: Colors.cyanAccent), 
              const SizedBox(height: 20),
              const Text("JARVIS SYSTEM OS", style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, letterSpacing: 2)),
              const SizedBox(height: 50),
              _buildProfileCard(context, "Creator", "Full Architecture Access", Icons.admin_panel_settings, Colors.cyanAccent),
              _buildProfileCard(context, "Owner", "Authorized System Use", Icons.person, Colors.blueAccent),
              _buildProfileCard(context, "Guest", "Restricted Sandbox", Icons.face, Colors.grey),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileCard(BuildContext context, String role, String desc, IconData icon, Color color) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 50, vertical: 12),
      leading: CircleAvatar(backgroundColor: color.withOpacity(0.2), child: Icon(icon, color: color)),
      title: Text(role, style: TextStyle(color: color, fontSize: 18, fontWeight: FontWeight.bold)),
      subtitle: Text(desc, style: const TextStyle(color: Colors.white70)),
      onTap: () => _goToChat(context, role),
    );
  }
}

// ==========================================
// 2. MAIN CHAT UI (The Nexus Hub)
// ==========================================
class JarvisChatScreen extends StatefulWidget {
  final String role;
  const JarvisChatScreen({super.key, required this.role});

  @override
  State<JarvisChatScreen> createState() => _JarvisChatScreenState();
}

class _JarvisChatScreenState extends State<JarvisChatScreen> {
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<Map<String, String>> _messages = [];
  bool _isLoading = false;
  
  // 🔑 यहाँ अपना असली JARVIS_AUTH_TOKEN डालें
  final String hfToken = "YOUR_JARVIS_AUTH_TOKEN"; 

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(_scrollController.position.maxScrollExtent, duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
      }
    });
  }

  void _sendMessage() async {
    String text = _textController.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _messages.add({"sender": "user", "text": text});
      _textController.clear();
      _isLoading = true;
    });
    _scrollToBottom();

    try {
      final response = await http.post(
        Uri.parse('https://api-inference.huggingface.co/models/YOUR_MODEL_NAME'), // अपना एंडपॉइंट अपडेट करें
        headers: {"Content-Type": "application/json", "Authorization": "Bearer $hfToken"},
        body: jsonEncode({"inputs": text}),
      );

      setState(() => _isLoading = false);
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        String aiResponse = data is List ? data[0]['generated_text'] : data['response'] ?? "Processed.";
        setState(() => _messages.add({"sender": "jarvis", "text": aiResponse}));
      } else {
        setState(() => _messages.add({"sender": "jarvis", "text": "System Error: ${response.statusCode}"}));
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _messages.add({"sender": "jarvis", "text": "Connection Lost to Nexus."});
      });
    }
    _scrollToBottom();
  }

  // 📂 द अल्टीमेट अटैचमेंट मेन्यू (Plus Button)
  void _showAttachmentMenu() {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1A1A1A),
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(16.0),
        child: Wrap(
          children: [
            const Padding(
              padding: EdgeInsets.only(bottom: 10),
              child: Text("QUICK LAUNCH", style: TextStyle(color: Colors.grey, fontSize: 12, fontWeight: FontWeight.bold)),
            ),
            ListTile(
              leading: const Icon(Icons.camera, color: Colors.cyanAccent), 
              title: const Text('Media Studio (8K/4K)'),
              subtitle: const Text('Strict Facial Consistency Enabled', style: TextStyle(fontSize: 11, color: Colors.white54)),
              onTap: () { Navigator.pop(context); /* Open Media Studio */ },
            ),
            ListTile(
              leading: const Icon(Icons.document_scanner, color: Colors.orangeAccent), 
              title: const Text('Document Forge & Office Tools'),
              subtitle: const Text('Automated Portals & Formatting', style: TextStyle(fontSize: 11, color: Colors.white54)),
              onTap: () { Navigator.pop(context); /* Open Document Forge */ },
            ),
            ListTile(
              leading: const Icon(Icons.language, color: Colors.blueAccent), 
              title: const Text('In-App Web Browser'),
              subtitle: const Text('Secure Web Portals', style: TextStyle(fontSize: 11, color: Colors.white54)),
              onTap: () { Navigator.pop(context); /* Open Browser */ },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('JARVIS', style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 2)),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      drawer: _buildSidebar(),
      body: AnimatedAIGradient(
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.all(16),
                  itemCount: _messages.length,
                  itemBuilder: (context, i) {
                    bool isUser = _messages[i]['sender'] == 'user';
                    return Container(
                      margin: const EdgeInsets.only(bottom: 20),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
                        children: [
                          if (!isUser) const CircleAvatar(backgroundColor: Colors.white12, child: Icon(Icons.blur_on, color: Colors.cyanAccent, size: 20)),
                          if (!isUser) const SizedBox(width: 10),
                          Flexible(
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                              decoration: BoxDecoration(
                                color: isUser ? Colors.cyan.withOpacity(0.2) : Colors.black45,
                                border: Border.all(color: isUser ? Colors.cyanAccent.withOpacity(0.5) : Colors.white24),
                                borderRadius: BorderRadius.circular(20).copyWith(
                                  bottomRight: isUser ? const Radius.circular(0) : const Radius.circular(20),
                                  topLeft: !isUser ? const Radius.circular(0) : const Radius.circular(20),
                                ),
                              ),
                              child: Text(_messages[i]['text']!, style: const TextStyle(fontSize: 16, color: Colors.white, height: 1.4)),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              if (_isLoading) const Padding(padding: EdgeInsets.all(8.0), child: CircularProgressIndicator(color: Colors.cyanAccent)),
              _buildInputArea(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputArea() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: Colors.black.withOpacity(0.8)),
      child: Row(
        children: [
          IconButton(icon: const Icon(Icons.add_circle, color: Colors.cyanAccent, size: 28), onPressed: _showAttachmentMenu),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(color: Colors.white10, borderRadius: BorderRadius.circular(25)),
              child: TextField(
                controller: _textController,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(hintText: 'Command Jarvis...', hintStyle: TextStyle(color: Colors.white54), border: InputBorder.none),
                onSubmitted: (_) => _sendMessage(),
              ),
            ),
          ),
          const SizedBox(width: 8),
          IconButton(icon: const Icon(Icons.mic, color: Colors.cyanAccent, size: 28), onPressed: () { /* Voice Logic */ }),
          const SizedBox(width: 8),
          CircleAvatar(
            backgroundColor: Colors.cyanAccent,
            child: IconButton(icon: const Icon(Icons.send, color: Colors.black), onPressed: _sendMessage),
          ),
        ],
      ),
    );
  }

  // 🍔 SIDEBAR 
  Widget _buildSidebar() {
    return Drawer(
      backgroundColor: const Color(0xFF0F0F0F),
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(gradient: LinearGradient(colors: [Color(0xFF1E3A8A), Color(0xFF0A0A0A)], begin: Alignment.topLeft, end: Alignment.bottomRight)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const Icon(Icons.blur_on, size: 40, color: Colors.cyanAccent),
                const SizedBox(height: 10),
                Text('Role: ${widget.role}', style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                const Text('Server: Gorakhpur Region Nexus', style: TextStyle(color: Colors.white54, fontSize: 12)),
              ],
            ),
          ),
          const Padding(padding: EdgeInsets.only(left: 16, top: 10, bottom: 5), child: Text("CORE MODULES", style: TextStyle(color: Colors.grey, fontSize: 12, fontWeight: FontWeight.bold))),
          const ListTile(leading: Icon(Icons.camera_enhance, color: Colors.cyanAccent), title: Text('Media Studio', style: TextStyle(color: Colors.white))),
          const ListTile(leading: Icon(Icons.edit_document, color: Colors.orangeAccent), title: Text('Document Forge & CSC', style: TextStyle(color: Colors.white))),
          const ListTile(leading: Icon(Icons.language, color: Colors.blueAccent), title: Text('Web Browser', style: TextStyle(color: Colors.white))),
          const Divider(color: Colors.white24),
          const Padding(padding: EdgeInsets.only(left: 16, top: 10, bottom: 5), child: Text("STORAGE", style: TextStyle(color: Colors.grey, fontSize: 12, fontWeight: FontWeight.bold))),
          const ListTile(leading: Icon(Icons.folder_shared, color: Colors.amberAccent), title: Text('Nexus Vault', style: TextStyle(color: Colors.white))),
          const Divider(color: Colors.white24),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.redAccent),
            title: const Text('Switch Profile', style: TextStyle(color: Colors.redAccent)),
            onTap: () async {
              SharedPreferences prefs = await SharedPreferences.getInstance();
              await prefs.remove('jarvis_role');
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const ProfileSelector()));
            },
          ),
        ],
      ),
    );
  }
}
