import 'package:flutter/material.dart';

class AuthService {
  // यह वो फाइल है जहाँ तुम्हारा क्रिएटर डेटा सेट है।
  // इसे मैंने पूरी तरह से सिंक कर दिया है।
  static const String creatorEmail = "pranjalpandey91251@gmail.com";
  static const String creatorPhone = "91251"; 

  static bool isCreator(String email, String phone) {
    return email == creatorEmail || phone == creatorPhone;
  }
}
