import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String _baseUrl = "https://your-jarvis-backend-url.com"; // यहाँ अपनी URL डालना

  static Stream<String> streamAiResponse(String prompt, String apiKey) async* {
    // यह API बाइंडिंग का मेन फंक्शन है। 
    // यह अब पूरी तरह से 'Overlay' के साथ सिंक है।
    try {
      yield "Connecting to Neural Core...";
      // यहाँ API कॉल होगी (जो भी तुम्हारी API का तरीका है)
      await Future.delayed(const Duration(seconds: 1));
      yield "Thinking...";
      await Future.delayed(const Duration(seconds: 1));
      yield "Neural Link Established. System is ready.";
    } catch (e) {
      yield "Error: ${e.toString()}";
    }
  }

  static Future<void> reportErrorToDashboard(String module, String error) async {
    // एरर रिपोर्टिंग के लिए
    print("Reporting $module error: $error");
  }
}
