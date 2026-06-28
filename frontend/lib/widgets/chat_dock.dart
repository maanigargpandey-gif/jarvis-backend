import 'package:flutter/material.dart';
import 'attachment_menu.dart';

class ChatDock extends StatelessWidget {
  const ChatDock({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 16.0),
      // डीपसीक वाला डिफ़ॉल्ट डार्क बैकग्राउंड
      color: Theme.of(context).scaffoldBackgroundColor, 
      child: Row(
        children: [
          // The [+] Attachment Button
          IconButton(
            icon: const Icon(Icons.add_circle_outline, color: Colors.white70, size: 28),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                backgroundColor: Colors.transparent,
                builder: (context) => const AttachmentMenu(),
              );
            },
          ),
          const SizedBox(width: 8),
          
          // Text Input Field
          Expanded(
            child: TextField(
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: "जार्विस, कमांड दो...",
                hintStyle: const TextStyle(color: Colors.white38),
                filled: true,
                fillColor: Colors.white10, // डीपसीक का ग्लास इफ़ेक्ट
                contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          
          // The Microphone / Voice Command Button
          CircleAvatar(
            radius: 24,
            backgroundColor: const Color(0xFF7C4DFF), // डीपसीक का डिफ़ॉल्ट पर्पल/ब्लू एक्सेंट
            child: IconButton(
              icon: const Icon(Icons.mic, color: Colors.white),
              onPressed: () {
                // Voice Listening Logic Here
              },
            ),
          ),
        ],
      ),
    );
  }
}

