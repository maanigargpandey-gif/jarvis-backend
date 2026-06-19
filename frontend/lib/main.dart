import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

// ==========================================
// SYSTEM IGNITION
// ==========================================
void main() {
  runApp(const JarvisGodModeApp());
}

class JarvisGodModeApp extends StatelessWidget {
  const JarvisGodModeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'J.A.R.V.I.S God-Mode',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(useMaterial3: true).copyWith(
        scaffoldBackgroundColor: const Color(0xFF090909), 
        colorScheme: const ColorScheme.dark(
          primary: Colors.cyanAccent,
          secondary: Colors.purpleAccent,
        ),
      ),
      home: const JarvisLoginScreen(), // ऐप अब सीधे डैशबोर्ड पर नहीं, लॉगिन पर खुलेगा
    );
  }
}

// ==========================================
// THE SECURE LOGIN PORTAL
// ==========================================
class JarvisLoginScreen extends StatefulWidget {
  const JarvisLoginScreen({super.key});

  @override
  State<JarvisLoginScreen> createState() => _JarvisLoginScreenState();
}

class _JarvisLoginScreenState extends State<JarvisLoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String errorMessage = '';

  void _attemptLogin() {
    String user = _usernameController.text.trim();
    String pass = _passwordController.text.trim();

    // तुम्हारा सीक्रेट क्रिएटर लॉगिन
    if (user == 'mani' && pass == 'God mode 123') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const MasterGirgitDashboard()),
      );
    } else {
      setState(() {
        errorMessage = 'ACCESS DENIED: Unauthorized Identity.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.security, size: 80, color: Colors.cyanAccent),
              const SizedBox(height: 20),
              const Text("J.A.R.V.I.S SECURE LOGIN", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, letterSpacing: 2, color: Colors.white)),
              const SizedBox(height: 40),
              
              // Username & Password
              TextField(
                controller: _usernameController,
                decoration: InputDecoration(labelText: "Identity (Username)", border: const OutlineInputBorder(), prefixIcon: const Icon(Icons.person)),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(labelText: "Passcode (Password)", border: const OutlineInputBorder(), prefixIcon: const Icon(Icons.lock)),
              ),
              
              const SizedBox(height: 10),
              Text(errorMessage, style: const TextStyle(color: Colors.redAccent)),
              const SizedBox(height: 20),

              // CREATOR LOGIN BUTTON
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.cyanAccent.withOpacity(0.2), side: const BorderSide(color: Colors.cyanAccent)),
                  onPressed: _attemptLogin,
                  child: const Text("INITIALIZE SYSTEM", style: TextStyle(color: Colors.cyanAccent, fontWeight: FontWeight.bold, fontSize: 16)),
                ),
              ),
              const SizedBox(height: 40),
              
              const Divider(color: Colors.white24),
              const SizedBox(height: 20),
              const Text("OWNER / GUEST ACCESS", style: TextStyle(color: Colors.grey)),
              const SizedBox(height: 20),

              // SOCIAL SIGNUP BUTTONS
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  OutlinedButton.icon(
                    icon: const Icon(Icons.g_mobiledata, color: Colors.white),
                    label: const Text("Google", style: TextStyle(color: Colors.white)),
                    onPressed: () { /* Logic for Google Signup */ },
                  ),
                  OutlinedButton.icon(
                    icon: const Icon(Icons.chat, color: Colors.greenAccent),
                    label: const Text("WhatsApp", style: TextStyle(color: Colors.white)),
                    onPressed: () { /* Logic for WhatsApp Signup */ },
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

// ==========================================
// THE GIRGIT UI DASHBOARD (बाकी का सारा पुराना कोड सेम रहेगा)
// ==========================================
class MasterGirgitDashboard extends StatefulWidget {
  const MasterGirgitDashboard({super.key});

  @override
  State<MasterGirgitDashboard> createState() => _MasterGirgitDashboardState();
}

class _MasterGirgitDashboardState extends State<MasterGirgitDashboard> {
  String currentUIState = 'AI_CHAT'; 
  bool isServerConnected = false;

  @override
  void initState() {
    super.initState();
    _connectToRenderBackend(); 
  }

  Future<void> _connectToRenderBackend() async {
    try {
      final response = await http.get(Uri.parse('https://jarvis-backend-afg8.onrender.com/system-status'));
      if (response.statusCode == 200) {
        setState(() => isServerConnected = true);
      }
    } catch (e) {
      setState(() => isServerConnected = false);
    }
  }

  void transformUI(String newState) {
    setState(() => currentUIState = newState);
  }

  Widget _buildGirgitInterface() {
    switch (currentUIState) {
      case 'VIDEO_STUDIO': return const CapCutVideoStudio();
      case 'PHOTO_STUDIO': return const HighEndPhotoStudio();
      case 'OFFICE_FORGE': return const OfficeForgeEditor();
      case 'NEXUS_VAULT': return const NexusVaultArchive();
      case 'SELF_EVOLUTION': return const SelfEvolutionConsole();
      case 'FASHION_3D': return const Fashion3DEngine();
      case 'AI_CHAT':
      default: return AIChatInterface(onTransform: transformUI);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Icon(Icons.security, color: isServerConnected ? Colors.greenAccent : Colors.redAccent, size: 18),
            const SizedBox(width: 8),
            Text(isServerConnected ? "System Online" : "Connecting...", 
                style: const TextStyle(color: Colors.cyanAccent, fontSize: 14)),
          ],
        ),
        backgroundColor: Colors.black,
        actions: [
          IconButton(icon: const Icon(Icons.style, color: Colors.pinkAccent), onPressed: () => transformUI('FASHION_3D')),
          IconButton(icon: const Icon(Icons.storage, color: Colors.blueAccent), onPressed: () => transformUI('NEXUS_VAULT')),
          IconButton(icon: const Icon(Icons.auto_awesome, color: Colors.yellowAccent), onPressed: () => transformUI('SELF_EVOLUTION'))
        ],
      ),
      body: Stack(
        children: [
          AnimatedSwitcher(duration: const Duration(milliseconds: 400), child: _buildGirgitInterface()),
          const Positioned(top: 20, left: 20, child: CallManagerPIP()),
          const Positioned(top: 20, right: 20, child: LiveCameraPIP()),
        ],
      ),
    );
  }
}

