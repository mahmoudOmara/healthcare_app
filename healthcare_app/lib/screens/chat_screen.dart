import 'package:flutter/material.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Sample chat messages
    final List<Map<String, String>> messages = [
      {'sender': 'Agent', 'text': 'Hello! How can I help you today?'},
      {'sender': 'User', 'text': 'I need help remembering to take my medication.'},
      {'sender': 'Agent', 'text': 'Okay, I can help with that. Which medication is it?'},
      {'sender': 'User', 'text': 'Lisinopril, for my hypertension.'},
      {'sender': 'Agent', 'text': 'Got it. I can set up a reminder for you. What time do you usually take it?'},
      {'sender': 'User', 'text': 'Around 8 AM.'},
      {'sender': 'Agent', 'text': 'Perfect. I've set a daily reminder for 8 AM for Lisinopril. You'll receive a notification.'},
      {'sender': 'User', 'text': 'Thank you so much! That's very helpful.'},
      {'sender': 'Agent', 'text': 'You're welcome! Is there anything else I can assist you with?'},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat with Support'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final message = messages[index];
                final isUserMessage = message['sender'] == 'User';
                return Align(
                  alignment: isUserMessage ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 5.0),
                    padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 10.0),
                    decoration: BoxDecoration(
                      color: isUserMessage ? Theme.of(context).primaryColor.withOpacity(0.1) : Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: Text(
                      message['text']!,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                );
              },
            ),
          ),
          // Simple Input Area (Non-functional for now)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              boxShadow: [
                BoxShadow(
                  offset: const Offset(0, -1),
                  blurRadius: 4,
                  color: Colors.black.withOpacity(0.05),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Type your message...', 
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.grey.shade100,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
                    ),
                    enabled: false, // Disable input for this basic UI
                  ),
                ),
                const SizedBox(width: 8.0),
                IconButton(
                  icon: Icon(Icons.send, color: Theme.of(context).primaryColor),
                  onPressed: null, // Disable send button
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

