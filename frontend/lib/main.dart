import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/jarvis_state_provider.dart';
import 'screens/jarvis_main_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => JarvisStateProvider())],
      child: const JarvisApp(),
    ),
  );
}

class JarvisApp extends StatelessWidget {
  const JarvisApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'JARVIS',
      debugShowCheckedModeBanner: false,
      // Sleek System-aware Theme
      themeMode: ThemeMode.system, 
      theme: ThemeData(
        brightness: Brightness.light,
        scaffoldBackgroundColor: const Color(0xFFF5F5F7), // Apple-like clean light mode
        primaryColor: Colors.black,
        fontFamily: 'Roboto',
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0A0A0A), // Deep dark
        primaryColor: Colors.white,
        fontFamily: 'Roboto',
      ),
      home: const JarvisMainScreen(),
    );
  }
}
