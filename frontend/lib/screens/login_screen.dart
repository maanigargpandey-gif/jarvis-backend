import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/jarvis_state_provider.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.blur_on, size: 100),
            const SizedBox(height: 20),
            const Text("JARVIS OS", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 50),
            ElevatedButton(
              onPressed: () {
                // अभी के लिए इसे Owner मानकर लॉगिन कर रहे हैं (आगे OTP/Google लगेगा)
                Provider.of<JarvisStateProvider>(context, listen: false).loginUser("Owner");
              },
              child: const Text("Sign in as Owner"),
            ),
          ],
        ),
      ),
    );
  }
}
