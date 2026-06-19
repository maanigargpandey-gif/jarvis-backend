// (Main logic only - copy paste into main.dart)
class DynamicDashboard extends StatefulWidget {
  @override
  _DynamicDashboardState createState() => _DynamicDashboardState();
}

class _DynamicDashboardState extends State<DynamicDashboard> {
  String currentMode = 'AI_CHAT'; // Mode: AI_CHAT, EXCEL, MEDIA_EDIT, CRICKET

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // 1. Dynamic UI Switcher
        IndexedStack(
          index: _getModeIndex(currentMode),
          children: [
            AIChatPage(),
            ExcelEditorView(),
            MediaEditorView(), // Photo/Video Eraser
            CricketModeView(),
          ],
        ),
        
        // 2. Floating Camera PIP (25% Screen)
        Positioned(
          top: 50, right: 20,
          child: Container(
            width: MediaQuery.of(context).size.width * 0.25,
            height: 150,
            decoration: BoxDecoration(border: Border.all(color: Colors.greenAccent)),
            child: Text("LIVE CAMERA FEED", style: TextStyle(color: Colors.white)),
          ),
        ),
      ],
    );
  }
  int _getModeIndex(String mode) => {'AI_CHAT': 0, 'EXCEL': 1, 'MEDIA_EDIT': 2, 'CRICKET': 3}[mode] ?? 0;
}
