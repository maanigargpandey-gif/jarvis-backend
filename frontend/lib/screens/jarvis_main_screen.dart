import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class JarvisMainScreen extends StatefulWidget {
  const JarvisMainScreen({super.key});

  @override
  State<JarvisMainScreen> createState() => _JarvisMainScreenState();
}

class _JarvisMainScreenState extends State<JarvisMainScreen> with SingleTickerProviderStateMixin {
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  late AnimationController _bgController;
  
  // Chat History Setup (Mocking data with different file types for UI testing)
  final List<Map<String, dynamic>> _messages = [
    {"sender": "jarvis", "type": "text", "text": "System Online. Welcome back, Creator. How can I assist you today?"},
    {"sender": "user", "type": "text", "text": "Jarvis, mujhe aaj ke business data ki sheet dikhao aur ek project doc taiyar karo."},
    {"sender": "jarvis", "type": "excel", "text": "Maine aapka business report data compile kar diya hai. Excel sheet niche attached hai, aap tap karke ise edit kar sakte hain.", "fileName": "Daily_Business_Report.xlsx", "fileSize": "48 KB"},
    {"sender": "jarvis", "type": "doc", "text": "Aur ye raha aapka project requirement document. Ise badalne ke liye tap karein.", "fileName": "Project_Blueprint.docx", "fileSize": "120 KB"},
    {"sender": "jarvis", "type": "pdf", "text": "Aapke reference ke liye RTO rules ki guide list bhi PDF me ready hai.", "fileName": "RTO_Challan_Guidelines.pdf", "fileSize": "2.1 MB"}
  ];

  bool _isLoading = false;
  String _currentRole = "Creator";

  // 🦎 Girgital UI State Colors (Changes dynamically based on active file type)
  Color _currentAccentColor = Colors.cyanAccent;
  Color _currentBgBlendColor = const Color(0xFF1E3A8A);

  @override
  void initState() {
    super.initState();
    _loadUserRole();
    _bgController = AnimationController(vsync: this, duration: const Duration(seconds: 4))..repeat(reverse: true);
  }

