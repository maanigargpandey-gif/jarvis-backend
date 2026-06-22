import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'providers/jarvis_state_provider.dart';
import 'auth_gate.dart';

void main() async {
  // Hive और Flutter दोनों को इनिशियलाइज करो
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox('jarvis_data'); // यहाँ हमारा सारा डेटा सेव रहेगा

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
      theme: ThemeData.dark(),
      home: const AuthGate(),
    );
  }
}
