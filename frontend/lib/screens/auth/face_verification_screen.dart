import 'package:flutter/material.dart';

class FaceVerificationScreen extends StatelessWidget {
  final VoidCallback onVerified;

  const FaceVerificationScreen({super.key, required this.onVerified});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 200,
          height: 200,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.cyanAccent, width: 3),
            boxShadow: [
              BoxShadow(
                color: Colors.cyanAccent.withOpacity(0.3),
                blurRadius: 20,
              ),
            ],
          ),
          child: const Icon(Icons.face, size: 100, color: Colors.cyanAccent),
        ),
        const SizedBox(height: 40),
        const Text(
          'Position your face within the frame',
          style: TextStyle(color: Colors.white54, fontSize: 16),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 30),
        ElevatedButton.icon(
          onPressed: () {
            // Simulate face verification
            Future.delayed(const Duration(seconds: 1), onVerified);
          },
          icon: const Icon(Icons.camera_alt),
          label: const Text('Scan Face'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.cyanAccent.withOpacity(0.2),
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
          ),
        ),
      ],
    );
  }
}
