import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/jarvis_state_provider.dart';
import 'auth_gate.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => JarvisStateProvider()),
      ],
      child: const JarvisApp(),
    ),
  );
}

class JarvisApp extends StatelessWidget {
  const JarvisApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'JARVIS OS',
      theme: ThemeData(
        brightness: Brightness.light,
        scaffoldBackgroundColor: const Color(0xFFF5F5F7),
        primaryColor: Colors.black,
        fontFamily: 'Roboto',
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0A0A0A),
        primaryColor: Colors.white,
        fontFamily: 'Roboto',
      ),
      themeMode: ThemeMode.system,
      // यह हमारे 11 स्टेप्स का 'मेन गेट' है। 
      // यह चेक करेगा कि यूजर ने Voice -> Face -> Biometric लेयर पार की है या नहीं।
      home: const AuthGate(),
    );
  }
}
