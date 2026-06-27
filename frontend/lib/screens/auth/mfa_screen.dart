import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../services/mfa_service.dart';
import '../../config/routes.dart';
import 'face_verification_screen.dart';
import 'fingerprint_screen.dart';
import 'voice_match_screen.dart';

class MFAScreen extends StatefulWidget {
  const MFAScreen({super.key});

  @override
  State<MFAScreen> createState() => _MFAScreenState();
}

class _MFAScreenState extends State<MFAScreen> {
  int _currentStep = 0;
  final List<bool> _completedSteps = [false, false, false, false];

  void _completeStep() {
    setState(() {
      _completedSteps[_currentStep] = true;
      if (_currentStep < 3) {
        _currentStep++;
      } else {
        _navigateToMain();
      }
    });
  }

  void _navigateToMain() {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    if (authProvider.isFullyAuthenticated) {
      Navigator.pushReplacementNamed(context, AppRoutes.main);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0E21),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'SECURITY VERIFICATION',
          style: TextStyle(color: Colors.cyanAccent, letterSpacing: 2),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            // Progress Indicator
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(4, (index) {
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _completedSteps[index]
                        ? Colors.green
                        : index == _currentStep
                            ? Colors.cyanAccent
                            : Colors.white24,
                  ),
                  child: Icon(
                    MFAService.getStepIcon(MFAService.mfaSteps[index]),
                    color: Colors.white,
                    size: 20,
                  ),
                );
              }),
            ),
            const SizedBox(height: 40),
            
            // Current verification step
            Text(
              MFAService.mfaSteps[_currentStep],
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 40),
            
            // Verification content based on current step
            Expanded(
              child: _buildVerificationStep(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVerificationStep() {
    switch (_currentStep) {
      case 0:
        return FaceVerificationScreen(onVerified: _completeStep);
      case 1:
        return FingerprintScreen(onVerified: _completeStep);
      case 2:
        return VoiceMatchScreen(onVerified: _completeStep);
      case 3:
        return _buildPinVerification();
      default:
        return const SizedBox();
    }
  }

  Widget _buildPinVerification() {
    final pinController = TextEditingController();
    
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.lock_outline, size: 80, color: Colors.cyanAccent),
        const SizedBox(height: 30),
        const Text(
          'Enter Secure PIN',
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
        const SizedBox(height: 20),
        TextField(
          controller: pinController,
          obscureText: true,
          keyboardType: TextInputType.number,
          maxLength: 4,
          style: const TextStyle(color: Colors.white, fontSize: 24, letterSpacing: 10),
          textAlign: TextAlign.center,
          decoration: const InputDecoration(
            counter: SizedBox.shrink(),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.white24),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.cyanAccent),
            ),
          ),
        ),
        const SizedBox(height: 30),
        ElevatedButton(
          onPressed: () {
            if (pinController.text.length == 4) {
              _completeStep();
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.cyanAccent,
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
          ),
          child: const Text(
            'VERIFY',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}
