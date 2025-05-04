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
    // Initialize with the current plan from AppState, handling potential null profile
    final appState = Provider.of<AppState>(context, listen: false);
    final currentSubscription = appState.userProfile?.subscription;

    if (currentSubscription != null) {
      // Find the key ('Monthly' or 'Yearly') corresponding to the current subscription string
      _selectedPlan = _plans.entries
          .firstWhere((entry) => entry.value == currentSubscription, 
                      orElse: () => _plans.entries.first) // Default to first if not found
          .key;
    } else {
      // Default to the first plan if profile or subscription is null
      _selectedPlan = _plans.entries.first.key;
    }
  }

  void _updateSubscription(String planKey) {
    final appState = Provider.of<AppState>(context, listen: false);
    // Ensure userProfile is not null before attempting update
    if (appState.userProfile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('User profile not loaded. Cannot update subscription.')),
      );
      return;
    }

    final newSubscriptionString = _plans[planKey];
    final currentSubscription = appState.userProfile!.subscription;

    if (newSubscriptionString != null && newSubscriptionString != currentSubscription) {
      appState.updateSubscription(newSubscriptionString);
      setState(() {
        _selectedPlan = planKey;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Subscription updated to $newSubscriptionString')),
      );
    } else if (newSubscriptionString == currentSubscription) {
       ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('This is already your current plan.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Use Consumer to rebuild if userProfile changes (though unlikely on this screen)
    return Consumer<AppState>(
      builder: (context, appState, child) {
        // Check if profile exists, disable if not (optional, but safer)
        final bool profileLoaded = appState.userProfile != null;

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
                    // Disable if profile isn't loaded
                    onChanged: profileLoaded ? (String? value) {
                      if (value != null) {
                        _updateSubscription(value);
                      }
                    } : null,
                    activeColor: Theme.of(context).primaryColor,
                  );
                }).toList(),
                if (!profileLoaded)
                  Padding(
                    padding: const EdgeInsets.only(top: 16.0),
                    child: Text(
                      'Loading user profile... Please wait.',
                      style: TextStyle(color: Theme.of(context).hintColor),
                    ),
                  ),
                const Spacer(), // Pushes content to the top
              ],
            ),
          ),
        );
      },
    );
  }
}


class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Use Consumer to listen for changes in AppState, especially userProfile
    return Consumer<AppState>(
      builder: (context, appState, child) {
        final userProfile = appState.userProfile;

        // Handle case where userProfile might still be loading or null
        if (userProfile == null) {
          return Scaffold(
            appBar: AppBar(title: const Text('Settings')),
            body: const Center(child: Text('Loading user profile...')), // Or a loading indicator
          );
        }

        // Profile is loaded, build the settings list
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
                                // Use read to avoid listening in callbacks
                                Provider.of<AppState>(context, listen: false).signOut(); 
                                // Optionally navigate to login screen if not handled automatically by StreamBuilder
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
      },
    );
  }
}

