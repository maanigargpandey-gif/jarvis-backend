import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// --- Theme & Providers ---
import 'config/theme.dart';
import 'providers/workspace_provider.dart';

// --- Screens ---
import 'screens/auth/login_screen.dart';

void main() async {
  // Flutter बाइंडिंग इनीशियलाइज़ करना (लोकल स्टोरेज/हार्डवेयर के लिए)
  WidgetsFlutterBinding.ensureInitialized();
  
  // यहाँ पर जार्विस का बेस स्टार्ट होता है
  runApp(const ZarvishApp());
}

class ZarvishApp extends StatelessWidget {
  const ZarvishApp({super.key});

  @override
  Widget build(BuildContext context) {
    // MultiProvider आपके "Omni-UI" (बिना रीस्टार्ट किए UI बदलना) को पावर देता है
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => WorkspaceProvider()),
        // अगर भविष्य में ThemeProvider या AuthProvider जोड़ना हो, तो यहाँ आएगा
      ],
      child: MaterialApp(
        title: 'Zarvish God-Mode',
        debugShowCheckedModeBanner: false, // डिबग बैनर हटा दिया
        
        // 🎨 मास्टर थीम (Dark Ash Grey, Emerald Green, Electric Blue)
        theme: ZarvishTheme.cyberpunkDark,
        
        // 🛡️ ऑथेंटिकेशन गेट (सबसे पहले यह चेक करेगा कि 'मानी भाई' हैं या नहीं)
        home: const LoginScreen(), 
      ),
    );
  }
}
