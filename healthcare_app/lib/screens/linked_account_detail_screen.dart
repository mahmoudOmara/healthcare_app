import 'package:flutter/material.dart';
import 'package:healthcare_app/providers/app_state.dart';
import 'package:healthcare_app/screens/health_issue_detail_screen.dart'; // Reuse detail screen for consistency
import 'package:intl/intl.dart';

class LinkedAccountDetailScreen extends StatelessWidget {
  final LinkedAccount account;

  const LinkedAccountDetailScreen({super.key, required this.account});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(account.name),
        // Back button is automatically added
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // Basic Info
          ListTile(
            leading: const Icon(Icons.family_restroom_outlined),
            title: const Text('Relationship'),
            subtitle: Text(account.relationship),
          ),
          const Divider(),

          // Health Issues Section
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Text(
              'Health Issues',
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
          if (account.healthIssues.isEmpty)
            const Center(child: Text('No health issues recorded for this account.'))
          else
            ...account.healthIssues.map((issue) {
              return Card(
                elevation: 1.0,
                margin: const EdgeInsets.symmetric(vertical: 6.0),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
                child: ListTile(
                  title: Text(issue.name, style: Theme.of(context).textTheme.titleMedium),
                  subtitle: Text('Status: ${issue.status} | Severity: ${issue.severity}'),
                  trailing: Chip(
                    label: Text(issue.status),
                     backgroundColor: issue.status == 'Ongoing'
                        ? Colors.orange.shade100
                        : (issue.status == 'Managed' || issue.status == 'Controlled' || issue.status == 'Improving')
                            ? Colors.green.shade100
                            : Colors.grey.shade200, // Default color
                    labelStyle: TextStyle(
                      color: issue.status == 'Ongoing'
                          ? Colors.orange.shade800
                          : (issue.status == 'Managed' || issue.status == 'Controlled' || issue.status == 'Improving')
                              ? Colors.green.shade800
                              : Colors.grey.shade800, // Default color
                      fontSize: 12.0,
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2.0),
                  ),
                  onTap: () {
                    // Navigate to the standard HealthIssueDetailScreen for this issue
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => HealthIssueDetailScreen(healthIssue: {
                           // Convert HealthIssue model to Map<String, dynamic>
                          'id': issue.id,
                          'name': issue.name,
                          'startDate': issue.startDate,
                          'severity': issue.severity,
                          'status': issue.status,
                          'symptoms': issue.symptoms,
                          'medications': issue.medications,
                          'doctor': issue.doctor,
                          'isRecurring': issue.isRecurring,
                          'nextFollowUp': issue.nextFollowUp,
                        }),
                      ),
                    );
                  },
                ),
              );
            }).toList(),
          
          const SizedBox(height: 24),

          // Placeholder for Logs/Reminders specific to this linked account
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Text(
              'Activity & Reminders (Placeholder)',
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
           Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              border: Border.all(color: Theme.of(context).colorScheme.outline),
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: const Center(
              child: Text('Logs and reminders specific to this linked account would appear here.'),
            ),
          ),
        ],
      ),
    );
  }
}

