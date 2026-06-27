import 'package:flutter/material.dart';

class MFAService {
  static const List<String> mfaSteps = [
    'Face ID',
    'Fingerprint',
    'Voice Match',
    'Secure PIN',
  ];

  static IconData getStepIcon(String step) {
    switch (step) {
      case 'Face ID':
        return Icons.face;
      case 'Fingerprint':
        return Icons.fingerprint;
      case 'Voice Match':
        return Icons.mic;
      case 'Secure PIN':
        return Icons.lock;
      default:
        return Icons.security;
    }
  }

  static Color getStepColor(String step, bool isCompleted, bool isCurrent) {
    if (isCompleted) return Colors.green;
    if (isCurrent) return Colors.cyanAccent;
    return Colors.grey;
  }
}
