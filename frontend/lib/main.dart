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
      home: const AuthGate(),
    );
  }
}

// ==========================================
// 🛡️ SECURITY CORE (Biometric Entry)
// ==========================================
class AuthGate extends StatefulWidget {
  const AuthGate({super.key});
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
      final bool canAuthenticate = await auth.canCheckBiometrics || await auth.isDeviceSupported();
      if (canAuthenticate) {
        final bool didAuthenticate = await auth.authenticate(
          localizedReason: 'Jarvis Core: Authentication Required',
          options: const AuthenticationOptions(biometricOnly: false, stickyAuth: true),
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
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: isAuthenticated 
          ? const CircularProgressIndicator(color: Colors.cyanAccent)
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(Icons.lock_outline, color: Colors.redAccent, size: 80),
                SizedBox(height: 20),
                Text("SYSTEM LOCKED", style: TextStyle(color: Colors.redAccent, fontSize: 24, fontFamily: 'Courier', fontWeight: FontWeight.bold)),
              ],
            ),
      ),
    );
  }
}

// ==========================================
// 🌌 ANIMATED BACKGROUND (Breathing Core)
// ==========================================
class AnimatedAIGradient extends StatelessWidget {
  final Widget child;
  const AnimatedAIGradient({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: const BoxDecoration(
            gradient: RadialGradient(
              center: Alignment(0, -0.2),
              radius: 1.5,
              colors: [Color(0xFF1E3A8A), Color(0xFF0A0A0A)],
            ),
          ),
        ),
        child,
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
  final List<Map<String, String>> _messages = [];
  bool _isLoading = false;

  void _sendMessage() async {
    if (_textController.text.trim().isEmpty) return;
    setState(() {
      _messages.add({"sender": "user", "text": _textController.text});
      _textController.clear();
      _isLoading = true;
    });

    // यहाँ आप अपना API कॉल लॉजिक रखें
    await Future.delayed(const Duration(seconds: 1)); // Dummy Delay
    setState(() {
      _isLoading = false;
      _messages.add({"sender": "jarvis", "text": "Command processed via Nexus Engine."});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(title: const Text('JARVIS'), centerTitle: true, backgroundColor: Colors.transparent),
      body: AnimatedAIGradient(
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: _messages.length,
                itemBuilder: (context, i) => ListTile(
                  title: Text(_messages[i]['text']!, style: const TextStyle(color: Colors.white)),
                  leading: Icon(_messages[i]['sender'] == 'user' ? Icons.person : Icons.blur_on, color: Colors.cyanAccent),
                ),
              ),
            ),
            if (_isLoading) const CircularProgressIndicator(color: Colors.cyanAccent),
            Container(
              padding: const EdgeInsets.all(10),
              child: TextField(
                controller: _textController,
                decoration: InputDecoration(hintText: 'Command Jarvis...', filled: true, fillColor: Colors.white10, border: OutlineInputBorder(borderRadius: BorderRadius.circular(20))),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
