import 'package:flutter/material.dart';

// Simple dialog for adding an update
Future<void> showAddUpdateDialog(BuildContext context) async {
  final TextEditingController updateController = TextEditingController();

  return showDialog<void>(
    context: context,
    barrierDismissible: false, // User must tap button!
    builder: (BuildContext dialogContext) {
      return AlertDialog(
        title: const Text('Add Update'),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              const Text('Enter details about the update:'),
              const SizedBox(height: 16),
              TextField(
                controller: updateController,
                decoration: const InputDecoration(
                  hintText: 'e.g., Feeling better today, took medication...', 
                  border: OutlineInputBorder(),
                ),
                maxLines: 4,
              ),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('Cancel'),
            onPressed: () {
              Navigator.of(dialogContext).pop(); // Close the dialog
            },
          ),
          TextButton(
            child: const Text('Save Update'),
            onPressed: () {
              // TODO: Implement save update logic (e.g., save to history timeline)
              final updateText = updateController.text;
              if (updateText.isNotEmpty) {
                print('Saving update: $updateText');
                Navigator.of(dialogContext).pop(); // Close the dialog
                // Optionally show a confirmation snackbar
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Update saved (simulation)!')),
                );
              } else {
                 ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Please enter an update.')),
                );
              }
            },
          ),
        ],
      );
    },
  );
}

// Placeholder dialogs for other actions
Future<void> showUploadFileDialog(BuildContext context) async {
   return showDialog<void>(
    context: context,
    builder: (BuildContext dialogContext) {
       return AlertDialog(
        title: const Text('Upload File'),
        content: const Text('File upload functionality will be implemented here. (e.g., using file_picker)'),
        actions: <Widget>[
          TextButton(
            child: const Text('OK'),
            onPressed: () => Navigator.of(dialogContext).pop(),
          ),
        ],
      );
    });
}

Future<void> showBookFollowUpDialog(BuildContext context) async {
   return showDialog<void>(
    context: context,
    builder: (BuildContext dialogContext) {
       return AlertDialog(
        title: const Text('Book Follow-Up'),
        content: const Text('Follow-up booking functionality will be implemented here.'),
        actions: <Widget>[
          TextButton(
            child: const Text('OK'),
            onPressed: () => Navigator.of(dialogContext).pop(),
          ),
        ],
      );
    });
}

Future<void> showAddReminderDialog(BuildContext context) async {
   return showDialog<void>(
    context: context,
    builder: (BuildContext dialogContext) {
       return AlertDialog(
        title: const Text('Add Reminder'),
        content: const Text('Reminder creation functionality will be implemented here.'),
        actions: <Widget>[
          TextButton(
            child: const Text('OK'),
            onPressed: () => Navigator.of(dialogContext).pop(),
          ),
        ],
      );
    });
}

