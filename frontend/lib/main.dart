import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(const JarvisApp());
}

// 1. थीम्स के लिए Enum
enum AppThemeMode { light, dark, hacker }

class JarvisApp extends StatefulWidget {
  const JarvisApp({super.key});

  @override
  State<JarvisApp> createState() => _JarvisAppState();
}

class _JarvisAppState extends State<JarvisApp> {
  AppThemeMode currentTheme = AppThemeMode.dark;

  void switchTheme(AppThemeMode mode) {
    setState(() {
      currentTheme = mode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'JARVIS Base UI',
      debugShowCheckedModeBanner: false,
      theme: _getThemeData(currentTheme),
      home: JarvisMainScreen(
        currentTheme: currentTheme,
        onThemeChanged: switchTheme,
      ),
    );
  }

  ThemeData _getThemeData(AppThemeMode mode) {
    switch (mode) {
      case AppThemeMode.light:
        return ThemeData(
          brightness: Brightness.light,
          scaffoldBackgroundColor: Colors.white,
          primaryColor: Colors.blueAccent,
        );
      case AppThemeMode.dark:
        return ThemeData(
          brightness: Brightness.dark,
          scaffoldBackgroundColor: const Color(0xFF1E1E1E),
          primaryColor: Colors.white,
        );
      case AppThemeMode.hacker:
        return ThemeData(
          brightness: Brightness.dark,
          scaffoldBackgroundColor: const Color(0xFF050505),
          primaryColor: const Color(0xFF00FF41),
          fontFamily: 'RobotoMono',
        );
      default:
        return ThemeData.dark();
    }
  }
}

class JarvisMainScreen extends StatefulWidget {
  final AppThemeMode currentTheme;
  final Function(AppThemeMode) onThemeChanged;

  const JarvisMainScreen({super.key, required this.currentTheme, required this.onThemeChanged});

  @override
  State<JarvisMainScreen> createState() => _JarvisMainScreenState();
}

class _JarvisMainScreenState extends State<JarvisMainScreen> {
  final TextEditingController _textController = TextEditingController();
  final List<Map<String, String>> _messages = [];
  
  // यहाँ अपना असली JARVIS_AUTH_TOKEN डालें
  final String authToken = "mani_jarvis_admin_786"; 

  void _handleSend() async {
    if (_textController.text.trim().isEmpty) return;

    String userMessage = _textController.text;
    setState(() {
      _messages.add({"sender": "user", "text": userMessage});
      _textController.clear();
      _messages.add({"sender": "jarvis", "text": "Analyzing..."});
    });

    try {
      final response = await http.post(
        Uri.parse('https://maanigargpande-jarvis-backend.hf.space/chat'),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $authToken",
        },
        body: jsonEncode({"message": userMessage}),
      );

      setState(() => _messages.removeLast()); // Analyzing... हटा दो

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        setState(() {
          _messages.add({"sender": "jarvis", "text": data['reply']});
        });
      } else {
        setState(() => _messages.add({"sender": "jarvis", "text": "Error: ${response.statusCode}"}));
      }
    } catch (e) {
      setState(() => _messages.add({"sender": "jarvis", "text": "Connection Error!"}));
    }
  }

  void _showAttachmentMenu() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Wrap(
        children: [
          ListTile(leading: Icon(Icons.image), title: Text('Photos')),
          ListTile(leading: Icon(Icons.description), title: Text('Documents')),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    bool isLight = widget.currentTheme == AppThemeMode.light;
    Color accentColor = Theme.of(context).primaryColor;

    return Scaffold(
      appBar: AppBar(title: Text('JARVIS'), centerTitle: true),
      drawer: Drawer(
        child: ListView(
          children: [
            UserAccountsDrawerHeader(accountName: Text('Mani Pandey'), accountEmail: Text('Owner')),
            ListTile(leading: Icon(Icons.light_mode), title: Text('Light Mode'), onTap: () => widget.onThemeChanged(AppThemeMode.light)),
            ListTile(leading: Icon(Icons.dark_mode), title: Text('Dark Mode'), onTap: () => widget.onThemeChanged(AppThemeMode.dark)),
            ListTile(leading: Icon(Icons.terminal), title: Text('Hacker Mode'), onTap: () => widget.onThemeChanged(AppThemeMode.hacker)),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _messages.length,
              itemBuilder: (context, i) => Container(
                alignment: _messages[i]['sender'] == 'user' ? Alignment.centerRight : Alignment.centerLeft,
                child: Text(_messages[i]['text']!),
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.all(10),
            child: Row(
              children: [
                IconButton(icon: Icon(Icons.add), onPressed: _showAttachmentMenu),
                Expanded(child: TextField(controller: _textController, decoration: InputDecoration(hintText: 'Message Jarvis...'))),
                IconButton(icon: Icon(Icons.send), onPressed: _handleSend),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
