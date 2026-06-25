import 'package:flutter/material.dart';

class VoiceProvider extends ChangeNotifier {
  bool _isListening = false;
  bool _isMuted = false;
  double _volume = 0.0;
  List<double> _waveformData = List.generate(50, (i) => (i % 10) / 10);
  
  bool get isListening => _isListening;
  bool get isMuted => _isMuted;
  double get volume => _volume;
  List<double> get waveformData => _waveformData;
  
  void toggleListening() {
    _isListening = !_isListening;
    if (_isListening) _startWaveformAnimation();
    notifyListeners();
  }
  
  void _startWaveformAnimation() {
    Future.doWhile(() async {
      if (!_isListening) return false;
      await Future.delayed(const Duration(milliseconds: 100));
      _waveformData = List.generate(50, (i) => (i % 10 + (_isListening ? 5 : 0)) / 10);
      notifyListeners();
      return _isListening;
    });
  }
  
  void setVolume(double vol) {
    _volume = vol;
    notifyListeners();
  }
}
