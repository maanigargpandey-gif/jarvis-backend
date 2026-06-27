import 'package:flutter/material.dart';

class FingerprintScreen extends StatelessWidget {
  final VoidCallback onVerified;

  const FingerprintScreen({super.key, required this.onVerified});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 150,
          height: 150,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.cyanAccent, width: 3),
          ),
          child: const Icon(Icons.fingerprint, size: 80, color: Colors.cyanAccent),
        ),
        const SizedBox(height: 40),
        const Text(
          'Place your finger on the sensor',
          style: TextStyle(color: Colors.white54, fontSize: 16),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 30),
        ElevatedButton.icon(
          onPressed: () {
            Future.delayed(const Duration(seconds: 1), onVerified);
          },
          icon: const Icon(Icons.touch_app),
          label: const Text('Scan Fingerprint'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.cyanAccent.withOpacity(0.2),
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
          ),
        ),
      ],
    );
  }
}

========================================
FILE: frontend/lib/screens/auth/voice_match_screen.dart
========================================
import 'package:flutter/material.dart';

class VoiceMatchScreen extends StatefulWidget {
  final VoidCallback onVerified;

  const VoiceMatchScreen({super.key, required this.onVerified});

  @override
  State<VoiceMatchScreen> createState() => _VoiceMatchScreenState();
}

class _VoiceMatchScreenState extends State<VoiceMatchScreen> with SingleTickerProviderStateMixin {
  bool _isListening = false;
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  void _startListening() {
    setState(() => _isListening = true);
    _pulseController.repeat(reverse: true);
    
    Future.delayed(const Duration(seconds: 2), () {
      setState(() => _isListening = false);
      _pulseController.stop();
      widget.onVerified();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AnimatedBuilder(
          animation: _pulseController,
          builder: (context, child) {
            return Transform.scale(
              scale: _isListening ? 1.0 + (_pulseController.value * 0.2) : 1.0,
              child: Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _isListening ? Colors.cyanAccent.withOpacity(0.2) : Colors.white10,
                  border: Border.all(
                    color: _isListening ? Colors.cyanAccent : Colors.white24,
                    width: 3,
                  ),
                ),
                child: Icon(
                  Icons.mic,
                  size: 60,
                  color: _isListening ? Colors.cyanAccent : Colors.white54,
                ),
              ),
            );
          },
        ),
        const SizedBox(height: 40),
        Text(
          _isListening ? 'Listening...' : 'Say "Zarvish, unlock"',
          style: const TextStyle(color: Colors.white54, fontSize: 16),
        ),
        const SizedBox(height: 30),
        ElevatedButton.icon(
          onPressed: _isListening ? null : _startListening,
          icon: Icon(_isListening ? Icons.mic : Icons.mic_none),
          label: Text(_isListening ? 'Recording...' : 'Start Voice Match'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.cyanAccent.withOpacity(0.2),
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
          ),
        ),
      ],
    );
  }
}
