import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/jarvis_state_provider.dart';
import 'screens/voice_verification_screen.dart';
import 'screens/unified_editor_screen.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<JarvisStateProvider>(context);
    
    // अगर ऑथेंटिकेटेड है तो Editor में जाओ, वरना Security लेयर पर रहो
    return auth.isFullyAuthenticated 
        ? const UnifiedEditorScreen() 
        : const VoiceVerificationScreen();
  }
}
