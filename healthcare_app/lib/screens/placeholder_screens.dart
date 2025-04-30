import 'package:flutter/material.dart';

// Placeholder screens for other tabs
class ContactScreen extends StatelessWidget {
  const ContactScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contact Support'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 20),
            ElevatedButton.icon(
              icon: const Icon(Icons.chat_bubble_outline),
              label: const Text('Start Chat'),
              onPressed: () {
                // TODO: Navigate to full-page chat view (Milestone 3)
                print('Start Chat button pressed');
                // Example navigation (replace with actual route)
                // Navigator.push(context, MaterialPageRoute(builder: (context) => ChatScreen()));
                 ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Chat screen not implemented yet.')),
                );
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                textStyle: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            const SizedBox(height: 20),
            OutlinedButton.icon(
              icon: const Icon(Icons.phone_outlined),
              label: const Text('Request Call'),
              onPressed: () {
                // TODO: Trigger popup confirmation (Milestone 3)
                print('Request Call button pressed');
                showDialog(
                  context: context,
                  builder: (BuildContext dialogContext) {
                    return AlertDialog(
                      title: const Text('Request Call Confirmation'),
                      content: const Text('Are you sure you want to request a call from our support team?'),
                      actions: <Widget>[
                        TextButton(
                          child: const Text('Cancel'),
                          onPressed: () {
                            Navigator.of(dialogContext).pop();
                          },
                        ),
                        TextButton(
                          child: const Text('Confirm'),
                          onPressed: () {
                            // TODO: Implement call request logic
                            print('Call request confirmed');
                            Navigator.of(dialogContext).pop();
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Call request submitted (simulation)!')),
                            );
                          },
                        ),
                      ],
                    );
                  },
                );
              },
               style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                textStyle: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            const SizedBox(height: 40),
            // Placeholder for sample chat snippet if needed later
            // Text('Recent Chat Snippet:', style: Theme.of(context).textTheme.titleMedium),
            // Expanded(
            //   child: Container(
            //     padding: EdgeInsets.all(8.0),
            //     decoration: BoxDecoration(
            //       border: Border.all(color: Colors.grey.shade300),
            //       borderRadius: BorderRadius.circular(8.0),
            //     ),
            //     child: Text('Sample chat messages would appear here...'),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}

class CalendarScreen extends StatelessWidget {
  const CalendarScreen({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(title: const Text('Calendar')),
      body: const Center(child: Text('Calendar Screen - To be implemented')));
}

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(title: const Text('History')),
      body: const Center(child: Text('History Screen - To be implemented')));
}

class LinkedAccountsScreen extends StatelessWidget {
  const LinkedAccountsScreen({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(title: const Text('Linked Accounts')),
      body: const Center(child: Text('Linked Accounts Screen - To be implemented')));
}

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: const Center(child: Text('Settings Screen - To be implemented')));
}

