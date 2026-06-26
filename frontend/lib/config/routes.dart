import 'package:flutter/material.dart';
import '../screens/splash_screen.dart';
import '../screens/main_screen.dart';
import '../screens/auth/login_screen.dart';
import '../screens/auth/mfa_screen.dart';
import '../screens/admin_dashboard.dart';
import '../screens/social_manager_screen.dart';
import '../screens/vault_screen.dart';

class AppRoutes {
  static const String splash = '/';
  static const String login = '/login';
  static const String mfa = '/mfa';
  static const String main = '/main';
  static const String admin = '/admin';
  static const String social = '/social';
  static const String vault = '/vault';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splash:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case mfa:
        return MaterialPageRoute(builder: (_) => const MFAScreen());
      case main:
        return MaterialPageRoute(builder: (_) => const MainScreen());
      case admin:
        return MaterialPageRoute(builder: (_) => const AdminDashboard());
      case social:
        return MaterialPageRoute(builder: (_) => const SocialManagerScreen());
      case vault:
        return MaterialPageRoute(builder: (_) => const VaultScreen());
      default:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
    }
  }
}

