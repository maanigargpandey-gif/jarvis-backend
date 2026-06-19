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
        appBarTheme: const AppBarTheme(backgroundColor: Color(0xFF0F0F0F), elevation: 0),
      ),
      home: const LoginScreen(),
    );
  }
}

// ---------------- 1. SECURE GATEWAY (LOGIN) ----------------
class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _userCtrl = TextEditingController();
  final TextEditingController _passCtrl = TextEditingController();
  bool _isLoading = false;

  void _login() {
    setState(() => _isLoading = true);
    Future.delayed(const Duration(seconds: 1), () {
      if (_userCtrl.text == 'mani' && _passCtrl.text == 'God mode 123') {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const DashboardScreen()));
      } else {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Access Denied.')));
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
              TextField(controller: _userCtrl, style: const TextStyle(color: Colors.white), decoration: const InputDecoration(labelText: 'Identity', prefixIcon: Icon(Icons.person, color: Colors.white))),
              const SizedBox(height: 20),
              TextField(controller: _passCtrl, obscureText: true, style: const TextStyle(color: Colors.white), decoration: const InputDecoration(labelText: 'Passcode', prefixIcon: Icon(Icons.lock, color: Colors.white))),
              const SizedBox(height: 40),
              _isLoading 
                  ? const CircularProgressIndicator(color: Colors.tealAccent)
                  : ElevatedButton(
                      onPressed: _login,
                      style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF0A3D3A), padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30))),
                      child: const Text('INITIALIZE SYSTEM', style: TextStyle(color: Colors.tealAccent)),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}

