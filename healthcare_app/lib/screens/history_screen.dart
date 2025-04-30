import 'package:flutter/material.dart';
import 'package:healthcare_app/providers/app_state.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:collection/collection.dart'; // For groupBy

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  // Helper function to get an icon based on log type
  IconData _getIconForLogType(String type) {
    switch (type) {
      case 'Medication':
        return Icons.medication_outlined;
      case 'File Upload':
        return Icons.upload_file_outlined;
      case 'Chat':
        return Icons.chat_bubble_outline;
      case 'Doctor Visit':
        return Icons.medical_services_outlined;
      case 'Reminder':
        return Icons.alarm_outlined;
      default:
        return Icons.history_outlined;
    }
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final historyLogs = appState.historyLogs;

    // Sort logs by date descending
    historyLogs.sort((a, b) => b.date.compareTo(a.date));

    // Group logs by date (ignoring time)
    final groupedLogs = groupBy(historyLogs, (HistoryLog log) => DateFormat('yyyy-MM-dd').format(log.date));

    return Scaffold(
      appBar: AppBar(
        title: const Text('History'),
      ),
      body: groupedLogs.isEmpty
          ? const Center(child: Text('No history logs found.'))
          : ListView.builder(
              padding: const EdgeInsets.all(8.0),
              itemCount: groupedLogs.keys.length,
              itemBuilder: (context, index) {
                final dateString = groupedLogs.keys.elementAt(index);
                final logsForDate = groupedLogs[dateString]!;
                final displayDate = DateFormat('MMMM d, yyyy').format(DateTime.parse(dateString)); // Format for display

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12.0),
                      child: Text(
                        displayDate,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                      ),
                    ),
                    ...logsForDate.map((log) {
                      return Card(
                        elevation: 1.0,
                        margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                        child: ListTile(
                          leading: Icon(_getIconForLogType(log.type), color: Theme.of(context).primaryColor),
                          title: Text(log.title),
                          subtitle: Text(DateFormat('h:mm a').format(log.date)), // Show time
                          // Optionally add onTap for more details if needed
                        ),
                      );
                    }).toList(),
                    const Divider(height: 16.0), // Separator between dates
                  ],
                );
              },
            ),
    );
  }
}

