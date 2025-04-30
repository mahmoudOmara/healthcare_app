import 'package:flutter/material.dart';
import 'package:healthcare_app/providers/app_state.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

// Subscription Management Screen
class SubscriptionManagementScreen extends StatefulWidget {
  const SubscriptionManagementScreen({super.key});

  @override
  State<SubscriptionManagementScreen> createState() => _SubscriptionManagementScreenState();
}

class _SubscriptionManagementScreenState extends State<SubscriptionManagementScreen> {
  String? _selectedPlan;

  // Define plan details
  final Map<String, String> _plans = {
    'Monthly': 'Monthly – 150 EGP',
    'Yearly': 'Yearly – 1500 EGP', // Assuming yearly cost
  };

  @override
  void initState() {
    super.initState();
    // Initialize with the current plan from AppState
    final appState = Provider.of<AppState>(context, listen: false);
    // Find the key ('Monthly' or 'Yearly') corresponding to the current subscription string
    _selectedPlan = _plans.entries
        .firstWhere((entry) => entry.value == appState.userProfile.subscription, orElse: () => _plans.entries.first)
        .key;
  }

  void _updateSubscription(String planKey) {
    final appState = Provider.of<AppState>(context, listen: false);
    final newSubscriptionString = _plans[planKey];
    if (newSubscriptionString != null && newSubscriptionString != appState.userProfile.subscription) {
      appState.updateSubscription(newSubscriptionString);
      setState(() {
        _selectedPlan = planKey;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Subscription updated to $newSubscriptionString')),
      );
    } else if (newSubscriptionString == appState.userProfile.subscription) {
       ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('This is already your current plan.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Manage Subscription')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Select Your Plan',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 20),
            // Use RadioListTile for plan selection
            ..._plans.entries.map((entry) {
              final planKey = entry.key;
              final planDescription = entry.value;
              return RadioListTile<String>(
                title: Text(planDescription),
                value: planKey,
                groupValue: _selectedPlan,
                onChanged: (String? value) {
                  if (value != null) {
                    _updateSubscription(value);
                  }
                },
                activeColor: Theme.of(context).primaryColor,
              );
            }).toList(),
            const Spacer(), // Pushes the button to the bottom
            // Display current selection (optional)
            // Center(child: Text('Current selection: ${_plans[_selectedPlan]}')),
            // const SizedBox(height: 20),
            // Save button (optional, as selection updates instantly)
            // ElevatedButton(
            //   child: Text('Confirm Change'),
            //   onPressed: _selectedPlan == null ? null : () {
            //     // Logic already handled in onChanged
            //     Navigator.pop(context); // Go back to settings
            //   },
            // ),
          ],
        ),
      ),
    );
  }
}


class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final userProfile = appState.userProfile;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        children: <Widget>[
          // User Information Section
          const ListTile(
            title: Text('User Information', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          ListTile(
            leading: const Icon(Icons.person_outline),
            title: const Text('Name'),
            subtitle: Text(userProfile.name),
            // TODO: Add onTap to edit if required
          ),
          ListTile(
            leading: const Icon(Icons.cake_outlined),
            title: const Text('Date of Birth'),
            subtitle: Text(DateFormat('yyyy-MM-dd').format(userProfile.dateOfBirth)),
            // TODO: Add onTap to edit if required
          ),
          ListTile(
            leading: const Icon(Icons.wc_outlined),
            title: const Text('Gender'),
            subtitle: Text(userProfile.gender),
            // TODO: Add onTap to edit if required
          ),
          const Divider(),

          // Contact Information Section
          const ListTile(
            title: Text('Contact Information', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          ListTile(
            leading: const Icon(Icons.contact_emergency_outlined),
            title: const Text('Emergency Contact'),
            subtitle: Text(userProfile.emergencyContact),
            // TODO: Add onTap to edit if required
          ),
          const Divider(),

          // Preferences Section
          const ListTile(
            title: Text('Preferences', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          ListTile(
            leading: const Icon(Icons.medical_services_outlined),
            title: const Text('Preferred Doctor/Clinic'),
            subtitle: Text(userProfile.preferredDoctor),
            // TODO: Add onTap to edit if required
          ),
          ListTile(
            leading: const Icon(Icons.language_outlined),
            title: const Text('Language'),
            subtitle: Text(userProfile.language),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              // TODO: Implement language selection dialog/screen
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Language selection not implemented yet.')),
              );
            },
          ),
          const Divider(),

          // Subscription Section
          const ListTile(
            title: Text('Subscription', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          ListTile(
            leading: const Icon(Icons.subscriptions_outlined),
            title: const Text('Current Plan'),
            subtitle: Text(userProfile.subscription), // This will update automatically due to Provider
            trailing: ElevatedButton(
              child: const Text('Manage'),
              onPressed: () {
                // Navigate to Subscription Management Screen
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SubscriptionManagementScreen()),
                );
              },
            ),
          ),
          const Divider(),

          // Logout Button
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: OutlinedButton.icon(
              icon: const Icon(Icons.logout, color: Colors.red),
              label: const Text('Logout', style: TextStyle(color: Colors.red)),
              onPressed: () {
                // Show confirmation dialog before logging out
                showDialog(
                  context: context,
                  builder: (BuildContext dialogContext) {
                    return AlertDialog(
                      title: const Text('Confirm Logout'),
                      content: const Text('Are you sure you want to log out?'),
                      actions: <Widget>[
                        TextButton(
                          child: const Text('Cancel'),
                          onPressed: () {
                            Navigator.of(dialogContext).pop(); // Close the dialog
                          },
                        ),
                        TextButton(
                          child: const Text('Logout'),
                          onPressed: () {
                            Navigator.of(dialogContext).pop(); // Close the dialog
                            appState.logout(); // Call logout method from AppState
                            // Optionally navigate to login screen if not handled automatically
                            // Navigator.of(context).pushNamedAndRemoveUntil('/login', (Route<dynamic> route) => false);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Logged out successfully!')),
                            );
                          },
                        ),
                      ],
                    );
                  },
                );
              },
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Colors.red),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