// --- MODULE 1: AI CHAT ---
class AIChatInterface extends StatelessWidget {
  final Function(String) onTransform;
  const AIChatInterface({super.key, required this.onTransform});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Expanded(child: Center(child: Text("Voice/Biometric Secured. Awaiting Command...", style: TextStyle(color: Colors.grey)))),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 10), color: const Color(0xFF151515),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(icon: const Icon(Icons.thumb_up_alt_outlined, color: Colors.white54), onPressed: (){}),
                  IconButton(icon: const Icon(Icons.refresh, color: Colors.white54), onPressed: (){}),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.blueAccent.withOpacity(0.2)),
                    icon: const Icon(Icons.save_alt, color: Colors.cyanAccent),
                    label: const Text("Save to Nexus", style: TextStyle(color: Colors.cyanAccent)),
                    onPressed: () {},
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 10,
                children: [
                  ActionChip(label: const Text("Office Forge"), onPressed: () => onTransform('OFFICE_FORGE')),
                  ActionChip(label: const Text("Video Studio"), onPressed: () => onTransform('VIDEO_STUDIO')),
                ],
              )
            ],
          ),
        )
      ],
    );
  }
}

// --- MODULE 2 TO 6: (शॉर्टेंड फॉर UI) ---
class NexusVaultArchive extends StatelessWidget {
  const NexusVaultArchive({super.key});
  @override
  Widget build(BuildContext context) => const Center(child: Text("NEXUS VAULT SECURED STORAGE", style: TextStyle(color: Colors.blueAccent, fontSize: 20)));
}
class OfficeForgeEditor extends StatelessWidget {
  const OfficeForgeEditor({super.key});
  @override
  Widget build(BuildContext context) => const Center(child: Text("DOCUMENT FORGE ACTIVE", style: TextStyle(color: Colors.greenAccent, fontSize: 20)));
}
class CapCutVideoStudio extends StatelessWidget {
  const CapCutVideoStudio({super.key});
  @override
  Widget build(BuildContext context) => const Center(child: Text("VIDEO STUDIO ACTIVE", style: TextStyle(color: Colors.purpleAccent, fontSize: 20)));
}
class HighEndPhotoStudio extends StatelessWidget {
  const HighEndPhotoStudio({super.key});
  @override
  Widget build(BuildContext context) => const Center(child: Text("PHOTO STUDIO ACTIVE", style: TextStyle(color: Colors.tealAccent, fontSize: 20)));
}
class Fashion3DEngine extends StatelessWidget {
  const Fashion3DEngine({super.key});
  @override
  Widget build(BuildContext context) => const Center(child: Text("3D FASHION TRY-ON", style: TextStyle(color: Colors.pinkAccent, fontSize: 20)));
}
class SelfEvolutionConsole extends StatelessWidget {
  const SelfEvolutionConsole({super.key});
  @override
  Widget build(BuildContext context) => const Center(child: Text("SELF EVOLUTION PROTOCOL RUNNING", style: TextStyle(color: Colors.yellowAccent, fontSize: 20)));
}
class CallManagerPIP extends StatelessWidget {
  const CallManagerPIP({super.key});
  @override
  Widget build(BuildContext context) => Container(padding: const EdgeInsets.all(8), color: Colors.black87, child: const Text("Call Manager: ON", style: TextStyle(color: Colors.greenAccent, fontSize: 12)));
}
class LiveCameraPIP extends StatelessWidget {
  const LiveCameraPIP({super.key});
  @override
  Widget build(BuildContext context) => Container(width: 80, height: 100, color: Colors.black87, child: const Icon(Icons.camera_alt, color: Colors.white54));
}
