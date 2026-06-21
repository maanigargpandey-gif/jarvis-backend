import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'biometric_setup_screen.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  // लॉगिन के बाद सेटअप स्क्रीन पर भेजें
  void _handleLogin(BuildContext context, String method) {
    // यहाँ असली API कॉल लगेगी, अभी के लिए सीधा नेविगेट कर रहे हैं
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Authenticating via $method...", style: const TextStyle(fontFamily: 'Courier'))),
    );
    
    Future.delayed(const Duration(seconds: 1), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const BiometricSetupScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Icon(Icons.blur_on, color: Colors.cyanAccent, size: 100),
              const SizedBox(height: 20),
              const Text(
                "JARVIS NEXUS",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold, fontFamily: 'Courier', letterSpacing: 3),
              ),
              const SizedBox(height: 10),
              const Text(
                "Initialize System Access Protocol",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white54, fontSize: 14),
              ),
              const SizedBox(height: 60),

              // मोबाइल नंबर लॉगिन
              TextField(
                keyboardType: TextInputType.phone,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: "Enter Mobile Number",
                  hintStyle: const TextStyle(color: Colors.white38),
                  prefixIcon: const Icon(Icons.phone_android, color: Colors.cyanAccent),
                  filled: true,
                  fillColor: const Color(0xFF141414),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => _handleLogin(context, "Mobile OTP"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.cyanAccent.withOpacity(0.2),
                  side: const BorderSide(color: Colors.cyanAccent),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text("SEND OTP", style: TextStyle(color: Colors.cyanAccent, fontWeight: FontWeight.bold, fontFamily: 'Courier')),
              ),
              const SizedBox(height: 30),
              const Center(child: Text("OR CONNECT WITH", style: TextStyle(color: Colors.white38, fontSize: 12, fontWeight: FontWeight.bold))),
              const SizedBox(height: 30),

              // WhatsApp लॉगिन
              OutlinedButton.icon(
                onPressed: () => _handleLogin(context, "WhatsApp"),
                icon: const Icon(Icons.chat, color: Colors.greenAccent),
                label: const Text("Continue with WhatsApp", style: TextStyle(color: Colors.white)),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  side: const BorderSide(color: Colors.white24),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 16),

              // Google लॉगिन
              OutlinedButton.icon(
                onPressed: () => _handleLogin(context, "Google"),
                icon: const Icon(Icons.g_mobiledata, color: Colors.redAccent, size: 32),
                label: const Text("Continue with Google", style: TextStyle(color: Colors.white)),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  side: const BorderSide(color: Colors.white24),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
