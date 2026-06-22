import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/jarvis_state_provider.dart';
import 'screens/login_screen.dart';
import 'screens/voice_verification_screen.dart';
import 'screens/face_verification_screen.dart';
import 'screens/jarvis_main_screen.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<JarvisStateProvider>(
      builder: (context, auth, _) {
        // सिक्योरिटी लेयर चेन
        switch (auth.authStage) {
          case SecurityStage.none:
            return const LoginScreen(); // या सीधे Voice पर अगर पहले ही लॉग इन है
          case SecurityStage.voiceVerified:
            return const FaceVerificationScreen(); // खटाक से चेहरा पहचानो
          case SecurityStage.faceVerified:
            return const JarvisMainScreen(); // ऑथोराइज्ड (अंदर जाओ)
          default:
            return const LoginScreen();
        }
      },
    );
  }
}
