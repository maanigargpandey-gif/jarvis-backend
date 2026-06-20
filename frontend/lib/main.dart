import 'package:flutter/material.dart';

void main() {
  runApp(const JarvisApp());
}

// 1. थीम मैनेजमेंट के लिए Enum
enum AppThemeMode { light, dark, hacker }

class JarvisApp extends StatefulWidget {
  const JarvisApp({super.key});

  @override
  State<JarvisApp> createState() => _JarvisAppState();
}

class _JarvisAppState extends State<JarvisApp> {
  // डिफ़ॉल्ट थीम 'Dark' रखी है, तुम चाहो तो बदल सकते हो
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

  // 2. तीनों थीम्स का एकदम सटीक डिज़ाइन
  ThemeData _getThemeData(AppThemeMode mode) {
    switch (mode) {
      case AppThemeMode.light:
        return ThemeData(
          brightness: Brightness.light,
          scaffoldBackgroundColor: Colors.white,
          primaryColor: Colors.blueAccent,
          appBarTheme: const AppBarTheme(backgroundColor: Colors.white, foregroundColor: Colors.black, elevation: 0),
        );
      case AppThemeMode.dark:
        return ThemeData(
          brightness: Brightness.dark,
          scaffoldBackgroundColor: const Color(0xFF1E1E1E), // Standard ChatGPT Dark
          primaryColor: Colors.white,
          appBarTheme: const AppBarTheme(backgroundColor: Color(0xFF1E1E1E), elevation: 0),
        );
      case AppThemeMode.hacker:
        return ThemeData(
          brightness: Brightness.dark,
          scaffoldBackgroundColor: const Color(0xFF050505), // Deep Black
          primaryColor: const Color(0xFF00FF41), // Neon Green
          fontFamily: 'RobotoMono',
          appBarTheme: const AppBarTheme(backgroundColor: Color(0xFF050505), foregroundColor: Color(0xFF00FF41), elevation: 0),
        );
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
  final List<Map<String, String>> _messages = []; // चैट हिस्ट्री

  // सेंड बटन लॉजिक
  void _handleSend() {
    if (_textController.text.trim().isEmpty) return;
    setState(() {
      _messages.add({"sender": "user", "text": _textController.text});
      _messages.add({"sender": "jarvis", "text": "Understood. Analyzing your request..."});
      _textController.clear();
    });
  }

  // फाइल अपलोड / अटैचमेंट मेन्यू (यूनिवर्सल फाइल एक्सेप्टर बेस)
  void _showAttachmentMenu() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: Icon(Icons.image, color: Theme.of(context).primaryColor),
              title: const Text('Photos & Videos'),
              onTap: () { Navigator.pop(context); /* Add File Picker Logic here */ },
            ),
            ListTile(
              leading: Icon(Icons.description, color: Theme.of(context).primaryColor),
              title: const Text('Documents (PDF, Word, Excel)'),
              onTap: () { Navigator.pop(context); },
            ),
            ListTile(
              leading: Icon(Icons.camera_alt, color: Theme.of(context).primaryColor),
              title: const Text('Live Camera Scan'),
              onTap: () { Navigator.pop(context); },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Color accentColor = Theme.of(context).primaryColor;
    bool isLight = widget.currentTheme == AppThemeMode.light;

    return Scaffold(
      // === टॉप ऐप बार ===
      appBar: AppBar(
        title: Text(
          'JARVIS',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: isLight ? Colors.black : accentColor),
        ),
        centerTitle: true,
        actions: [
          IconButton(icon: const Icon(Icons.more_vert), onPressed: () {}),
        ],
      ),

      // === प्रोफाइल और सेटिंग्स मेन्यू ===
      drawer: Drawer(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              decoration: BoxDecoration(color: isLight ? Colors.blue.withOpacity(0.1) : Colors.black26),
              accountName: Text('Mani Pandey', style: TextStyle(color: isLight ? Colors.black : Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
              accountEmail: Text('Owner / Creator', style: TextStyle(color: accentColor)),
              currentAccountPicture: const CircleAvatar(
                backgroundColor: Colors.grey,
                backgroundImage: NetworkImage('https://via.placeholder.com/150'), // यहाँ ओनर की असली फोटो लगेगी
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(left: 15, top: 10, bottom: 5),
              child: Text("APPEARANCE", style: TextStyle(color: Colors.grey, fontSize: 12)),
            ),
            ListTile(
              leading: const Icon(Icons.light_mode),
              title: const Text('Light Mode'),
              onTap: () { widget.onThemeChanged(AppThemeMode.light); Navigator.pop(context); },
            ),
            ListTile(
              leading: const Icon(Icons.dark_mode),
              title: const Text('Dark Mode'),
              onTap: () { widget.onThemeChanged(AppThemeMode.dark); Navigator.pop(context); },
            ),
            ListTile(
              leading: const Icon(Icons.terminal),
              title: const Text('Hacker Mode'),
              onTap: () { widget.onThemeChanged(AppThemeMode.hacker); Navigator.pop(context); },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Jarvis Settings'),
              onTap: () {},
            ),
          ],
        ),
      ),

      body: Column(
        children: [
          // === चैट एरिया / वेलकम स्क्रीन ===
          Expanded(
            child: _messages.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.auto_awesome, size: 60, color: accentColor),
                        const SizedBox(height: 20),
                        Text(
                          'Hello, Mani.',
                          style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: isLight ? Colors.black : Colors.white),
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          'How can I help you today?',
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(15),
                    itemCount: _messages.length,
                    itemBuilder: (context, index) {
                      bool isUser = _messages[index]["sender"] == "user";
                      return Container(
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                          decoration: BoxDecoration(
                            color: isUser 
                                ? (isLight ? Colors.blue.shade100 : Colors.grey.shade800)
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Text(
                            _messages[index]["text"]!,
                            style: TextStyle(fontSize: 16, color: isLight ? Colors.black : Colors.white),
                          ),
                        ),
                      );
                    },
                  ),
          ),

          // === इनपुट एरिया (Gemini/ChatGPT स्टाइल बेस) ===
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            decoration: BoxDecoration(
              color: isLight ? Colors.white : Theme.of(context).scaffoldBackgroundColor,
              border: Border(top: BorderSide(color: Colors.grey.withOpacity(0.2))),
            ),
            child: SafeArea(
              child: Row(
                children: [
                  // अटैचमेंट बटन
                  IconButton(
                    icon: Icon(Icons.add_circle, color: accentColor, size: 28),
                    onPressed: _showAttachmentMenu,
                  ),
                  
                  // टेक्स्ट फील्ड
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      decoration: BoxDecoration(
                        color: isLight ? Colors.grey.shade100 : Colors.grey.shade900,
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: TextField(
                        controller: _textController,
                        textInputAction: TextInputAction.send,
                        onSubmitted: (_) => _handleSend(),
                        style: TextStyle(color: isLight ? Colors.black : Colors.white),
                        decoration: const InputDecoration(
                          hintText: 'Message Jarvis...',
                          hintStyle: TextStyle(color: Colors.grey),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                  
                  const SizedBox(width: 5),

                  // माइक बटन
                  IconButton(
                    icon: const Icon(Icons.mic, color: Colors.grey, size: 28),
                    onPressed: () { /* Mic logic */ },
                  ),

                  // सेंड बटन
                  IconButton(
                    icon: Icon(Icons.send, color: accentColor, size: 28),
                    onPressed: _handleSend,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
