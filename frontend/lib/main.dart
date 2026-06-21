import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:local_auth/local_auth.dart';

// कोर फाइल्स 
import 'core/agent_orchestrator.dart';

// स्क्रीन्स (भविष्य के लिए रूट्स)
import 'screens/jarvis_main_screen.dart'; // यह आपका नया डायनामिक 'गिरगिट' UI होगा
import 'screens/auth/login_screen.dart'; // लॉगिन/साइन-अप पेज
import 'screens/editor/file_editor_screen.dart'; // MS Office जैसा एडिटिंग सूट

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AgentOrchestrator()),
      ],
      child: JarvisApp(),
    ),
  );
}

class JarvisApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Jarvis AI OS',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.black,
        scaffoldBackgroundColor: const Color(0xFF0A0A0A),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF0A0A0A),
          elevation: 0,
        ),
      ),
      // ऐप स्टार्ट होते ही सबसे पहले आपका पुराना AuthGate (Biometric) चलेगा
      initialRoute: '/',
      routes: {
        '/': (context) => AuthGate(), 
        '/login': (context) => const LoginScreen(),
        '/home': (context) => const JarvisMainScreen(),
        '/editor': (context) => const FileEditorScreen(),
      },
    );
  }
}

// यह आपका पुराना कोड है, जिसे बिल्कुल नहीं छेड़ा गया है
class AuthGate extends StatefulWidget {
  @override
  _AuthGateState createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  final LocalAuthentication auth = LocalAuthentication();
  bool isAuthenticated = false;

  @override
  void initState() {
    super.initState();
    _authenticate();
  }

  Future<void> _authenticate() async {
    try {
      final bool canAuthenticateWithBiometrics = await auth.canCheckBiometrics;
      final bool canAuthenticate = canAuthenticateWithBiometrics || await auth.isDeviceSupported();

      if (canAuthenticate) {
        final bool didAuthenticate = await auth.authenticate(
          localizedReason: 'Jarvis Core: Biometric Verification Required',
          options: const AuthenticationOptions(biometricOnly: false),
        );
        setState(() {
          isAuthenticated = didAuthenticate;
        });
      } else {
        setState(() {
          isAuthenticated = true;
        });
      }
    } catch (e) {
      print("Authentication error: $e");
      setState(() {
        isAuthenticated = true; 
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!isAuthenticated) {
      return Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.lock_outline, color: Colors.redAccent, size: 80),
              const SizedBox(height: 20),
              const Text(
                "SYSTEM LOCKED",
                style: TextStyle(color: Colors.redAccent, fontSize: 24, fontFamily: 'Courier', fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      );
    }

    // बायोमेट्रिक पास होने के बाद, अब यह पुराने टर्मिनल की जगह नए डायनामिक UI पर जाएगा
    return const JarvisMainScreen();
  }
}
