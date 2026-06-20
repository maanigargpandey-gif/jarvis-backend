import 'dart:ui';
import 'package:flutter/material.dart';

void main() {
  runApp(const JarvisApp());
}

class JarvisApp extends StatelessWidget {
  const JarvisApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'JARVIS 1.4.0',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // The Deep OLED Black Background
        scaffoldBackgroundColor: const Color(0xFF050505),
        brightness: Brightness.dark,
        // The Hacker/Health Insurance Neon Green Accent
        primaryColor: const Color(0xFF00FF41),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF00FF41),
          secondary: Color(0xFF00FF41),
          surface: Color(0xFF121212), // Slightly lighter black for cards
        ),
        fontFamily: 'RobotoMono', // Monospace for that God-Mode feel
      ),
      home: const GodModeInterface(),
    );
  }
}

class GodModeInterface extends StatefulWidget {
  const GodModeInterface({super.key});

  @override
  State<GodModeInterface> createState() => _GodModeInterfaceState();
}

class _GodModeInterfaceState extends State<GodModeInterface> {
  final PageController _pageController = PageController(initialPage: 1); // Starts at center chat

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // PageView for the 3-Tier Swipe Navigation
      body: PageView(
        controller: _pageController,
        children: [
          _buildLeftVault(),   // Index 0: Social Vault
          _buildCenterChat(),  // Index 1: Main Jarvis Chat
          _buildRightStorage(),// Index 2: Nexus Storage
        ],
      ),
    );
  }

  // ==========================================
  // LEFT SWIPE: SOCIAL VAULT
  // ==========================================
  Widget _buildLeftVault() {
    return const Center(
      child: Text(
        'SOCIAL VAULT\n(Automations & Integrations)',
        textAlign: TextAlign.center,
        style: TextStyle(color: Colors.grey, letterSpacing: 2),
      ),
    );
  }

  // ==========================================
  // RIGHT SWIPE: NEXUS STORAGE
  // ==========================================
  Widget _buildRightStorage() {
    return const Center(
      child: Text(
        'NEXUS STORAGE\n(Files, 4K Media, Docs)',
        textAlign: TextAlign.center,
        style: TextStyle(color: Colors.grey, letterSpacing: 2),
      ),
    );
  }

  // ==========================================
  // CENTER: MAIN CHAT & COMMAND CENTER
  // ==========================================
  Widget _buildCenterChat() {
    return SafeArea(
      child: Column(
        children: [
          // THE TOP BAR (Sleek, JioSphere Music Player included)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'JARVIS 1.4.0',
                  style: TextStyle(
                    color: Color(0xFF00FF41),
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                  ),
                ),
                // Background Audio Player Indicator
                Row(
                  children: [
                    const Icon(Icons.graphic_eq, color: Color(0xFF00FF41), size: 18),
                    const SizedBox(width: 8),
                    Container(
                      height: 8,
                      width: 8,
                      decoration: const BoxDecoration(
                        color: Color(0xFF00FF41),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(color: Color(0xFF00FF41), blurRadius: 10)
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // CHAT CANVAS
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: const [
                // Example Jarvis Welcome Message
                Text(
                  '> System Online.\n> Awaiting Creator Command...',
                  style: TextStyle(color: Colors.grey, height: 1.5),
                ),
              ],
            ),
          ),

          // THE COMMAND CENTER (Floating Pill Input)
          _buildFloatingInputBox(),
        ],
      ),
    );
  }

  // ==========================================
  // FLOATING INPUT BOX (Glassmorphism Effect)
  // ==========================================
  Widget _buildFloatingInputBox() {
    return Container(
      margin: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A).withOpacity(0.8), // Translucent Dark
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: const Color(0xFF333333)),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
            child: Row(
              children: [
                // The '+' Action Menu Button
                IconButton(
                  icon: const Icon(Icons.add_circle_outline, color: Color(0xFF00FF41)),
                  onPressed: () => _showActionMenu(context),
                ),
                
                // Text Field
                const Expanded(
                  child: TextField(
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: 'Command Jarvis...',
                      hintStyle: TextStyle(color: Colors.grey),
                      border: InputBorder.none,
                      isDense: true,
                    ),
                  ),
                ),

                // Mic / Verify Button
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF00FF41).withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.mic_none, color: Color(0xFF00FF41)),
                    onPressed: () {
                      // Trigger Mic & Voice Verification here
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ==========================================
  // THE ACTION MENU (Bottom Sheet)
  // ==========================================
  void _showActionMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          decoration: const BoxDecoration(
            color: Color(0xFF0A0A0A),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
            border: Border(top: BorderSide(color: Color(0xFF333333))),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'SYSTEM ACTIONS',
                style: TextStyle(color: Color(0xFF00FF41), fontSize: 12, letterSpacing: 2),
              ),
              const SizedBox(height: 20),
              _buildMenuOption(Icons.camera, 'Live CSC Browser / Form Fill'),
              _buildMenuOption(Icons.videocam, '4K Media Studio (Face Locked)'),
              _buildMenuOption(Icons.edit_document, 'Workspace & In-App Editor'),
              _buildMenuOption(Icons.architecture, 'Evolve Feature (Inject API)'),
              const SizedBox(height: 10),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMenuOption(IconData icon, String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        children: [
          Icon(icon, color: Colors.white70, size: 22),
          const SizedBox(width: 15),
          Text(title, style: const TextStyle(color: Colors.white, fontSize: 16)),
        ],
      ),
    );
  }
}
