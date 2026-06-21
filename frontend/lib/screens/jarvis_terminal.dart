import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/agent_orchestrator.dart';

class JarvisTerminalScreen extends StatefulWidget {
  @override
  _JarvisTerminalScreenState createState() => _JarvisTerminalScreenState();
}

class _JarvisTerminalScreenState extends State<JarvisTerminalScreen> {
  final TextEditingController _commandController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  void _sendCommand() {
    if (_commandController.text.trim().isEmpty) return;
    
    final orchestrator = Provider.of<AgentOrchestrator>(context, listen: false);
    orchestrator.processCommand(_commandController.text.trim());
    _commandController.clear();
    
    Future.delayed(Duration(milliseconds: 100), () {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final orchestrator = Provider.of<AgentOrchestrator>(context);

    return Scaffold(
      backgroundColor: Colors.black, // Sleek Dark Terminal Mode
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          'JARVIS CORE TERMINAL',
          style: TextStyle(color: Colors.greenAccent, fontFamily: 'Courier', fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(1.0),
          child: Container(color: Colors.greenAccent.withOpacity(0.5), height: 1.0),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: EdgeInsets.all(16.0),
              itemCount: orchestrator.chatHistory.length,
              itemBuilder: (context, index) {
                final chat = orchestrator.chatHistory[index];
                final isUser = chat['sender'] == 'User';
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Align(
                    alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                    child: Container(
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: isUser ? Colors.blueGrey.withOpacity(0.3) : Colors.transparent,
                        border: isUser ? null : Border.all(color: Colors.greenAccent.withOpacity(0.5)),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        "${isUser ? '> User: ' : '[JARVIS]: '}${chat['message']}",
                        style: TextStyle(
                          color: isUser ? Colors.white : Colors.greenAccent,
                          fontFamily: 'Courier',
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          if (orchestrator.isThinking)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Row(
                  children: [
                    SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.cyanAccent),
                      ),
                    ),
                    SizedBox(width: 10),
                    Text(
                      "Processing system request...",
                      style: TextStyle(color: Colors.cyanAccent, fontFamily: 'Courier', fontStyle: FontStyle.italic),
                    ),
                  ],
                ),
              ),
            ),
          Container(
            padding: EdgeInsets.all(12.0),
            decoration: BoxDecoration(
              color: Colors.black,
              border: Border(top: BorderSide(color: Colors.greenAccent.withOpacity(0.5))),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _commandController,
                    style: TextStyle(color: Colors.white, fontFamily: 'Courier'),
                    decoration: InputDecoration(
                      hintText: "Enter protocol or command...",
                      hintStyle: TextStyle(color: Colors.grey),
                      border: InputBorder.none,
                    ),
                    onSubmitted: (_) => _sendCommand(),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send, color: Colors.greenAccent),
                  onPressed: _sendCommand,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

