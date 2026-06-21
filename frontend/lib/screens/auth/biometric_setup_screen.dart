import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../jarvis_main_screen.dart';

class BiometricSetupScreen extends StatefulWidget {
  const BiometricSetupScreen({Key? key}) : super(key: key);

  @override
  _BiometricSetupScreenState createState() => _BiometricSetupScreenState();
}

class _BiometricSetupScreenState extends State<BiometricSetupScreen> {
  bool isFaceRegistered = false;
  bool isVoiceRegistered = false;
  bool isFingerRegistered = false;

  void _registerBiometric(String type) {
    // यहाँ बैकएंड के /register_owner_face या /register_owner_voice API को हिट करेंगे
    setState(() {
      if (type == 'face') isFaceRegistered = true;
      if (type == 'voice') isVoiceRegistered = true;
      if (type == 'finger') isFingerRegistered = true;
    });
  }

  Future<void> _completeSetup() async {
    if (isFaceRegistered && isVoiceRegistered && isFingerRegistered) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setBool('is_registered', true);
      await prefs.setString('jarvis_role', 'Owner'); // नया यूज़र Owner बनेगा

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const JarvisMainScreen()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please complete all 3 security registrations.", style: TextStyle(color: Colors.redAccent))),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      appBar: AppBar(
        title: const Text("IDENTITY SETUP", style: TextStyle(color: Colors.cyanAccent, fontFamily: 'Courier', fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            const Text(
              "To secure your Nexus Vault and activate God-Mode, JARVIS requires your unique biometric signatures.",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white54, fontSize: 14),
            ),
            const SizedBox(height: 40),
            
            _buildSetupCard("Facial Identity", Icons.face, isFaceRegistered, () => _registerBiometric('face')),
            const SizedBox(height: 16),
            _buildSetupCard("Voice Print", Icons.mic, isVoiceRegistered, () => _registerBiometric('voice')),
            const SizedBox(height: 16),
            _buildSetupCard("Fingerprint Scan", Icons.fingerprint, isFingerRegistered, () => _registerBiometric('finger')),
            
            const Spacer(),
            ElevatedButton(
              onPressed: _completeSetup,
              style: ElevatedButton.styleFrom(
                backgroundColor: (isFaceRegistered && isVoiceRegistered && isFingerRegistered) 
                    ? Colors.cyanAccent 
                    : Colors.grey.shade800,
                minimumSize: const Size(double.infinity, 55),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text("INITIALIZE SYSTEM", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16, fontFamily: 'Courier')),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildSetupCard(String title, IconData icon, bool isDone, VoidCallback onTap) {
    return ListTile(
      onTap: isDone ? null : onTap,
      tileColor: const Color(0xFF141414),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: isDone ? Colors.greenAccent : Colors.white10),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      leading: Icon(icon, color: isDone ? Colors.greenAccent : Colors.white70, size: 32),
      title: Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      subtitle: Text(isDone ? "Registered" : "Tap to Scan", style: TextStyle(color: isDone ? Colors.greenAccent : Colors.white38)),
      trailing: isDone ? const Icon(Icons.check_circle, color: Colors.greenAccent) : const Icon(Icons.arrow_forward_ios, color: Colors.white38, size: 16),
    );
  }
}
