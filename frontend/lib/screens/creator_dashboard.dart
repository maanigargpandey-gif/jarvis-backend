import 'package:flutter/material.dart';
import '../services/api_service.dart';

class CreatorDashboard extends StatelessWidget {
  const CreatorDashboard({super.key});

  final List<Map<String, String>> tools = const [
    {"name": "AI Vision", "id": "vision"},
    {"name": "Nexus Vault", "id": "vault"},
    {"name": "Data Entry", "id": "data"},
    {"name": "Command Center", "id": "cmd"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Creator Dashboard")),
      body: GridView.builder(
        padding: const EdgeInsets.all(20),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 20,
          mainAxisSpacing: 20,
        ),
        itemCount: tools.length,
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () async {
              // क्रिएटर टूल कॉल करना
              final result = await ApiService.callCreatorTool(tools[index]['id']!, "mani_jarvis_admin_786");
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Tool ${tools[index]['name']} Result: ${result['status']}")),
              );
            },
            child: Container(
              decoration: BoxDecoration(
                color: Colors.blueGrey.withOpacity(0.2),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Center(child: Text(tools[index]['name']!, style: const TextStyle(fontSize: 18))),
            ),
          );
        },
      ),
    );
  }
}
