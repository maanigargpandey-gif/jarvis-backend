import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/theme_provider.dart';
import 'providers/ai_state_provider.dart';
import 'providers/voice_provider.dart';
import 'screens/home_screen.dart';
import 'screens/omni_workspace_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ZarvishOS());
}

class ZarvishOS extends StatelessWidget {
  const ZarvishOS({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => AIStateProvider()),
        ChangeNotifierProvider(create: (_) => VoiceProvider()),
      ],
      child: const ZarvishMaterialApp(),
    );
  }
}

class ZarvishMaterialApp extends StatelessWidget {
  const ZarvishMaterialApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    
    return MaterialApp(
      title: 'Zarvish OS',
      debugShowCheckedModeBanner: false,
      theme: ThemeProvider.lightTheme,
      darkTheme: ThemeProvider.darkTheme,
      themeMode: themeProvider.themeMode,
      home: const HomeScreen(),
      routes: {
        '/omni-workspace': (context) => const OmniWorkspaceScreen(),
      },
    );
  }
}
