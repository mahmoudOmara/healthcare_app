import 'package:flutter/material.dart';
import 'package:healthcare_app/providers/app_state.dart'; // Import AppState
import 'package:intl/intl.dart'; // For date formatting
import 'package:provider/provider.dart'; // Import Provider
import 'dart:math'; // For random ID generation

class AddHealthIssueScreen extends StatefulWidget {
  const AddHealthIssueScreen({super.key});

  @override
  State<AddHealthIssueScreen> createState() => _AddHealthIssueScreenState();
}

class _AddHealthIssueScreenState extends State<AddHealthIssueScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _issueNameController = TextEditingController();
  final TextEditingController _symptomsController = TextEditingController();
  final TextEditingController _medicationsController = TextEditingController();
  final TextEditingController _doctorController = TextEditingController();

  DateTime? _startDate;
  String? _selectedSeverity;
  bool _isRecurring = false;
  DateTime? _nextFollowUpDate;

  final List<String> _severityLevels = ['Mild', 'Moderate', 'Severe', 'Critical'];

  Future<void> _selectDate(BuildContext context, {bool isStartDate = true}) async {
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

  @override
  void dispose() {
    _issueNameController.dispose();
    _symptomsController.dispose();
    _medicationsController.dispose();
    _doctorController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Health Issue'),
        leading: IconButton(
          icon: const Icon(Icons.close), // Use close icon for popups/modals
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          TextButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                // Use Provider to access AppState and add the issue
                final appState = Provider.of<AppState>(context, listen: false);
                
                // Create a new HealthIssue object
                final newIssue = HealthIssue(
                  // Generate a simple unique ID (replace with better method if needed)
                  id: DateTime.now().millisecondsSinceEpoch.toString() + Random().nextInt(1000).toString(), 
                  name: _issueNameController.text,
                  startDate: _startDate ?? DateTime.now(), // Default to now if not set
                  severity: _selectedSeverity ?? 'Mild', // Default severity
                  status: 'Ongoing', // Default status
                  symptoms: _symptomsController.text,
                  medications: _medicationsController.text,
                  doctor: _doctorController.text,
                  isRecurring: _isRecurring,
                  nextFollowUp: _nextFollowUpDate ?? DateTime.now().add(const Duration(days: 30)), // Default follow-up
                  // TODO: Add file upload data handling
                );

                appState.addHealthIssue(newIssue);
                print('Saving Health Issue via Provider: ${newIssue.name}');
                
                // Pop the screen and indicate success
                Navigator.of(context).pop(true); 
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
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
              _buildDatePickerField(
                context,
                label: 'Start Date',
                selectedDate: _startDate,
                onTap: () => _selectDate(context, isStartDate: true),
                isRequired: true, // Mark as required for validation feedback
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
                onChanged: (newValue) {
                  setState(() {
                    _selectedSeverity = newValue;
                  });
                },
                validator: (value) => value == null ? 'Please select a severity level' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _symptomsController,
                decoration: const InputDecoration(labelText: 'Symptoms (optional)'),
                maxLines: 3,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _medicationsController,
                decoration: const InputDecoration(labelText: 'Medications (optional)'),
                maxLines: 2,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _doctorController,
                decoration: const InputDecoration(labelText: 'Doctor/Clinic (optional)'),
              ),
              const SizedBox(height: 16),
              // TODO: Implement File Upload UI & Logic
              OutlinedButton.icon(
                icon: const Icon(Icons.upload_file_outlined),
                label: const Text('Upload Files (optional)'),
                onPressed: () {
                  // TODO: Implement file picking logic (e.g., using file_picker package)
                  print('Upload files button pressed');
                   ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('File upload not implemented yet.')),
                  );
                },
              ),
              const SizedBox(height: 16),
              SwitchListTile(
                title: const Text('Recurring Issue'),
                value: _isRecurring,
                onChanged: (bool value) {
                  setState(() {
                    _isRecurring = value;
                  });
                },
                contentPadding: EdgeInsets.zero, // Align with text fields
              ),
              const SizedBox(height: 16),
              _buildDatePickerField(
                context,
                label: 'Next Follow-Up Reminder (optional)',
                selectedDate: _nextFollowUpDate,
                onTap: () => _selectDate(context, isStartDate: false),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDatePickerField(BuildContext context, {required String label, DateTime? selectedDate, required VoidCallback onTap, bool isRequired = false}) {
    // Wrap with FormField for validation integration if needed, especially for required fields
    return FormField<DateTime>(
      initialValue: selectedDate, // Needed if you want FormField to manage the state
      validator: (value) {
        if (isRequired && value == null && selectedDate == null) { // Check if required and not selected
          return 'Please select a date';
        }
        return null;
      },
      builder: (FormFieldState<DateTime> state) {
        return InkWell(
          onTap: () async {
            await onTap(); // Call the original onTap to show date picker
            // Manually update FormField state if needed, or rely on parent setState
            state.didChange(selectedDate); 
          },
          child: InputDecorator(
            decoration: InputDecoration(
              labelText: label,
              suffixIcon: const Icon(Icons.calendar_today_outlined),
              errorText: state.errorText, // Show validation error
            ),
            child: Text(
              selectedDate == null
                  ? 'Select Date'
                  : DateFormat('yyyy-MM-dd').format(selectedDate!),
              style: TextStyle(
                color: selectedDate == null ? Theme.of(context).hintColor : Theme.of(context).textTheme.bodyLarge?.color,
              ),
            ),
          ),
        );
      },
    );
  }
}

