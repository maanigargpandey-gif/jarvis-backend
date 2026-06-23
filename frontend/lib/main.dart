import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'providers/jarvis_state_provider.dart';
import 'gateways/auth_gate.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox('jarvis_data');
  
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
      title: 'Jarvis OS',
      theme: ThemeData.dark(),
      home: const AuthGate(), // सीधा AuthGate पर ले जाएगा
    );
  }
}
