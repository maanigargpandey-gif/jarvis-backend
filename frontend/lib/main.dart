import 'package:flutter/material.dart';

void main() {
  runApp(const JarvisApp());
}

class JarvisApp extends StatelessWidget {
  const JarvisApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'J.A.R.V.I.S God-Mode',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0F0F0F),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF0F0F0F),
          elevation: 0,
        ),
      ),
      home: const LoginScreen(),
    );
  }
}

// ---------------- LOGIN SCREEN (SECURE GATEWAY) ----------------
class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  void _login() {
    setState(() => _isLoading = true);
    Future.delayed(const Duration(seconds: 1), () {
      if (_usernameController.text == 'mani' && _passwordController.text == 'God mode 123') {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const DashboardScreen()));
      } else {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Access Denied. Incorrect Identity.')));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.security, size: 80, color: Colors.tealAccent),
              const SizedBox(height: 20),
              const Text('J.A.R.V.I.S SECURE LOGIN', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, letterSpacing: 2)),
              const SizedBox(height: 40),
              TextField(
                controller: _usernameController,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(labelText: 'Identity (Username)', prefixIcon: Icon(Icons.person, color: Colors.white)),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _passwordController,
                obscureText: true,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(labelText: 'Passcode (Password)', prefixIcon: Icon(Icons.lock, color: Colors.white)),
              ),
              const SizedBox(height: 40),
              _isLoading 
                  ? const CircularProgressIndicator(color: Colors.tealAccent)
                  : ElevatedButton(
                      onPressed: _login,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0A3D3A),
                        padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30), side: const BorderSide(color: Colors.tealAccent)),
                      ),
                      child: const Text('INITIALIZE SYSTEM', style: TextStyle(color: Colors.tealAccent)),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}

// ---------------- DASHBOARD (THE REAL GOD-MODE UI) ----------------
class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final List<Map<String, String>> _messages = [
    {"role": "jarvis", "text": "Voice/Biometric Secured. Awaiting Command..."}
  ];
  final TextEditingController _chatController = TextEditingController();

  void _sendMessage() {
    if (_chatController.text.trim().isEmpty) return;
    setState(() {
      _messages.add({"role": "user", "text": _chatController.text});
      _messages.add({"role": "jarvis", "text": "Command received. Awaiting backend API to execute: '${_chatController.text}'"});
      _chatController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // --- TOP BAR ---
      appBar: AppBar(
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.shield, color: Colors.redAccent),
            onPressed: () => Scaffold.of(context).openDrawer(), // Drawer Open Button
          ),
        ),
        title: const Text('Connecting...', style: TextStyle(color: Colors.tealAccent, fontSize: 16)),
        actions: [
          IconButton(icon: const Icon(Icons.style, color: Colors.pinkAccent), onPressed: () {}),
          IconButton(icon: const Icon(Icons.list, color: Colors.blueAccent), onPressed: () {}),
          IconButton(icon: const Icon(Icons.auto_awesome, color: Colors.yellowAccent), onPressed: () {}),
        ],
      ),
      
      // --- SIDEBAR (For History & Vault) ---
      drawer: Drawer(
        backgroundColor: const Color(0xFF1A1A1A),
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Color(0xFF0A3D3A)),
              child: Text('J.A.R.V.I.S Menu\nGod-Mode Active', style: TextStyle(color: Colors.tealAccent, fontSize: 20)),
            ),
            ListTile(leading: const Icon(Icons.folder, color: Colors.blue), title: const Text('Nexus Vault'), onTap: () {}),
            ListTile(leading: const Icon(Icons.history, color: Colors.grey), title: const Text('Command History'), onTap: () {}),
          ],
        ),
      ),

      body: Column(
        children: [
          // --- CALL MANAGER & CAMERA WIDGETS ---
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(color: Colors.green.withOpacity(0.2), borderRadius: BorderRadius.circular(5)),
                  child: const Text('Call Manager: ON', style: TextStyle(color: Colors.greenAccent, fontWeight: FontWeight.bold)),
                ),
                Container(
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(color: const Color(0xFF1A1A1A), borderRadius: BorderRadius.circular(10)),
                  child: const Icon(Icons.camera_alt, color: Colors.grey),
                ),
              ],
            ),
          ),

          // --- CHAT HISTORY AREA ---
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(15.0),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final msg = _messages[index];
                final isUser = msg["role"] == "user";
                return Align(
                  alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: isUser ? const Color(0xFF0A3D3A) : const Color(0xFF1A1A1A),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Text(msg["text"]!, style: const TextStyle(color: Colors.white, fontSize: 16)),
                  ),
                );
              },
            ),
          ),

          // --- POWERFUL FEATURE BUTTONS ---
          Container(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton(icon: const Icon(Icons.thumb_up_alt_outlined, color: Colors.grey), onPressed: () {}),
                    IconButton(icon: const Icon(Icons.refresh, color: Colors.grey), onPressed: () {}),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF1A2A3A), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))),
                      icon: const Icon(Icons.download, color: Colors.cyanAccent),
                      label: const Text('Save to Nexus', style: TextStyle(color: Colors.cyanAccent)),
                      onPressed: () {},
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    OutlinedButton(
                      style: OutlinedButton.styleFrom(side: const BorderSide(color: Colors.white), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                      onPressed: () {},
                      child: const Text('Office Forge', style: TextStyle(color: Colors.white)),
                    ),
                    OutlinedButton(
                      style: OutlinedButton.styleFrom(side: const BorderSide(color: Colors.white), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                      onPressed: () {},
                      child: const Text('Video Studio', style: TextStyle(color: Colors.white)),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // --- CHATGPT STYLE INPUT BOX ---
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            decoration: const BoxDecoration(
              color: Color(0xFF1A1A1A),
              border: Border(top: BorderSide(color: Colors.grey, width: 0.2)),
            ),
            child: Row(
              children: [
                IconButton(icon: const Icon(Icons.add, color: Colors.grey), onPressed: () {}), // Attachment
                Expanded(
                  child: TextField(
                    controller: _chatController,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: 'Command J.A.R.V.I.S...',
                      hintStyle: const TextStyle(color: Colors.grey),
                      filled: true,
                      fillColor: const Color(0xFF2A2A2A),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: BorderSide.none),
                    ),
                    onSubmitted: (_) => _sendMessage(),
                  ),
                ),
                IconButton(icon: const Icon(Icons.mic, color: Colors.tealAccent), onPressed: () {}),
                IconButton(icon: const Icon(Icons.send, color: Colors.tealAccent), onPressed: _sendMessage),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
