import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:healthcare_app/providers/app_state.dart';
import 'package:intl/intl.dart';

class AddHealthIssuePopup extends StatefulWidget {
  const AddHealthIssuePopup({super.key});

  @override
  State<AddHealthIssuePopup> createState() => _AddHealthIssuePopupState();
}

class _AddHealthIssuePopupState extends State<AddHealthIssuePopup> {
  final _formKey = GlobalKey<FormState>();
  final _issueNameController = TextEditingController();
  final _symptomsController = TextEditingController();
  final _medicationsController = TextEditingController();
  final _doctorController = TextEditingController();
  DateTime? _startDate;
  DateTime? _nextFollowUpDate;
  String? _selectedSeverity = 'Mild'; // Default value
  bool _isRecurring = false;

  final List<String> _severityLevels = ['Mild', 'Moderate', 'Severe'];

  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        if (isStartDate) {
          _startDate = picked;
        } else {
          _nextFollowUpDate = picked;
        }
      });
    }
  }

  void _saveIssue() {
    if (_formKey.currentState!.validate()) {
      if (_startDate == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select a start date.')),
        );
        return;
      }
      if (_nextFollowUpDate == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select a next follow-up date.')),
        );
        return;
      }

      final newIssue = HealthIssue(
        // Generate a unique ID (simple approach for prototype)
        id: DateTime.now().millisecondsSinceEpoch.toString(), 
        name: _issueNameController.text,
        startDate: _startDate!,
        severity: _selectedSeverity!,
        status: 'Ongoing', // Default status for new issues
        symptoms: _symptomsController.text,
        medications: _medicationsController.text,
        doctor: _doctorController.text,
        isRecurring: _isRecurring,
        nextFollowUp: _nextFollowUpDate!,
      );

      Provider.of<AppState>(context, listen: false).addHealthIssue(newIssue);
      Navigator.of(context).pop(); // Close the popup
       ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('New health issue added.')),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final dateFormat = DateFormat('MMM d, yyyy');

    return AlertDialog(
      title: Text('Add New Health Issue', style: textTheme.headlineSmall),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TextFormField(
                controller: _issueNameController,
                decoration: const InputDecoration(labelText: 'Issue Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the issue name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      _startDate == null
                          ? 'Select Start Date'
                          : 'Start Date: ${dateFormat.format(_startDate!)}',
                      style: textTheme.bodyMedium,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.calendar_today),
                    onPressed: () => _selectDate(context, true),
                    tooltip: 'Select Start Date',
                  ),
                ],
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedSeverity,
                decoration: const InputDecoration(labelText: 'Severity Level'),
                items: _severityLevels.map((String level) {
                  return DropdownMenuItem<String>(
                    value: level,
                    child: Text(level),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedSeverity = newValue;
                  });
                },
                validator: (value) => value == null ? 'Please select severity' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _symptomsController,
                decoration: const InputDecoration(labelText: 'Symptoms'),
                maxLines: 2,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _medicationsController,
                decoration: const InputDecoration(labelText: 'Medications'),
                 maxLines: 2,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _doctorController,
                decoration: const InputDecoration(labelText: 'Doctor/Clinic'),
              ),
              const SizedBox(height: 16),
              // Upload Files - Placeholder Button
              OutlinedButton.icon(
                icon: const Icon(Icons.upload_file_outlined, size: 18),
                label: const Text('Upload Files (Placeholder)'),
                onPressed: () {
                   ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('File upload not implemented in prototype')),
                  );
                },
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Text('Recurring Issue', style: textTheme.bodyMedium),
                  const Spacer(),
                  Switch(
                    value: _isRecurring,
                    onChanged: (bool value) {
                      setState(() {
                        _isRecurring = value;
                      });
                    },
                    activeColor: theme.primaryColor,
                  ),
                ],
              ),
              const SizedBox(height: 16),
               Row(
                children: [
                  Expanded(
                    child: Text(
                      _nextFollowUpDate == null
                          ? 'Select Next Follow-Up'
                          : 'Next Follow-Up: ${dateFormat.format(_nextFollowUpDate!)}',
                      style: textTheme.bodyMedium,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.calendar_today),
                    onPressed: () => _selectDate(context, false),
                    tooltip: 'Select Next Follow-Up Date',
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: const Text('Cancel'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        ElevatedButton(
          child: const Text('Save Issue'),
          onPressed: _saveIssue,
        ),
      ],
    );
  }

  @override
  void dispose() {
    _issueNameController.dispose();
    _symptomsController.dispose();
    _medicationsController.dispose();
    _doctorController.dispose();
    super.dispose();
  }
}

