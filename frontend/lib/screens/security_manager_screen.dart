import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/jarvis_state_provider.dart';

class SecurityManagerScreen extends StatelessWidget {
  const SecurityManagerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<JarvisStateProvider>(
        builder: (context, auth, _) {
          switch (auth.currentLevel) {
            case SecurityLevel.voice:
              return _voiceLayer(context);
            case SecurityLevel.face:
              return _faceLayer(context);
            case SecurityLevel.biometrics:
              return _biometricLayer(context);
            case SecurityLevel.pin:
              return _pinLayer(context);
            case SecurityLevel.recovery:
              return _recoveryLayer(context);
          }
        },
      ),
    );
  }

  Widget _voiceLayer(context) => _buildLayer("Voice Identity", Icons.mic, "Say 'Jarvis'", context);
  Widget _faceLayer(context) => _buildLayer("Face Mesh Scan", Icons.face, "Blink to verify", context);
  Widget _biometricLayer(context) => _buildLayer("Biometric", Icons.fingerprint, "Use Fingerprint", context);
  
  // लेयर का कॉमन डिज़ाइन
  Widget _buildLayer(String title, IconData icon, String instruction, context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, size: 100),
        Text(title, style: const TextStyle(fontSize: 24)),
        Text(instruction),
        ElevatedButton(onPressed: () => Provider.of<JarvisStateProvider>(context, listen: false).recordFailure(), child: const Text("Simulate Fail"))
      ],
    );
  }

  Widget _recoveryLayer(context) => Center(child: Text("Verification Failed. Please Reset via OTP."));
  Widget _pinLayer(context) => Center(child: TextField(decoration: InputDecoration(hintText: "Enter PIN")));
}