  @override
  void dispose() {
    _bgController.dispose();
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadUserRole() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _currentRole = prefs.getString('jarvis_role') ?? "Creator";
    });
  }

  // 🦎 Theme Changer Logic based on file interactions
  void _updateThemeForFileType(String type) {
    setState(() {
      if (type == 'excel') {
        _currentAccentColor = Colors.greenAccent;
        _currentBgBlendColor = const Color(0xFF064E3B); // Deep Green for Excel
      } else if (type == 'doc') {
        _currentAccentColor = Colors.blueAccent;
        _currentBgBlendColor = const Color(0xFF1E3A8A); // Deep Blue for Word
      } else if (type == 'pdf') {
        _currentAccentColor = Colors.redAccent;
        _currentBgBlendColor = const Color(0xFF7F1D1D); // Deep Red for PDF
      } else if (type == 'ppt') {
        _currentAccentColor = Colors.orangeAccent;
        _currentBgBlendColor = const Color(0xFF7C2D12); // Deep Orange for PPT
      } else {
        _currentAccentColor = Colors.cyanAccent;
        _currentBgBlendColor = const Color(0xFF4C1D95); // Default Cyber Purple/Blue
      }
    });
  }

  void _sendMessage() {
    String text = _textController.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _messages.add({"sender": "user", "type": "text", "text": text});
      _textController.clear();
    });
    
    // Default theme shift on general text send
    _updateThemeForFileType("text");

    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(_scrollController.position.maxScrollExtent, duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
      }
    });
  }

  void _showAttachmentMenu() {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF141414),
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(16.0),
        child: Wrap(
          children: [
            const Padding(
              padding: EdgeInsets.only(bottom: 15, left: 10),
              child: Text("QUICK PROTOCOLS", style: TextStyle(color: Colors.grey, fontSize: 12, fontWeight: FontWeight.bold, fontFamily: 'Courier')),
            ),
            ListTile(
              leading: const Icon(Icons.camera, color: Colors.cyanAccent), 
              title: const Text('Media Studio (8K/4K)'),
              subtitle: const Text('Cinematic Engine & Facial Lock', style: TextStyle(fontSize: 11, color: Colors.white54)),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Icon(Icons.document_scanner, color: Colors.orangeAccent), 
              title: const Text('Document Forge & CSC'),
              subtitle: const Text('Automated Portal Form Filling', style: TextStyle(fontSize: 11, color: Colors.white54)),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Icon(Icons.language, color: Colors.blueAccent), 
              title: const Text('Secure Web Browser'),
              subtitle: const Text('Isolated Sandbox Environment', style: TextStyle(fontSize: 11, color: Colors.white54)),
              onTap: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text('JARVIS CORE', style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 2, color: _currentAccentColor, fontFamily: 'Courier')),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: _currentAccentColor),
      ),
      drawer: _buildSidebar(),
      body: Stack(
        children: [
          // 🦎 Dynamic Breathing Gradient
          AnimatedBuilder(
            animation: _bgController,
            builder: (context, child) {
              return Container(
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    center: const Alignment(0, -0.2),
                    radius: 1.4 + (_bgController.value * 0.15),
                    colors: [
                      _currentBgBlendColor.withOpacity(0.4 + (_bgController.value * 0.15)),
                      const Color(0xFF0A0A0A),
                    ],
                    stops: const [0.0, 1.0],
                  ),
                ),
              );
            },
          ),
          SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(16),
                    itemCount: _messages.length,
                    itemBuilder: (context, i) {
                      bool isUser = _messages[i]['sender'] == 'user';
                      String msgType = _messages[i]['type'];
                      
                      return Container(
                        margin: const EdgeInsets.only(bottom: 20),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
                          children: [
                            if (!isUser) CircleAvatar(backgroundColor: Colors.white12, child: Icon(Icons.blur_on, color: _currentAccentColor, size: 20)),
                            if (!isUser) const SizedBox(width: 10),
                            Flexible(
                              child: Column(
                                crossAxisAlignment: isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                                children: [
                                  // Text Message Container
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                                    decoration: BoxDecoration(
                                      color: isUser ? _currentAccentColor.withOpacity(0.15) : Colors.black65,
                                      border: Border.all(color: isUser ? _currentAccentColor.withOpacity(0.4) : Colors.white10),
                                      borderRadius: BorderRadius.circular(16).copyWith(
                                        bottomRight: isUser ? const Radius.circular(0) : const Radius.circular(16),
                                        topLeft: !isUser ? const Radius.circular(0) : const Radius.circular(16),
                                      ),
                                    ),
                                    child: Text(_messages[i]['text']!, style: const TextStyle(fontSize: 15, color: Colors.white, height: 1.4)),
                                  ),
                                  
                                  // Smart File Card Rendering (If message contains file)
                                  if (msgType != 'text') ...[
                                    const SizedBox(height: 8),
                                    _buildSmartFileCard(_messages[i]['fileName'], _messages[i]['fileSize'], msgType),
                                  ]
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                _buildInputArea(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 📂 Smart File Card UI Builder (TAP TO EDIT)
  Widget _buildSmartFileCard(String fileName, String fileSize, String type) {
    IconData fileIcon = Icons.insert_drive_file;
    Color cardColor = Colors.cyanAccent;
    
    if (type == 'excel') { fileIcon = Icons.table_chart; cardColor = Colors.greenAccent; }
    if (type == 'doc') { fileIcon = Icons.description; cardColor = Colors.blueAccent; }
    if (type == 'pdf') { fileIcon = Icons.picture_as_pdf; cardColor = Colors.redAccent; }

    return GestureDetector(
      onTap: () {
        _updateThemeForFileType(type);
        // Step 3 ke Editor screen par file dynamic properties ke sath redirect karega
        Navigator.pushNamed(context, '/editor', arguments: {'fileName': fileName, 'fileType': type});
      },
      child: Container(
        width: 260,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.black85,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: cardColor.withOpacity(0.6), width: 1.5),
          boxShadow: [BoxShadow(color: cardColor.withOpacity(0.1), blurRadius: 8, spreadRadius: 1)],
        ),
        child: Row(
          children: [
            Icon(fileIcon, color: cardColor, size: 36),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(fileName, style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold, overflow: TextOverflow.ellipsis)),
                  const SizedBox(height: 4),
                  Text(fileSize, style: TextStyle(color: Colors.grey.shade400, fontSize: 11)),
                  const SizedBox(height: 4),
                  Text("Tap to View & Edit", style: TextStyle(color: cardColor, fontSize: 11, fontWeight: FontWeight.w600, fontFamily: 'Courier')),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ⌨️ Input Box with Text & Voice (Mic Button Included)
  Widget _buildInputArea() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: const BoxDecoration(
        color: Color(0xFF0D0D0D),
        border: Border(top: BorderSide(color: Colors.white10, width: 0.5))
      ),
      child: Row(
        children: [
          IconButton(icon: Icon(Icons.add_circle_outline, color: _currentAccentColor, size: 28), onPressed: _showAttachmentMenu),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(color: Colors.white.withOpacity(0.05), borderRadius: BorderRadius.circular(24)),
              child: TextField(
                controller: _textController,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(hintText: 'Execute Jarvis protocol...', hintStyle: TextStyle(color: Colors.white38, fontSize: 14), border: InputBorder.none),
                onSubmitted: (_) => _sendMessage(),
              ),
            ),
          ),
          const SizedBox(width: 6),
          // 🎙️ Voice Input Button
          IconButton(
            icon: Icon(Icons.mic, color: _currentAccentColor, size: 26),
            onPressed: () {
              // Future Voice Logic Integration Point
            },
          ),
          const SizedBox(width: 6),
          CircleAvatar(
            backgroundColor: _currentAccentColor,
            radius: 20,
            child: IconButton(icon: const Icon(Icons.send, color: Colors.black, size: 18), onPressed: _sendMessage),
          ),
        ],
      ),
    );
  }

  Widget _buildSidebar() {
    return Drawer(
      backgroundColor: const Color(0xFF0A0A0A),
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(color: Color(0xFF111111)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Icon(Icons.blur_on, size: 42, color: _currentAccentColor),
                const SizedBox(height: 12),
                Text('Clearance: $_currentRole', style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold, fontFamily: 'Courier')),
                const Text('Region: Gorakhpur Nexus Hub', style: TextStyle(color: Colors.white38, fontSize: 11)),
              ],
            ),
          ),
          ListTile(leading: const Icon(Icons.camera_enhance, color: Colors.cyanAccent), title: const Text('Media Studio', style: TextStyle(color: Colors.white)), onTap: () => Navigator.pop(context)),
          ListTile(leading: const Icon(Icons.edit_document, color: Colors.orangeAccent), title: const Text('Document Forge & CSC', style: TextStyle(color: Colors.white)), onTap: () => Navigator.pop(context)),
          ListTile(leading: const Icon(Icons.language, color: Colors.blueAccent), title: const Text('Web Browser', style: TextStyle(color: Colors.white)), onTap: () => Navigator.pop(context)),
          const Divider(color: Colors.white12),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.redAccent),
            title: const Text('Disconnect System', style: TextStyle(color: Colors.redAccent)),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
        ],
      ),
    );
  }
}

