// Mock implementation of Firebase Authentication service

import 'dart:async';

// Mock User class (replace with actual FirebaseAuth User if needed)
class MockUser {
  final String uid;
  final String? phoneNumber;

  MockUser({required this.uid, this.phoneNumber});
}

class MockAuthService {
  // Simulate the current user state
  MockUser? _currentUser;
  final _authStateController = StreamController<MockUser?>.broadcast();

  // Simulate phone verification process
  String? _verificationId;
  String? _phoneNumberBeingVerified;

  MockAuthService() {
    // Simulate initial auth state (e.g., logged out)
    _currentUser = null;
    _authStateController.add(_currentUser);
  }

  Stream<MockUser?> get authStateChanges => _authStateController.stream;

  MockUser? get currentUser => _currentUser;

  // Mock phone number sign-in initiation
  Future<void> verifyPhoneNumber({
    required String phoneNumber,
    required Function(String verificationId, int? resendToken) codeSent,
    required Function(String error) verificationFailed,
    // Other callbacks like codeAutoRetrievalTimeout can be added if needed
  }) async {
    print('MockAuth: Verifying phone number: $phoneNumber');
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));

    // Simulate success
    _verificationId = 'mock_verification_id_${DateTime.now().millisecondsSinceEpoch}';
    _phoneNumberBeingVerified = phoneNumber;
    print('MockAuth: Sending mock OTP. Verification ID: $_verificationId');
    codeSent(_verificationId!, null); // No resend token in mock

    // Simulate failure (uncomment to test failure)
    // verificationFailed('MockAuth: Invalid phone number format');
  }

  // Mock OTP verification and sign-in
  Future<MockUser?> signInWithOtp(String verificationId, String smsCode) async {
    print('MockAuth: Verifying OTP: $smsCode for verification ID: $verificationId');
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));

    if (verificationId == _verificationId && smsCode == '123456') { // Simulate correct OTP
      print('MockAuth: OTP verified successfully.');
      _currentUser = MockUser(uid: 'mock_user_${DateTime.now().millisecondsSinceEpoch}', phoneNumber: _phoneNumberBeingVerified);
      _authStateController.add(_currentUser);
      _verificationId = null; // Clear verification state
      _phoneNumberBeingVerified = null;
      return _currentUser;
    } else {
      print('MockAuth: Invalid OTP or verification ID.');
      // In a real app, throw FirebaseAuthException
      throw Exception('MockAuth: Invalid OTP');
    }
  }

  // Mock sign out
  Future<void> signOut() async {
    print('MockAuth: Signing out.');
    await Future.delayed(const Duration(milliseconds: 500));
    _currentUser = null;
    _authStateController.add(_currentUser);
  }

  void dispose() {
    _authStateController.close();
  }
}

