import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/jarvis_state_provider.dart';
import 'auth_gate.dart';

void main() {
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
      theme: ThemeData.dark(), // डार्क मोड 'God Mode' के लिए बेस्ट है
      home: const AuthGate(),
    );
  }
}
