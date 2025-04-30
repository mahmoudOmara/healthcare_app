import 'package:flutter/material.dart';

class OTPScreen extends StatefulWidget {
  final String phoneNumber; // Receive phone number from LoginScreen

  const OTPScreen({super.key, required this.phoneNumber});

  @override
  State<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  final TextEditingController _otpController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Enter OTP'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0), // Increased padding
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch, // Stretch elements
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
            // TODO: Use a more sophisticated OTP input field (e.g., pinput package)
            TextField(
              controller: _otpController,
              decoration: const InputDecoration(
                labelText: 'OTP Code',
                hintText: '------',
                counterText: "", // Hide the counter
                prefixIcon: Icon(Icons.password_outlined),
              ),
              keyboardType: TextInputType.number,
              maxLength: 6,
              textAlign: TextAlign.center, // Center the input text
              style: const TextStyle(fontSize: 18, letterSpacing: 8), // Style for OTP look
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                // TODO: Implement actual OTP verification logic
                final otp = _otpController.text;
                if (otp.length == 6) { // Basic validation
                  print('Verifying OTP: $otp for ${widget.phoneNumber}');
                  // Navigate to HomeScreen upon successful verification
                  // Use pushReplacementNamed to prevent going back to OTP/Login screens
                  Navigator.pushReplacementNamed(context, '/home');
                } else {
                   // Show error if OTP is not 6 digits
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please enter the 6-digit OTP')),
                  );
                }
              },
              child: const Text('Verify OTP'),
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () {
                // TODO: Implement resend OTP logic
                print('Resend OTP requested for ${widget.phoneNumber}');
                 ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Resend OTP request sent (simulation)')),
                  );
              },
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

