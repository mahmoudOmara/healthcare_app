import 'package:flutter/material.dart';
import 'package:healthcare_app/providers/app_state.dart'; // Import AppState
import 'package:healthcare_app/screens/add_health_issue_screen.dart';
import 'package:healthcare_app/screens/health_issue_detail_screen.dart';
import 'package:provider/provider.dart'; // Import Provider

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<HealthIssue> _filteredIssues = [];

  @override
  void initState() {
    super.initState();
    // Initialize filtered list immediately if AppState is available
    // Or use didChangeDependencies for safer context access
    _searchController.addListener(_filterIssues);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Initial filter setup when dependencies change (like Provider)
    _filterIssues(); 
  }


  void _filterIssues() {
    // Access AppState here, ensuring context is valid
    final appState = Provider.of<AppState>(context, listen: false);
    final query = _searchController.text.toLowerCase();
    
    setState(() {
      if (query.isEmpty) {
        _filteredIssues = appState.healthIssues;
      } else {
        _filteredIssues = appState.healthIssues
            .where((issue) =>
                issue.name.toLowerCase().contains(query))
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Use Consumer or Provider.of to listen to changes in AppState
    return Consumer<AppState>(
      builder: (context, appState, child) {
        // Re-filter whenever AppState notifies listeners (e.g., after adding an issue)
        // This might be slightly inefficient, consider optimizing if needed
        final query = _searchController.text.toLowerCase();
         if (query.isEmpty) {
          _filteredIssues = appState.healthIssues;
        } else {
          _filteredIssues = appState.healthIssues
              .where((issue) =>
                  issue.name.toLowerCase().contains(query))
              .toList();
        }

        return Scaffold(
          appBar: AppBar(
            title: const Text('Health Issues'),
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // Search Bar
                Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      labelText: 'Search Issues',
                      hintText: 'Enter issue name...',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: BorderSide(color: Theme.of(context).colorScheme.outline),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: BorderSide(color: Theme.of(context).primaryColor, width: 1.5),
                      ),
                      contentPadding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
                    ),
                  ),
                ),
                // List of Health Issues
                Expanded(
                  child: _filteredIssues.isEmpty
                      ? Center(
                          child: Text(
                          _searchController.text.isEmpty
                              ? 'No health issues added yet.'
                              : 'No issues found matching "${_searchController.text}".',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ))
                      : ListView.builder(
                          itemCount: _filteredIssues.length,
                          itemBuilder: (context, index) {
                            final issue = _filteredIssues[index];
                            return Card(
                              elevation: 1.0,
                              margin: const EdgeInsets.symmetric(vertical: 6.0),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.0)),
                              child: ListTile(
                                title: Text(issue.name, style: Theme.of(context).textTheme.titleMedium),
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
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0, vertical: 2.0),
                                ),
                                onTap: () {
                                  // Navigate to Health Issue Detail View, passing the HealthIssue object
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      // Convert HealthIssue model to Map<String, dynamic> if needed by detail screen
                                      // Or update detail screen to accept HealthIssue object
                                      builder: (context) => HealthIssueDetailScreen(healthIssue: {
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
                          },
                        ),
                ),
              ],
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AddHealthIssueScreen(),
                  fullscreenDialog: true,
                ),
              );

              if (result == true) {
                // No need to manually add here, Consumer rebuilds the list
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('New health issue saved!')),
                );
              }
            },
            tooltip: 'Add New Health Issue',
            child: const Icon(Icons.add),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _searchController.removeListener(_filterIssues);
    _searchController.dispose();
    super.dispose();
  }
}

