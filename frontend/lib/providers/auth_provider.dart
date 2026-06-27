importimport 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../services/storage_service.dart';

enum AuthStage {
  none,
  loggedIn,
  mfaRequired,
  faceVerified,
  fingerprintVerified,
  voiceVerified,
  fullyAuthenticated
}

class AuthProvider extends ChangeNotifier {
  AuthStage _authStage = AuthStage.none;
  String _userRole = 'guest';
  String _sessionToken = '';
  bool _isGuestMode = true;

  AuthStage get authStage => _authStage;
  String get userRole => _userRole;
  String get sessionToken => _sessionToken;
  bool get isGuestMode => _isGuestMode;
  bool get isCreator => _userRole == 'creator';
  bool get isFullyAuthenticated => _authStage == AuthStage.fullyAuthenticated;

  Future<void> loginAsGuest() async {
    _authStage = AuthStage.loggedIn;
    _userRole = 'guest';
    _isGuestMode = true;
    await StorageService.saveUserRole('guest');
    notifyListeners();
  }

  Future<Map<String, dynamic>> loginWithGoogle(String email, String pin) async {
    try {
      final response = await ApiService.login(
        method: 'google',
        authData: email,
        pin: pin,
      );

      if (response['status'] == 'mfa_required') {
        _authStage = AuthStage.mfaRequired;
        _sessionToken = response['session_token'];
        _userRole = 'creator';
        _isGuestMode = false;
        notifyListeners();
      }

      return response;
    } catch (e) {
      return {'status': 'error', 'message': e.toString()};
    }
  }

  Future<bool> verifyMfaStep(String step, {String? pin}) async {
    try {
      final success = await ApiService.verifyMfa(
        sessionToken: _sessionToken,
        step: step,
        pin: pin,
      );

      if (success) {
        switch (step) {
          case 'face_id':
            _authStage = AuthStage.faceVerified;
            break;
          case 'fingerprint':
            _authStage = AuthStage.fingerprintVerified;
            break;
          case 'voice_match':
            _authStage = AuthStage.voiceVerified;
            break;
          case 'secure_pin':
            _authStage = AuthStage.fullyAuthenticated;
            await StorageService.saveUserRole('creator');
            break;
        }
        notifyListeners();
      }

      return success;
    } catch (e) {
      return false;
    }
  }

  void logout() {
    _authStage = AuthStage.none;
    _userRole = 'guest';
    _sessionToken = '';
    _isGuestMode = true;
    StorageService.clearAll();
    notifyListeners();
  }
}
