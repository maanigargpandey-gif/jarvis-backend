import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/jarvis_state_provider.dart';
import '../screens/unified_editor_screen.dart';
import '../screens/login_screen.dart'; // मान लो तुम्हारी लॉगिन फाइल यहाँ है

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<JarvisStateProvider>(context);

    // अगर ऑथेंटिकेटेड है तो मेन स्क्रीन, नहीं तो लॉगिन
    return provider.isFullyAuthenticated 
        ? const UnifiedEditorScreen() 
        : const LoginScreen(); 
  }
}
