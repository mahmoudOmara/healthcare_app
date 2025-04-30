import 'package:flutter/material.dart';
import 'package:healthcare_app/providers/app_state.dart';
import 'package:healthcare_app/screens/linked_account_detail_screen.dart'; // Import detail screen
import 'package:provider/provider.dart';

// Placeholder screen for adding a linked account manually
class AddLinkedAccountScreen extends StatelessWidget {
  const AddLinkedAccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: Implement form to add linked account details (Milestone 5)
    return Scaffold(
      appBar: AppBar(title: const Text('Add Linked Account Manually')),
      body: const Center(child: Text('Form to add linked account details goes here.')),
    );
  }
}

class LinkedAccountsScreen extends StatelessWidget {
  const LinkedAccountsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final linkedAccounts = appState.linkedAccounts;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Linked Accounts'),
        actions: [
          // Add Manually Button
          IconButton(
            icon: const Icon(Icons.person_add_alt_1_outlined),
            tooltip: 'Add Manually',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AddLinkedAccountScreen()),
              );
            },
          ),
          // Send Invite Button
          IconButton(
            icon: const Icon(Icons.send_outlined),
            tooltip: 'Send Invite',
            onPressed: () {
              // TODO: Implement Send Invite UI/Logic (Milestone 5)
              showDialog(
                context: context,
                builder: (BuildContext dialogContext) {
                  return AlertDialog(
                    title: const Text('Send Invite'),
                    content: const TextField(
                      decoration: InputDecoration(
                        labelText: 'Enter Email or Phone Number',
                        hintText: 'example@email.com or +1234567890',
                      ),
                      keyboardType: TextInputType.emailAddress,
                    ),
                    actions: <Widget>[
                      TextButton(
                        child: const Text('Cancel'),
                        onPressed: () {
                          Navigator.of(dialogContext).pop();
                        },
                      ),
                      TextButton(
                        child: const Text('Send'),
                        onPressed: () {
                          // TODO: Implement actual invite sending logic
                          print('Sending invite (simulation)...');
                          Navigator.of(dialogContext).pop();
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Invite sent (simulation)!')),
                          );
                        },
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
      body: linkedAccounts.isEmpty
          ? const Center(child: Text('No linked accounts found.'))
          : ListView.builder(
              padding: const EdgeInsets.all(8.0),
              itemCount: linkedAccounts.length,
              itemBuilder: (context, index) {
                final account = linkedAccounts[index];
                return Card(
                  elevation: 1.0,
                  margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                  child: ListTile(
                    leading: CircleAvatar(
                      // Placeholder avatar, replace with actual image if available
                      child: Text(account.name.isNotEmpty ? account.name[0] : '?'),
                    ),
                    title: Text(account.name),
                    subtitle: Text(account.relationship),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {
                      // Navigate to the detail view for the linked account
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LinkedAccountDetailScreen(account: account),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
    );
  }
}

