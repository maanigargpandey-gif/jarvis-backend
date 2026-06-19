import 'package:flutter/material.dart';

// ==========================================
// SYSTEM IGNITION (ABSOLUTE ZERO-BREACH)
// ==========================================
void main() {
  runApp(const JarvisGodModeApp());
}

class JarvisGodModeApp extends StatelessWidget {
  const JarvisGodModeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'J.A.R.V.I.S God-Mode',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(useMaterial3: true).copyWith(
        scaffoldBackgroundColor: const Color(0xFF090909), // Deep Vault Black
        colorScheme: const ColorScheme.dark(
          primary: Colors.cyanAccent,
          secondary: Colors.purpleAccent,
        ),
      ),
      home: const MasterGirgitDashboard(),
    );
  }
}

// ==========================================
// THE GIRGIT UI (SHAPE-SHIFTING DASHBOARD)
// ==========================================
class MasterGirgitDashboard extends StatefulWidget {
  const MasterGirgitDashboard({super.key});

  @override
  State<MasterGirgitDashboard> createState() => _MasterGirgitDashboardState();
}

class _MasterGirgitDashboardState extends State<MasterGirgitDashboard> {
  String currentUIState = 'AI_CHAT'; 

  void transformUI(String newState) {
    setState(() {
      currentUIState = newState;
    });
  }

  Widget _buildGirgitInterface() {
    switch (currentUIState) {
      case 'VIDEO_STUDIO': return const CapCutVideoStudio();
      case 'PHOTO_STUDIO': return const HighEndPhotoStudio();
      case 'OFFICE_FORGE': return const OfficeForgeEditor();
      case 'NEXUS_VAULT': return const NexusVaultArchive();
      case 'SELF_EVOLUTION': return const SelfEvolutionConsole();
      case 'AI_CHAT':
      default: return AIChatInterface(onTransform: transformUI);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: const [
            Icon(Icons.security, color: Colors.greenAccent, size: 18),
            SizedBox(width: 8),
            Text("Quantum Secure | J.A.R.V.I.S", style: TextStyle(color: Colors.cyanAccent, fontSize: 16, fontWeight: FontWeight.bold)),
          ],
        ),
        backgroundColor: Colors.black,
        actions: [
          IconButton(
            icon: const Icon(Icons.storage, color: Colors.blueAccent),
            tooltip: 'The Nexus Vault',
            onPressed: () => transformUI('NEXUS_VAULT'),
          ),
          IconButton(
            icon: const Icon(Icons.auto_awesome, color: Colors.yellowAccent),
            tooltip: 'Self-Evolution Protocol',
            onPressed: () => transformUI('SELF_EVOLUTION'),
          )
        ],
      ),
      body: Stack(
        children: [
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 400),
            child: _buildGirgitInterface(),
          ),
          // CALL INTERCEPTOR PIP
          const Positioned(
            top: 20, 
            left: 20, 
            child: CallManagerPIP(),
          ),
          // LIVE CAMERA VISION PIP
          const Positioned(
            top: 20, 
            right: 20, 
            child: LiveCameraPIP(),
          ),
        ],
      ),
    );
  }
}

// ==========================================
// MODULE 1: AI CHAT & ACTION BAR (Uncensored)
// ==========================================
class AIChatInterface extends StatelessWidget {
  final Function(String) onTransform;
  const AIChatInterface({super.key, required this.onTransform});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Expanded(
          child: Center(child: Text("Uncensored Swarm Active. Awaiting Command...", style: TextStyle(color: Colors.grey))),
        ),
        // THE ACTION BAR (Gemini-Style + Nexus Save)
        Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          color: const Color(0xFF151515),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(icon: const Icon(Icons.thumb_up_alt_outlined, color: Colors.white54), onPressed: (){}),
                  IconButton(icon: const Icon(Icons.thumb_down_alt_outlined, color: Colors.white54), onPressed: (){}),
                  IconButton(icon: const Icon(Icons.refresh, color: Colors.white54), tooltip: 'Regenerate', onPressed: (){}),
                  IconButton(icon: const Icon(Icons.copy, color: Colors.white54), onPressed: (){}),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.blueAccent.withOpacity(0.2)),
                    icon: const Icon(Icons.save_alt, color: Colors.cyanAccent),
                    label: const Text("Save to Nexus", style: TextStyle(color: Colors.cyanAccent)),
                    onPressed: () { /* Logic to save to Nexus */ },
                  ),
                ],
              ),
              const SizedBox(height: 10),
              // GIRGIT TRIGGERS (Simulating Output Detection)
              Wrap(
                spacing: 10,
                children: [
                  ActionChip(label: const Text("Open Forge (Office)"), onPressed: () => onTransform('OFFICE_FORGE')),
                  ActionChip(label: const Text("Open Video Studio"), onPressed: () => onTransform('VIDEO_STUDIO')),
                  ActionChip(label: const Text("Open Photo Studio"), onPressed: () => onTransform('PHOTO_STUDIO')),
                ],
              )
            ],
          ),
        )
      ],
    );
  }
}

