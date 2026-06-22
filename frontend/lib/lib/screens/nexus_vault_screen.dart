import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/jarvis_state_provider.dart';

class NexusVaultScreen extends StatefulWidget {
  const NexusVaultScreen({super.key});

  @override
  _NexusVaultScreenState createState() => _NexusVaultScreenState();
}

class _NexusVaultScreenState extends State<NexusVaultScreen> {
  @override
  void initState() {
    super.initState();
    // स्क्रीन खुलते ही फाइलें फेच करो
    Provider.of<JarvisStateProvider>(context, listen: false).loadVaultFiles();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Nexus Vault")),
      body: Consumer<JarvisStateProvider>(
        builder: (context, provider, _) {
          if (provider.files.isEmpty) {
            return const Center(child: Text("No artifacts in Vault."));
          }
          return ListView.builder(
            itemCount: provider.files.length,
            itemBuilder: (context, index) {
              final file = provider.files[index];
              return Card(
                margin: const EdgeInsets.all(8),
                child: ListTile(
                  leading: const Icon(Icons.insert_drive_file),
                  title: Text(file['name'] ?? "Unknown"),
                  subtitle: Text("Size: ${file['size'] ?? 'N/A'}"),
                  onTap: () {
                    // यहाँ फाइल ओपनिंग का लॉजिक आएगा
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
