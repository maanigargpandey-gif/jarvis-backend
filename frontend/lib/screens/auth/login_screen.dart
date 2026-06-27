import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/theme_provider.dart';
import '../../config/routes.dart';
import '../../config/constants.dart';
import '../../widgets/glassmorphism_container.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _pinController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _pinController.dispose();
    super.dispose();
  }

  Future<void> _loginAsGuest() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    await authProvider.loginAsGuest();
    if (mounted) {
      Navigator.pushReplacementNamed(context, AppRoutes.main);
    }
  }

  Future<void> _loginAsCreator() async {
    setState(() => _isLoading = true);
    
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final result = await authProvider.loginWithGoogle(
      _emailController.text.trim(),
      _pinController.text.trim(),
    );
    
    setState(() => _isLoading = false);
    
    if (result['status'] == 'mfa_required') {
      if (mounted) {
        Navigator.pushReplacementNamed(context, AppRoutes.mfa);
      }
    } else if (result['status'] == 'pending_pin') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter your Master PIN')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result['message'] ?? 'Login failed')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.themeMode == ThemeMode.dark;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0A0E21) : const Color(0xFFF5F5F7),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 60),
              // Logo
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: isDark
                        ? [const Color(0xFF7C4DFF), const Color(0xFF00E5FF)]
                        : [const Color(0xFF6C63FF), const Color(0xFF00BFA6)],
                  ),
                ),
                child: const Icon(Icons.blur_on, size: 50, color: Colors.white),
              ),
              const SizedBox(height: 30),
              Text(
                'ZARVISH',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 3,
                  color: isDark ? Colors.white : const Color(0xFF2D3142),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Sign in to access your AI assistant',
                style: TextStyle(
                  color: isDark ? Colors.white54 : Colors.black54,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 50),
              
              // Guest Mode Button
              GlassmorphismWidget(
                child: ListTile(
                  leading: const Icon(Icons.person_outline, color: Colors.cyanAccent),
                  title: const Text(
                    'Continue as Guest',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  subtitle: const Text(
                    'Restricted access, no login required',
                    style: TextStyle(color: Colors.white54, fontSize: 12),
                  ),
                  trailing: const Icon(Icons.arrow_forward_ios, color: Colors.white54, size: 16),
                  onTap: _loginAsGuest,
                ),
              ),
              const SizedBox(height: 20),
              
              // Divider
              Row(
                children: [
                  Expanded(child: Divider(color: Colors.white24)),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      'OR',
                      style: TextStyle(color: Colors.white38, fontSize: 14),
                    ),
                  ),
                  Expanded(child: Divider(color: Colors.white24)),
                ],
              ),
              const SizedBox(height: 20),
              
              // Google Login
              GlassmorphismWidget(
                child: ListTile(
                  leading: const Icon(Icons.mail_outline, color: Colors.redAccent),
                  title: const Text(
                    'Continue with Google',
                    style: TextStyle(color: Colors.white),
                  ),
                  trailing: const Icon(Icons.arrow_forward_ios, color: Colors.white54, size: 16),
                  onTap: () => _showCreatorLoginDialog(),
                ),
              ),
              const SizedBox(height: 20),
              
              // Admin Login
              GlassmorphismWidget(
                child: ListTile(
                  leading: const Icon(Icons.admin_panel_settings, color: Colors.amberAccent),
                  title: const Text(
                    'Admin Login',
                    style: TextStyle(color: Colors.white),
                  ),
                  subtitle: const Text(
                    'For Mani Pandey only',
                    style: TextStyle(color: Colors.white54, fontSize: 12),
                  ),
                  trailing: const Icon(Icons.arrow_forward_ios, color: Colors.white54, size: 16),
                  onTap: () => _showCreatorLoginDialog(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showCreatorLoginDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A2E),
        title: const Text('Creator Login', style: TextStyle(color: Colors.white)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _emailController,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                hintText: 'Email',
                hintStyle: TextStyle(color: Colors.white38),
                prefixIcon: Icon(Icons.email, color: Colors.cyanAccent),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white24),
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _pinController,
              obscureText: true,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                hintText: 'Master PIN',
                hintStyle: TextStyle(color: Colors.white38),
                prefixIcon: Icon(Icons.lock, color: Colors.cyanAccent),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white24),
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: _isLoading ? null : () {
              Navigator.pop(context);
              _loginAsCreator();
            },
            child: _isLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text('Login'),
          ),
        ],
      ),
    );
  }
}
