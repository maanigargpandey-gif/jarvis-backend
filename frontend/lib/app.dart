import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/auth_provider.dart';
import 'providers/theme_provider.dart';
import 'config/theme.dart';
import 'config/routes.dart';
import 'screens/splash_screen.dart';

class ZarvishApp extends StatelessWidget {
  const ZarvishApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    
    return MaterialApp(
      title: 'Zarvish OS',
      debugShowCheckedModeBanner: false,
      themeMode: themeProvider.themeMode,
      theme: ZarvishTheme.lightTheme,
      darkTheme: ZarvishTheme.darkTheme,
      home: const SplashScreen(),
      onGenerateRoute: AppRoutes.generateRoute,
    );
  }
}
