import 'package:flutter/material.dart';
import 'package:healthcare_app/providers/app_state.dart';
import 'package:healthcare_app/services/notification_service.dart'; // Import NotificationService
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

// Subscription Management Screen (remains unchanged)
class SubscriptionManagementScreen extends StatefulWidget {
  const SubscriptionManagementScreen({super.key});

  @override
  State<SubscriptionManagementScreen> createState() => _SubscriptionManagementScreenState();
}

class _SubscriptionManagementScreenState extends State<SubscriptionManagementScreen> {
  String? _selectedPlan;

  final Map<String, String> _plans = {
    'Monthly': 'Monthly – 150 EGP',
    'Yearly': 'Yearly – 1500 EGP',
  };

  @override
  void initState() {
    super.initState();
    final appState = Provider.of<AppState>(context, listen: false);
    final currentSubscription = appState.userProfile?.subscription;

    if (currentSubscription != null) {
      _selectedPlan = _plans.entries
          .firstWhere((entry) => entry.value == currentSubscription, 
                      orElse: () => _plans.entries.first)
          .key;
    } else {
      _selectedPlan = _plans.entries.first.key;
    }
  }

  void _updateSubscription(String planKey) {
    final appState = Provider.of<AppState>(context, listen: false);
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
    return Consumer<AppState>(
      builder: (context, appState, child) {
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
                ..._plans.entries.map((entry) {
                  final planKey = entry.key;
                  final planDescription = entry.value;
                  return RadioListTile<String>(
                    title: Text(planDescription),
                    value: planKey,
                    groupValue: _selectedPlan,
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
                const Spacer(),
              ],
            ),
          ),
        );
      },
    );
  }
}

// Convert SettingsScreen to StatefulWidget to manage notification toggle state
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notificationsEnabled = false; // Local state for the toggle
  bool _isLoadingPermissions = false; // To prevent multiple clicks while checking
  final NotificationService _notificationService = NotificationService(); // Get instance

  @override
  void initState() {
    super.initState();
    // Check initial permission status (without requesting)
    // Note: flutter_local_notifications doesn't have a direct 'checkStatus' before request.
    // We'll assume 'false' initially and update after the first request attempt.
    // A more robust solution might involve a dedicated permission handler plugin.
    _notificationsEnabled = _notificationService.notificationPermissionGranted;
  }

  Future<void> _handleNotificationToggle(bool value) async {
    if (_isLoadingPermissions) return; // Prevent rapid toggling

    setState(() {
      _isLoadingPermissions = true;
    });

    bool granted = false;
    if (value) {
      // If toggling on, request permissions
      granted = await _notificationService.requestPermissions();
      if (granted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Notification permissions granted.')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Notification permissions denied.')),
        );
        // Optionally, guide user to app settings if permanently denied
      }
    } else {
      // If toggling off, we can't programmatically revoke permissions.
      // We just update the UI state. User must change in system settings.
      granted = false; // Reflect the toggle state
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Notifications disabled in app. To re-enable, toggle on. To manage system settings, go to App Info.')),
      );
    }

    setState(() {
      _notificationsEnabled = granted; // Update toggle based on actual permission status
      _isLoadingPermissions = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Use Consumer for AppState access
    return Consumer<AppState>(
      builder: (context, appState, child) {
        final userProfile = appState.userProfile;

        if (userProfile == null) {
          return Scaffold(
            appBar: AppBar(title: const Text('Settings')),
            body: const Center(child: CircularProgressIndicator()), // Show loading indicator
          );
        }

        return Scaffold(
          appBar: AppBar(
            title: const Text('Settings'),
          ),
          body: ListView(
            children: <Widget>[
              // User Information Section (unchanged)
              const ListTile(
                title: Text('User Information', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
              ListTile(
                leading: const Icon(Icons.person_outline),
                title: const Text('Name'),
                subtitle: Text(userProfile.name),
              ),
              ListTile(
                leading: const Icon(Icons.cake_outlined),
                title: const Text('Date of Birth'),
                subtitle: Text(DateFormat('yyyy-MM-dd').format(userProfile.dateOfBirth)),
              ),
              ListTile(
                leading: const Icon(Icons.wc_outlined),
                title: const Text('Gender'),
                subtitle: Text(userProfile.gender),
              ),
              const Divider(),

              // Contact Information Section (unchanged)
              const ListTile(
                title: Text('Contact Information', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
              ListTile(
                leading: const Icon(Icons.contact_emergency_outlined),
                title: const Text('Emergency Contact'),
                subtitle: Text(userProfile.emergencyContact),
              ),
              const Divider(),

              // Preferences Section
              const ListTile(
                title: Text('Preferences', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
              // Notification Toggle
              SwitchListTile(
                secondary: const Icon(Icons.notifications_active_outlined),
                title: const Text('Enable Reminders'),
                subtitle: Text(_notificationsEnabled ? 'Reminders are enabled' : 'Reminders are disabled'),
                value: _notificationsEnabled,
                onChanged: _isLoadingPermissions ? null : _handleNotificationToggle, // Disable while loading
                activeColor: Theme.of(context).primaryColor,
              ),
              ListTile(
                leading: const Icon(Icons.medical_services_outlined),
                title: const Text('Preferred Doctor/Clinic'),
                subtitle: Text(userProfile.preferredDoctor),
              ),
              ListTile(
                leading: const Icon(Icons.language_outlined),
                title: const Text('Language'),
                subtitle: Text(userProfile.language),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Language selection not implemented yet.')),
                  );
                },
              ),
              const Divider(),

              // Subscription Section (unchanged)
              const ListTile(
                title: Text('Subscription', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
              ListTile(
                leading: const Icon(Icons.subscriptions_outlined),
                title: const Text('Current Plan'),
                subtitle: Text(userProfile.subscription),
                trailing: ElevatedButton(
                  child: const Text('Manage'),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const SubscriptionManagementScreen()),
                    );
                  },
                ),
              ),
              const Divider(),

              // Logout Button (unchanged)
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: OutlinedButton.icon(
                  icon: const Icon(Icons.logout, color: Colors.red),
                  label: const Text('Logout', style: TextStyle(color: Colors.red)),
                  onPressed: () {
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
                                Navigator.of(dialogContext).pop();
                              },
                            ),
                            TextButton(
                              child: const Text('Logout'),
                              onPressed: () {
                                Navigator.of(dialogContext).pop();
                                Provider.of<AppState>(context, listen: false).signOut();
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

