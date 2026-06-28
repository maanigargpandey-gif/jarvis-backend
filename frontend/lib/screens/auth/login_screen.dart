import 'package:flutter/material.dart';
import '../workspace_split_view.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A), // Deep Black Background
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // AI Core Logo Indicator
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFF00FF41), width: 2),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF00FF41).withOpacity(0.2),
                    blurRadius: 30,
                    spreadRadius: 10,
                  )
                ],
              ),
              child: const Icon(Icons.fingerprint, size: 60, color: Color(0xFF00FF41)),
            ),
            const SizedBox(height: 40),
            
            const Text(
              "ZARVISH 4.0",
              style: TextStyle(
                color: Colors.white,
                fontSize: 32,
                fontWeight: FontWeight.bold,
                letterSpacing: 4.0,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              "AWAITING CREATOR BIOMETRICS",
              style: TextStyle(color: Colors.white54, letterSpacing: 2.0),
            ),
            const SizedBox(height: 60),

            // Authentication Button
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1E1E24), // Frosted Glass Button
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                  side: const BorderSide(color: Color(0xFF00E5FF), width: 1),
                ),
              ),
              onPressed: () {
                // Biometric Bypass for now, moves to Workspace
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const WorkspaceSplitView()),
                );
              },
              child: const Text(
                "INITIATE NEURAL LINK",
                style: TextStyle(color: Color(0xFF00E5FF), fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
