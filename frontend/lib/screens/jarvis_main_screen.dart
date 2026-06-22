import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lottie/lottie.dart';
import '../providers/jarvis_state_provider.dart';
import 'creator_dashboard.dart';
import 'settings_screen.dart';

class JarvisMainScreen extends StatelessWidget {
  const JarvisMainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<JarvisStateProvider>(context);
    final TextEditingController textController = TextEditingController();
    
    return Scaffold(
      appBar: AppBar(title: const Text("JARVIS OS")),
      drawer: Drawer(
        child: ListView(
          children: [
            const DrawerHeader(child: Center(child: Text("JARVIS OS"))),
            ListTile(
              leading: const Icon(Icons.dashboard),
              title: const Text('Creator Dashboard'),
              onTap: () {
                Navigator.pop(context);
                if (provider.currentRole == 'Creator' || provider.currentRole == 'Owner') {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const CreatorDashboard()));
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Access Denied")));
                }
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Settings'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (_) => const SettingsScreen()));
              },
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: provider.messages.length,
              itemBuilder: (context, index) => ListTile(
                title: Text(provider.messages[index]['sender']),
                subtitle: Text(provider.messages[index]['text']),
              ),
            ),
          ),
          
          // यहाँ वो प्रो ब्रीदिंग एनीमेशन है जो प्रोसेसिंग के समय दिखेगा
          if (provider.isProcessing)
             SizedBox(
               height: 60,
               child: Lottie.network('https://assets10.lottiefiles.com/packages/lf20_t2som6gn.json'),
             ),
             
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(child: TextField(controller: textController)),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () {
                    provider.processUserCommand(textController.text);
                    textController.clear();
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
