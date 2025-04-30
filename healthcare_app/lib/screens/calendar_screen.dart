import 'package:flutter/material.dart';
import 'package:healthcare_app/providers/app_state.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  List<CalendarEvent> _selectedEvents = [];
  String _selectedFilter = 'All'; // Default filter

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
    // Load events for the initially selected day
    _loadEventsForDay(_selectedDay!); 
  }

  void _loadEventsForDay(DateTime day) {
    final appState = Provider.of<AppState>(context, listen: false);
    setState(() {
      _selectedEvents = appState.calendarEvents.where((event) {
        // Check if the event date matches the selected day (ignoring time)
        bool dateMatch = isSameDay(event.date, day);
        // Apply filter
        bool filterMatch = _selectedFilter == 'All' || event.type == _selectedFilter;
        return dateMatch && filterMatch;
      }).toList();
    });
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = focusedDay;
        _loadEventsForDay(selectedDay); // Load events for the new day
      });
    }
  }

  void _onFilterChanged(String? newFilter) {
    if (newFilter != null && newFilter != _selectedFilter) {
      setState(() {
        _selectedFilter = newFilter;
        _loadEventsForDay(_selectedDay!); // Reload events with the new filter
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context); // Listen for changes if needed

    return Scaffold(
      appBar: AppBar(
        title: const Text('Calendar'),
      ),
      body: Column(
        children: [
          TableCalendar<CalendarEvent>(
            firstDay: DateTime.utc(2010, 10, 16),
            lastDay: DateTime.utc(2030, 3, 14),
            focusedDay: _focusedDay,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            calendarFormat: _calendarFormat,
            eventLoader: (day) {
              // Return list of events for the given day to show markers
              return appState.calendarEvents.where((event) => isSameDay(event.date, day)).toList();
            },
            startingDayOfWeek: StartingDayOfWeek.monday,
            calendarStyle: CalendarStyle(
              // Customize UI
              selectedDecoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                shape: BoxShape.circle,
              ),
              todayDecoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withOpacity(0.5),
                shape: BoxShape.circle,
              ),
              markerDecoration: BoxDecoration(
                color: Theme.of(context).colorScheme.secondary,
                shape: BoxShape.circle,
              ),
              outsideDaysVisible: false,
            ),
            headerStyle: const HeaderStyle(
              titleCentered: true,
              formatButtonVisible: false, // Hide format button for simplicity
            ),
            onDaySelected: _onDaySelected,
            onPageChanged: (focusedDay) {
              _focusedDay = focusedDay;
              // Optionally load events for the first day of the new month
              // _onDaySelected(focusedDay, focusedDay);
            },
            // TODO: Add calendar builders for custom markers if needed
          ),
          const SizedBox(height: 8.0),
          // Filter Buttons
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Wrap(
              spacing: 8.0, // gap between adjacent chips
              runSpacing: 4.0, // gap between lines
              children: <Widget>[
                FilterChip(
                  label: const Text('All'),
                  selected: _selectedFilter == 'All',
                  onSelected: (selected) => _onFilterChanged('All'),
                ),
                FilterChip(
                  label: const Text('Medication'),
                  selected: _selectedFilter == 'Medication',
                  onSelected: (selected) => _onFilterChanged('Medication'),
                ),
                FilterChip(
                  label: const Text('Appointments'),
                  selected: _selectedFilter == 'Appointment', // Match event type
                  onSelected: (selected) => _onFilterChanged('Appointment'),
                ),
                 FilterChip(
                  label: const Text('Custom'),
                  selected: _selectedFilter == 'Custom', // Match event type
                  onSelected: (selected) => _onFilterChanged('Custom'),
                ),
              ],
            ),
          ),
          const Divider(),
          // List of events for the selected day
          Expanded(
            child: _selectedEvents.isEmpty
                ? Center(
                    child: Text(
                      'No events found for ${DateFormat.yMMMd().format(_selectedDay!)} with filter "$_selectedFilter".',
                      textAlign: TextAlign.center,
                    ),
                  )
                : ListView.builder(
                    itemCount: _selectedEvents.length,
                    itemBuilder: (context, index) {
                      final event = _selectedEvents[index];
                      return ListTile(
                        title: Text(event.title),
                        subtitle: Text(event.type), // Show event type
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(
                                event.isCompleted ? Icons.check_circle : Icons.radio_button_unchecked,
                                color: event.isCompleted ? Colors.green : Colors.grey,
                              ),
                              tooltip: event.isCompleted ? 'Mark as Not Done' : 'Mark as Done',
                              onPressed: () {
                                // Toggle completion status using Provider
                                appState.toggleCalendarEventCompletion(event.id);
                                // Reload events locally to reflect change immediately
                                _loadEventsForDay(_selectedDay!); 
                              },
                            ),
                            // Removed the 'Not Done' button as toggle is preferred
                          ],
                        ),
                        // Optionally add onTap for event details
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

