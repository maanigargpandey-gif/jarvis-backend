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
    
    // 1. THE CREATOR GATEWAY (God-Mode Lock)
    // तुम यहाँ अपना नाम और पासवर्ड बदल सकते हो
    if (_usernameController.text == 'Mani' && _passwordController.text == 'GodMode123') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => CreatorDashboard()),
      );
      return;
    }

    // 2. GUEST/STANDARD USER CHECK (Connects to your Render Backend)
    try {
      final response = await http.post(
        Uri.parse('https://jarvis-backend-afg0.onrender.com/ultimate-jarvis'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'action': 'login',
          'role': 'guest',
          'details': {
            'username': _usernameController.text,
            'password': _passwordController.text,
          }
        }),
      );
      
      if (response.statusCode == 200) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => GuestDashboard()),
        );
      } else {
        setState(() {
          _isValidating = false;
          _validationError = 'Access Denied. You are not the Creator.';
        });
      }
    } catch (e) {
      setState(() {
        _isValidating = false;
        _validationError = 'Server Connection Failed';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Jarvis OS Login', style: TextStyle(fontFamily: 'Courier')),
        backgroundColor: Colors.black,
      ),
      backgroundColor: Color(0xFF121212),
      body: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.shield, size: 60, color: Colors.deepPurpleAccent),
            SizedBox(height: 30),
            TextField(
              controller: _usernameController,
              style: TextStyle(color: Colors.greenAccent),
              decoration: InputDecoration(
                labelText: 'Username / Master ID',
                labelStyle: TextStyle(color: Colors.grey),
                enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.deepPurple)),
                focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.greenAccent)),
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _passwordController,
              obscureText: true,
              style: TextStyle(color: Colors.greenAccent),
              decoration: InputDecoration(
                labelText: 'Password',
                labelStyle: TextStyle(color: Colors.grey),
                enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.deepPurple)),
                focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.greenAccent)),
              ),
            ),
            SizedBox(height: 30),
            _isValidating
                ? CircularProgressIndicator(color: Colors.greenAccent)
                : ElevatedButton(
                    onPressed: _login,
                    child: Text('Login to System', style: TextStyle(fontSize: 16)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple[800],
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
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
    'Doc Forge',
    'App Builder',
    'Settings',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Jarvis OS God-Mode'),
        backgroundColor: Colors.deepPurple[900],
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
        backgroundColor: Colors.black,
        type: BottomNavigationBarType.fixed,
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
        backgroundColor: Colors.grey[900],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.lock_outline, size: 80, color: Colors.grey),
            SizedBox(height: 20),
            Text('Welcome to Restricted Guest Mode', style: TextStyle(fontSize: 18, color: Colors.redAccent)),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {},
              child: Text('Start Basic Chat'),
            ),
          ],
        ),
      ),
    );
  }
}

// --- Placeholder Pages ---
class AIChatPage extends StatelessWidget { @override Widget build(BuildContext context) => Center(child: Text('Jarvis Ultimate AI Chat Active', style: TextStyle(color: Colors.greenAccent, fontSize: 20))); }
class MediaStudioPage extends StatelessWidget { @override Widget build(BuildContext context) => Center(child: Text('Media Studio & Generator Active', style: TextStyle(color: Colors.greenAccent, fontSize: 20))); }
class DocumentForgePage extends StatelessWidget { @override Widget build(BuildContext context) => Center(child: Text('Document Forge Engine Active', style: TextStyle(color: Colors.greenAccent, fontSize: 20))); }
class AppBuilderPage extends StatelessWidget { @override Widget build(BuildContext context) => Center(child: Text('App Factory & Compiler Active', style: TextStyle(color: Colors.greenAccent, fontSize: 20))); }
class SystemSettingsPage extends StatelessWidget { @override Widget build(BuildContext context) => Center(child: Text('Core System Settings', style: TextStyle(color: Colors.greenAccent, fontSize: 20))); }
