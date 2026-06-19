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
        scaffoldBackgroundColor: Color(0xFF121212),
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
    
    // CREATOR GATEWAY (God-Mode Lock)
    if (_usernameController.text == 'Mani' && _passwordController.text == 'GodMode123') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => CreatorDashboard()),
      );
      return;
    }

    // GUEST USER CHECK 
    try {
      final response = await http.post(
        Uri.parse('https://jarvis-backend-afg0.onrender.com/ultimate-jarvis'),
        headers: {'Content-Type': 'application/json'},
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
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => GuestDashboard()));
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
              Text(_validationError!, style: TextStyle(color: Colors.redAccent, fontSize: 16)),
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
  final _tabs = ['AI Chat', 'Media Studio', 'Doc Forge', 'App Builder', 'Settings'];

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
          AIChatPage(), // <--- Jarvis's New Upgraded Page
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
        items: _tabs.map((label) => BottomNavigationBarItem(icon: Icon(Icons.memory), label: label)).toList(),
      ),
    );
  }
}

class GuestDashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Jarvis OS Guest View'), backgroundColor: Colors.grey[900]),
      body: Center(child: Text('Welcome to Restricted Guest Mode', style: TextStyle(color: Colors.redAccent))),
    );
  }
}

// --- JARVIS UPGRADED CHAT UI ---
class AIChatPage extends StatefulWidget {
  @override
  _AIChatPageState createState() => _AIChatPageState();
}

class _AIChatPageState extends State<AIChatPage> {
  final _messages = <String>[];
  final _controller = TextEditingController();

  void _sendMessage() {
    if (_controller.text.trim().isEmpty) return;
    setState(() {
      _messages.add(_controller.text);
      _controller.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            padding: EdgeInsets.all(15),
            itemCount: _messages.length,
            itemBuilder: (context, index) {
              return Align(
                alignment: Alignment.centerRight,
                child: Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: Colors.deepPurple[800],
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(15),
                      topRight: Radius.circular(15),
                      bottomLeft: Radius.circular(15),
                    ),
                    border: Border.all(color: Colors.greenAccent, width: 0.5),
                  ),
                  child: Text(
                    _messages[index],
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              );
            },
          ),
        ),
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.black,
            border: Border(top: BorderSide(color: Colors.deepPurple)),
          ),
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.attach_file, color: Colors.greenAccent),
                onPressed: () {
                  // File Upload Option
                },
              ),
              Expanded(
                child: TextField(
                  controller: _controller,
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'Message Jarvis...',
                    hintStyle: TextStyle(color: Colors.grey),
                    filled: true,
                    fillColor: Colors.grey[900],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  ),
                ),
              ),
              SizedBox(width: 8),
              Container(
                decoration: BoxDecoration(
                  color: Colors.greenAccent,
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: const Icon(Icons.send, color: Colors.black),
                  onPressed: _sendMessage,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// --- Placeholder Pages ---
class MediaStudioPage extends StatelessWidget { @override Widget build(BuildContext context) => Center(child: Text('Media Studio & Generator Active', style: TextStyle(color: Colors.greenAccent, fontSize: 20))); }
class DocumentForgePage extends StatelessWidget { @override Widget build(BuildContext context) => Center(child: Text('Document Forge Engine Active', style: TextStyle(color: Colors.greenAccent, fontSize: 20))); }
class AppBuilderPage extends StatelessWidget { @override Widget build(BuildContext context) => Center(child: Text('App Factory & Compiler Active', style: TextStyle(color: Colors.greenAccent, fontSize: 20))); }
class SystemSettingsPage extends StatelessWidget { @override Widget build(BuildContext context) => Center(child: Text('Core System Settings', style: TextStyle(color: Colors.greenAccent, fontSize: 20))); }
