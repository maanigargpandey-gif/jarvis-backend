import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Jarvis OS',
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.deepPurple,
        colorScheme: ColorScheme.dark(
          secondary: Colors.greenAccent,
        ),
      ),
      home: LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isValidating = false;
  String? _validationError;

  Future<void> _login() async {
    setState(() {
      _isValidating = true;
      _validationError = null;
    });
    
    // यह तुम्हारे बैकएंड सिक्योरिटी प्रोटोकॉल से कनेक्ट होगा
    final response = await http.post(
      Uri.parse('https://your-login-api.com/login'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'username': _usernameController.text,
        'password': _passwordController.text,
      }),
    );
    
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      if (json['role'] == 'creator') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => CreatorDashboard()),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => GuestDashboard()),
        );
      }
    } else {
      setState(() {
        _isValidating = false;
        _validationError = 'Invalid username or password';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Jarvis OS Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(
                labelText: 'Username / Master ID',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            _isValidating
                ? CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: _login,
                    child: Text('Login to System'),
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                    ),
                  ),
            if (_validationError != null) ...[
              SizedBox(height: 20),
              Text(
                _validationError!,
                style: TextStyle(color: Colors.redAccent, fontSize: 16),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class CreatorDashboard extends StatefulWidget {
  @override
  _CreatorDashboardState createState() => _CreatorDashboardState();
}

class _CreatorDashboardState extends State<CreatorDashboard> {
  int _currentIndex = 0;
  final _tabs = [
    'AI Chat',
    'Media Studio',
    'Document Forge',
    'App Builder',
    'System Settings',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Jarvis OS God-Mode'),
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: [
          AIChatPage(),
          MediaStudioPage(),
          DocumentForgePage(),
          AppBuilderPage(),
          SystemSettingsPage(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        selectedItemColor: Colors.greenAccent,
        unselectedItemColor: Colors.grey,
        items: _tabs
            .map((label) => BottomNavigationBarItem(
                  icon: Icon(Icons.memory),
                  label: label,
                ))
            .toList(),
      ),
    );
  }
}

class GuestDashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Jarvis OS Guest View'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.lock_outline, size: 80, color: Colors.grey),
            SizedBox(height: 20),
            Text('Welcome to Restricted Guest Mode', style: TextStyle(fontSize: 18)),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ChatPage()),
                );
              },
              child: Text('Start Basic Chat'),
            ),
          ],
        ),
      ),
    );
  }
}

// --- Placeholder Pages for Dashboard ---

class AIChatPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Center(child: Text('Jarvis Ultimate AI Chat Active'));
}

class MediaStudioPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Center(child: Text('Media Studio & Generator Active'));
}

class DocumentForgePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Center(child: Text('Document Forge Engine Active'));
}

class AppBuilderPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Center(child: Text('App Factory & Compiler Active'));
}

class SystemSettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Center(child: Text('Core System Settings'));
}

class ChatPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Center(child: Text('Guest Chat Interface'));
}
