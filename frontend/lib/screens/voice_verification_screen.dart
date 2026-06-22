import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lottie/lottie.dart';
import '../providers/jarvis_state_provider.dart';

class VoiceVerificationScreen extends StatelessWidget {
  const VoiceVerificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // यहाँ तुम्हारा 'इमोजी ब्लिंक' वाला एनीमेशन लोड होगा
            // मान लो फाइल का नाम blink_emoji.json है जिसे तुमने assets/images/ में रखा है
            Lottie.network(
              'https://assets10.lottiefiles.com/packages/lf20_t2som6gn.json', 
              width: 200, 
              height: 200,
              repeat: true,
            ),
            
            const SizedBox(height: 30),
            const Text(
              "Scanning Identity...", 
              style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)
            ),
            const SizedBox(height: 20),
            
            ElevatedButton(
              onPressed: () {
                // यह बटन तब काम करेगा जब बैकएंड से वेरिफिकेशन OK हो जाएगा
                Provider.of<JarvisStateProvider>(context, listen: false).completeAuth();
              },
              child: const Text("Verify Now"),
            ),
          ],
        ),
      ),
    );
  }
}
