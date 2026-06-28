import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// आगे हम ये प्रोवाइडर्स और स्क्रीन्स बनाएंगे (अभी के लिए इन्हें ऐसे ही रहने दें)
// import 'providers/auth_provider.dart';
// import 'providers/workspace_provider.dart';
// import 'screens/auth/login_screen.dart';
// import 'screens/workspace_split_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // यहाँ हम लोकल स्टोरेज और कैमरा इनीशियलाइज़ करेंगे
  runApp(const ZarvishApp());
}

class ZarvishApp extends StatelessWidget {
  const ZarvishApp({super.key});

  @override
  Widget build(BuildContext context) {
    // MultiProvider आपके "Omni-UI" को पावर देगा
    return MultiProvider(
      providers: [
        // ChangeNotifierProvider(create: (_) => AuthProvider()),
        // ChangeNotifierProvider(create: (_) => WorkspaceProvider()),
      ],
      child: MaterialApp(
        title: 'Zarvish God-Mode',
        debugShowCheckedModeBanner: false,
        
        // Cyberpunk Dark Theme (Master Look)
        theme: ThemeData.dark().copyWith(
          scaffoldBackgroundColor: const Color(0xFF0A0A0A), // Deep Dark Black
          primaryColor: const Color(0xFF00FF41), // Matrix Hacker Green
          colorScheme: const ColorScheme.dark(
            primary: Color(0xFF00FF41),
            secondary: Color(0xFF8A2BE2), // Deep Violet for AI accents
          ),
          appBarTheme: const AppBarTheme(
            backgroundColor: Color(0xFF121212),
            elevation: 0,
          ),
        ),
        
        // AuthGate तय करेगा कि लॉगिन स्क्रीन दिखानी है या वर्कस्पेस
        home: const PlaceholderScreen(), // इसे हम AuthGate() से बदलेंगे 
      ),
    );
  }
}

// जब तक हम असली स्क्रीन्स नहीं बनाते, तब तक ऐप क्रैश न हो इसलिए ये डमी स्क्रीन है
class PlaceholderScreen extends StatelessWidget {
  const PlaceholderScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
          "ZARVISH 4.0 INITIALIZING...\nWAITING FOR NEURAL LINK.",
          textAlign: TextAlign.center,
          style: TextStyle(color: Color(0xFF00FF41), letterSpacing: 2.0),
        ),
      ),
    );
  }
}
