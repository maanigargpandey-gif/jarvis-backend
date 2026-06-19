// main.dart - Final God-Mode Integrated UI
class MasterDashboard extends StatefulWidget {
  @override
  _MasterDashboardState createState() => _MasterDashboardState();
}

class _MasterDashboardState extends State<MasterDashboard> {
  String currentMode = 'AI_CHAT'; // Modes: AI_CHAT, EXCEL, MEDIA, CRICKET

  void switchMode(String mode) {
    setState(() { currentMode = mode; });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Mode Switcher (Chameleon Mode)
          IndexedStack(
            index: _getModeIndex(),
            children: [
              AIChatInterface(onModeSwitch: switchMode), // Chat + Calculator + Timer
              ExcelEditor(), // Excel/Doc Mode
              MediaStudioEraser(), // Eraser + Media
              CricketMode(), // Girgit/Cricket
            ],
          ),
          // Live Camera PIP
          Positioned(top: 50, right: 20, child: LiveCameraContainer()),
        ],
      ),
    );
  }
  
  int _getModeIndex() {
    switch(currentMode) {
      case 'EXCEL': return 1;
      case 'MEDIA': return 2;
      case 'CRICKET': return 3;
      default: return 0;
    }
  }
}
