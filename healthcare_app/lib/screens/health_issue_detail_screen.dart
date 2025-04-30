import 'package:flutter/material.dart';
import 'package:healthcare_app/widgets/detail_action_dialogs.dart'; // Import the dialogs

class HealthIssueDetailScreen extends StatefulWidget {
  // TODO: Pass the actual health issue data to this screen
  final Map<String, dynamic> healthIssue;

  const HealthIssueDetailScreen({super.key, required this.healthIssue});

  @override
  State<HealthIssueDetailScreen> createState() => _HealthIssueDetailScreenState();
}

class _HealthIssueDetailScreenState extends State<HealthIssueDetailScreen> {
  @override
  Widget build(BuildContext context) {
    // Placeholder data access - replace with actual data from widget.healthIssue
    final issueName = widget.healthIssue['name'] ?? 'Issue Details';
    final severity = widget.healthIssue['severity'] ?? 'N/A';
    final medications = widget.healthIssue['medications'] ?? 'None listed';
    final doctor = widget.healthIssue['doctor'] ?? 'N/A';

    return Scaffold(
      appBar: AppBar(
        title: Text(issueName),
        // Back button is automatically added by Navigator
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // Top Action Buttons Row
          Padding(
            padding: const EdgeInsets.only(bottom: 24.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildActionButton(context, Icons.add_comment_outlined, 'Add Update', () {
                  showAddUpdateDialog(context); // Call the dialog function
                }),
                _buildActionButton(context, Icons.upload_file_outlined, 'Upload File', () {
                  showUploadFileDialog(context); // Call the dialog function
                }),
                _buildActionButton(context, Icons.event_available_outlined, 'Book Follow-Up', () {
                  showBookFollowUpDialog(context); // Call the dialog function
                }),
                _buildActionButton(context, Icons.alarm_add_outlined, 'Add Reminder', () {
                  showAddReminderDialog(context); // Call the dialog function
                }),
              ],
            ),
          ),

          // General Info Section
          Card(
            elevation: 1,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('General Information', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  _buildInfoRow('Severity:', severity),
                  _buildInfoRow('Medications:', medications),
                  _buildInfoRow('Doctor/Clinic:', doctor),
                  // TODO: Add other relevant fields from the issue data (e.g., Start Date, Symptoms)
                ],
              ),
            ),
          ),

          const SizedBox(height: 24),

          // History Timeline Section
          Text('History Timeline', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          // TODO: Implement History Timeline UI (e.g., using a ListView or custom widgets)
          Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              border: Border.all(color: Theme.of(context).colorScheme.outline),
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: const Center(
              child: Text('History timeline will appear here (e.g., updates, logs, reminders).'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(BuildContext context, IconData icon, String label, VoidCallback onPressed) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: Icon(icon, color: Theme.of(context).primaryColor),
          iconSize: 28.0,
          onPressed: onPressed,
          tooltip: label,
        ),
        const SizedBox(height: 4),
        Text(label, style: Theme.of(context).textTheme.labelSmall, textAlign: TextAlign.center),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500)),
          const SizedBox(width: 8),
          Expanded(child: Text(value, style: Theme.of(context).textTheme.bodyMedium)),
        ],
      ),
    );
  }
}

