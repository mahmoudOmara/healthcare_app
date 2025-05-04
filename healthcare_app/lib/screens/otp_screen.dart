import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // Import Provider
import 'package:healthcare_app/services/mock/mock_auth_service.dart'; // Import Mock Auth Service

class OTPScreen extends StatefulWidget {
  final String phoneNumber; // Receive phone number from LoginScreen
  final String verificationId; // Receive verificationId from LoginScreen

  const OTPScreen({
    super.key,
    required this.phoneNumber,
    required this.verificationId,
  });

  @override
  State<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  final TextEditingController _otpController = TextEditingController();
  bool _isLoading = false;
  bool _isResending = false;
  late String _currentVerificationId; // To store the latest verification ID

  @override
  void initState() {
    super.initState();
    _currentVerificationId = widget.verificationId; // Initialize with the ID from login
  }

  Future<void> _verifyOtp() async {
    final otp = _otpController.text.trim();
    if (otp.length != 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter the 6-digit OTP')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final mockAuthService = Provider.of<MockAuthService>(context, listen: false);

    try {
      // Use the current verification ID
      MockUser? user = await mockAuthService.signInWithOtp(_currentVerificationId, otp);

      setState(() {
        _isLoading = false;
      });

      if (user != null) {
        print('Mock OTP Verified! User: ${user.uid}');
        // Navigate to HomeScreen upon successful verification
        // Use pushNamedAndRemoveUntil to clear the auth stack
        Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
      } else {
        // This case might not happen if signInWithOtp throws on failure
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('OTP Verification failed')),
        );
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      print('Error during mock OTP verification: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Invalid OTP. Please try again. (Mock uses 123456)')),
      );
    }
  }

  Future<void> _resendOtp() async {
    setState(() {
      _isResending = true;
    });

    final mockAuthService = Provider.of<MockAuthService>(context, listen: false);

    try {
      await mockAuthService.verifyPhoneNumber(
        phoneNumber: widget.phoneNumber,
        codeSent: (String verificationId, int? resendToken) {
          setState(() {
            _isResending = false;
            _currentVerificationId = verificationId; // Update verification ID
          });
          print('Mock OTP Resent! New Verification ID: $verificationId');
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('New OTP sent (simulation)')),
          );
        },
        verificationFailed: (String error) {
          setState(() {
            _isResending = false;
          });
          print('Mock Resend Verification Failed: $error');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to resend OTP: $error')),
          );
        },
      );
    } catch (e) {
      setState(() {
        _isResending = false;
      });
      print('Error during mock resend OTP: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred while resending OTP: ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Enter OTP'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text(
              'Enter the 6-digit OTP sent to',
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              widget.phoneNumber,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            TextField(
              controller: _otpController,
              decoration: const InputDecoration(
                labelText: 'OTP Code',
                hintText: '------',
                counterText: "",
                prefixIcon: Icon(Icons.password_outlined),
              ),
              keyboardType: TextInputType.number,
              maxLength: 6,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 18, letterSpacing: 8),
              enabled: !_isLoading && !_isResending,
            ),
            const SizedBox(height: 24),
            _isLoading
                ? const Center(child: CircularProgressIndicator())
                : ElevatedButton(
                    onPressed: _verifyOtp,
                    child: const Text('Verify OTP'),
                  ),
            const SizedBox(height: 16),
            _isResending
                ? const Center(child: SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2)))
                : TextButton(
                    onPressed: _resendOtp,
                    child: const Text('Resend OTP'),
                  )
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _otpController.dispose();
    super.dispose();
  }
}