// ---------------- 2. MAIN DASHBOARD ----------------
class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final List<Map<String, String>> _messages = [{"role": "jarvis", "text": "System Online. Memory loaded. Awaiting instructions."}];
  final TextEditingController _chatController = TextEditingController();
  bool isTorchOn = false;

  void _sendMessage() {
    if (_chatController.text.trim().isEmpty) return;
    setState(() {
      _messages.add({"role": "user", "text": _chatController.text});
      _chatController.clear();
    });
  }

  // --- THE CREATOR MFA PROTOCOL ---
  void _triggerCreatorMFA() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A1A),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20), side: const BorderSide(color: Colors.redAccent)),
        title: const Column(
          children: [
            Icon(Icons.mic, color: Colors.redAccent, size: 50),
            SizedBox(height: 10),
            Text('CREATOR AUTHENTICATION', style: TextStyle(color: Colors.redAccent, fontSize: 16, fontWeight: FontWeight.bold)),
          ],
        ),
        content: const Text('Voice matching in progress... (Target: 98%)\n\nFallback: Face/Fingerprint -> PIN', textAlign: TextAlign.center, style: TextStyle(color: Colors.white)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('CANCEL', style: TextStyle(color: Colors.grey))),
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('FORCE OVERRIDE (PIN)', style: TextStyle(color: Colors.tealAccent))),
        ],
      ),
    );
  }

  // --- GIRGIT UI TRIGGER ---
  void _openOfficeForge() {
    Navigator.push(context, MaterialPageRoute(builder: (context) => const GirgitWorkspaceScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Builder(builder: (context) => IconButton(icon: const Icon(Icons.shield, color: Colors.redAccent), onPressed: () => Scaffold.of(context).openDrawer())),
        title: const Text('Connecting...', style: TextStyle(color: Colors.tealAccent, fontSize: 16)),
        actions: [
          IconButton(icon: Icon(isTorchOn ? Icons.highlight : Icons.highlight_outlined, color: isTorchOn ? Colors.yellow : Colors.grey), onPressed: () { setState(() { isTorchOn = !isTorchOn; }); }), // Device Control
          IconButton(icon: const Icon(Icons.admin_panel_settings, color: Colors.redAccent), onPressed: _triggerCreatorMFA), // MFA Trigger
        ],
      ),
      
      drawer: Drawer(
        backgroundColor: const Color(0xFF1A1A1A),
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(decoration: BoxDecoration(color: Color(0xFF0A3D3A)), child: Text('J.A.R.V.I.S Menu\nGod-Mode Active', style: TextStyle(color: Colors.tealAccent, fontSize: 20))),
            ListTile(leading: const Icon(Icons.hub, color: Colors.purpleAccent), title: const Text('Social Integrations'), onTap: () {}),
            ListTile(leading: const Icon(Icons.folder, color: Colors.blue), title: const Text('Nexus Vault'), onTap: () {}),
            ListTile(leading: const Icon(Icons.camera_alt, color: Colors.grey), title: const Text('Vision Settings'), onTap: () {}),
          ],
        ),
      ),

      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
            child: Align(alignment: Alignment.centerLeft, child: Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5), decoration: BoxDecoration(color: Colors.green.withOpacity(0.2), borderRadius: BorderRadius.circular(5)), child: const Text('Call Manager: Standby', style: TextStyle(color: Colors.greenAccent, fontWeight: FontWeight.bold)))),
          ),

          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(15.0),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final isUser = _messages[index]["role"] == "user";
                return Align(
                  alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(color: isUser ? const Color(0xFF0A3D3A) : const Color(0xFF1A1A1A), borderRadius: BorderRadius.circular(15)),
                    child: Text(_messages[index]["text"]!, style: const TextStyle(color: Colors.white, fontSize: 16)),
                  ),
                );
              },
            ),
          ),

          Container(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    OutlinedButton(style: OutlinedButton.styleFrom(side: const BorderSide(color: Colors.white)), onPressed: _openOfficeForge, child: const Text('Office Forge', style: TextStyle(color: Colors.white))),
                    OutlinedButton(style: OutlinedButton.styleFrom(side: const BorderSide(color: Colors.white)), onPressed: () {}, child: const Text('Video Studio', style: TextStyle(color: Colors.white))),
                  ],
                ),
              ],
            ),
          ),

          Container(
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
            color: const Color(0xFF1A1A1A),
            child: Row(
              children: [
                IconButton(icon: const Icon(Icons.add_circle_outline, color: Colors.grey), onPressed: () {}), 
                IconButton(icon: const Icon(Icons.camera_alt_outlined, color: Colors.grey), onPressed: () {}), 
                Expanded(
                  child: TextField(
                    controller: _chatController,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(hintText: 'Command J.A.R.V.I.S...', hintStyle: const TextStyle(color: Colors.grey), filled: true, fillColor: const Color(0xFF2A2A2A), border: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: BorderSide.none)),
                    onSubmitted: (_) => _sendMessage(),
                  ),
                ),
                IconButton(icon: const Icon(Icons.mic_none, color: Colors.tealAccent), onPressed: () {}),
                IconButton(icon: const Icon(Icons.send, color: Colors.tealAccent), onPressed: _sendMessage),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------- 3. GIRGIT UI (CHAMELEON WORKSPACE) ----------------
class GirgitWorkspaceScreen extends StatelessWidget {
  const GirgitWorkspaceScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E1E1E),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2D2D30),
        title: const Text('Office Forge (Excel Mode)', style: TextStyle(color: Colors.greenAccent, fontSize: 16)),
        actions: [IconButton(icon: const Icon(Icons.save, color: Colors.white), onPressed: () {})],
      ),
      body: Column(
        children: [
          // Toolbars (40% representation)
          Container(
            padding: const EdgeInsets.all(8),
            color: const Color(0xFF333337),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: const [
                Icon(Icons.format_bold, color: Colors.white),
                Icon(Icons.format_italic, color: Colors.white),
                Icon(Icons.functions, color: Colors.greenAccent),
                Icon(Icons.pie_chart, color: Colors.white),
                Icon(Icons.auto_awesome, color: Colors.yellow), // AI Auto-Format
              ],
            ),
          ),
          // Workspace (60% area)
          Expanded(
            child: Container(
              margin: const EdgeInsets.all(10),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(5)),
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4),
                itemCount: 40,
                itemBuilder: (context, index) {
                  return Container(
                    decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade300)),
                    child: Center(child: Text(index == 0 ? 'A1' : '', style: const TextStyle(color: Colors.black))),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