// ==========================================
// MODULE 2: THE NEXUS VAULT (Smart Storage)
// ==========================================
class NexusVaultArchive extends StatelessWidget {
  const NexusVaultArchive({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(15),
          color: Colors.blue.shade900.withOpacity(0.5),
          child: const Text("THE NEXUS VAULT - Quantum Encrypted Storage", textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        ),
        Expanded(
          child: GridView.count(
            crossAxisCount: 2,
            padding: const EdgeInsets.all(20),
            children: const [
              VaultFolder(icon: Icons.picture_as_pdf, title: "PDF Archives", color: Colors.redAccent),
              VaultFolder(icon: Icons.table_chart, title: "Excel / Spreadsheets", color: Colors.greenAccent),
              VaultFolder(icon: Icons.video_library, title: "Rendered Videos", color: Colors.purpleAccent),
              VaultFolder(icon: Icons.note, title: "Creator Notes", color: Colors.yellowAccent),
            ],
          ),
        )
      ],
    );
  }
}

class VaultFolder extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color color;
  const VaultFolder({super.key, required this.icon, required this.title, required this.color});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.black45,
      shape: RoundedRectangleBorder(side: BorderSide(color: color, width: 1), borderRadius: BorderRadius.circular(10)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 50, color: color),
          const SizedBox(height: 10),
          Text(title, style: const TextStyle(color: Colors.white)),
        ],
      ),
    );
  }
}

// ==========================================
// MODULE 3: THE OFFICE FORGE (Word, Excel, PPT, PDF)
// ==========================================
class OfficeForgeEditor extends StatelessWidget {
  const OfficeForgeEditor({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          color: const Color(0xFF1A1A1A),
          padding: const EdgeInsets.all(10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: const [
              Icon(Icons.format_bold, color: Colors.white),
              Icon(Icons.table_chart, color: Colors.greenAccent), // Excel
              Icon(Icons.slideshow, color: Colors.orangeAccent), // PPT
              Icon(Icons.picture_as_pdf, color: Colors.redAccent), // PDF
              Icon(Icons.save, color: Colors.cyanAccent), // Save to Nexus
            ],
          ),
        ),
        const Expanded(
          child: Center(child: Text("Document Forge Active.\nFull Formatting Enabled.", textAlign: TextAlign.center, style: TextStyle(color: Colors.white54, fontSize: 18))),
        )
      ],
    );
  }
}

// ==========================================
// MODULE 4: VIDEO & PHOTO STUDIOS
// ==========================================
class CapCutVideoStudio extends StatelessWidget {
  const CapCutVideoStudio({super.key});
  @override
  Widget build(BuildContext context) => const Center(child: Text("Video Studio (CapCut Engine) Active", style: TextStyle(color: Colors.purpleAccent, fontSize: 20)));
}

class HighEndPhotoStudio extends StatelessWidget {
  const HighEndPhotoStudio({super.key});
  @override
  Widget build(BuildContext context) => const Center(child: Text("Photo Studio (Snapseed Engine) Active", style: TextStyle(color: Colors.tealAccent, fontSize: 20)));
}

// ==========================================
// MODULE 5: SELF-EVOLUTION & SECURITY
// ==========================================
class SelfEvolutionConsole extends StatelessWidget {
  const SelfEvolutionConsole({super.key});
  @override
  Widget build(BuildContext context) => const Center(child: Text("> Zero Dependency Mode Active\n> Searching Free Alternatives...", style: TextStyle(color: Colors.greenAccent, fontFamily: 'monospace', fontSize: 18)));
}

// ==========================================
// MODULE 6: FLOATING MANAGERS (Call & Camera)
// ==========================================
class CallManagerPIP extends StatelessWidget {
  const CallManagerPIP({super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(color: Colors.black87, border: Border.all(color: Colors.greenAccent), borderRadius: BorderRadius.circular(20)),
      child: Row(
        children: const [
          Icon(Icons.phone_in_talk, color: Colors.greenAccent, size: 16),
          SizedBox(width: 5),
          Text("Call Manager: ON", style: TextStyle(color: Colors.greenAccent, fontSize: 12)),
        ],
      ),
    );
  }
}

class LiveCameraPIP extends StatelessWidget {
  const LiveCameraPIP({super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80, height: 110,
      decoration: BoxDecoration(color: Colors.black87, border: Border.all(color: Colors.cyanAccent), borderRadius: BorderRadius.circular(8)),
      child: const Center(child: Icon(Icons.camera_alt, color: Colors.white54)),
    );
  }
}
