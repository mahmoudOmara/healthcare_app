import 'package:flutter/material.dart';

class AppState extends ChangeNotifier {
  // User authentication state
  bool _isLoggedIn = false;
  
  // Health issues list
  final List<HealthIssue> _healthIssues = [
    HealthIssue(
      id: '1',
      name: 'Hypertension',
      startDate: DateTime(2024, 10, 15),
      severity: 'Moderate',
      status: 'Ongoing',
      symptoms: 'Headaches, dizziness, shortness of breath',
      medications: 'Lisinopril 10mg daily',
      doctor: 'Dr. Sarah Johnson',
      isRecurring: true,
      nextFollowUp: DateTime(2025, 5, 15),
    ),
    HealthIssue(
      id: '2',
      name: 'Diabetes Type 2',
      startDate: DateTime(2023, 6, 10),
      severity: 'Severe',
      status: 'Ongoing',
      symptoms: 'Increased thirst, frequent urination, fatigue',
      medications: 'Metformin 500mg twice daily',
      doctor: 'Dr. Michael Chen',
      isRecurring: true,
      nextFollowUp: DateTime(2025, 5, 5),
    ),
    HealthIssue(
      id: '3',
      name: 'Asthma',
      startDate: DateTime(2020, 3, 22),
      severity: 'Mild',
      status: 'Ongoing',
      symptoms: 'Wheezing, coughing, chest tightness',
      medications: 'Albuterol inhaler as needed',
      doctor: 'Dr. Emily Rodriguez',
      isRecurring: true,
      nextFollowUp: DateTime(2025, 6, 12),
    ),
    HealthIssue(
      id: '4',
      name: 'Migraine',
      startDate: DateTime(2024, 2, 5),
      severity: 'Moderate',
      status: 'Ongoing',
      symptoms: 'Severe headache, nausea, light sensitivity',
      medications: 'Sumatriptan as needed',
      doctor: 'Dr. James Wilson',
      isRecurring: true,
      nextFollowUp: DateTime(2025, 5, 20),
    ),
    HealthIssue(
      id: '5',
      name: 'Allergic Rhinitis',
      startDate: DateTime(2022, 4, 15),
      severity: 'Mild',
      status: 'Seasonal',
      symptoms: 'Sneezing, runny nose, itchy eyes',
      medications: 'Cetirizine 10mg daily during season',
      doctor: 'Dr. Lisa Park',
      isRecurring: true,
      nextFollowUp: DateTime(2025, 7, 10),
    ),
    HealthIssue(
      id: '6',
      name: 'Lower Back Pain',
      startDate: DateTime(2023, 11, 8),
      severity: 'Moderate',
      status: 'Improving',
      symptoms: 'Pain in lower back, stiffness, limited mobility',
      medications: 'Ibuprofen as needed, muscle relaxants',
      doctor: 'Dr. Robert Thompson',
      isRecurring: false,
      nextFollowUp: DateTime(2025, 5, 25),
    ),
    HealthIssue(
      id: '7',
      name: 'Gastroesophageal Reflux Disease',
      startDate: DateTime(2023, 8, 20),
      severity: 'Moderate',
      status: 'Ongoing',
      symptoms: 'Heartburn, regurgitation, chest pain',
      medications: 'Omeprazole 20mg daily',
      doctor: 'Dr. Sophia Martinez',
      isRecurring: true,
      nextFollowUp: DateTime(2025, 6, 5),
    ),
    HealthIssue(
      id: '8',
      name: 'Insomnia',
      startDate: DateTime(2024, 1, 15),
      severity: 'Moderate',
      status: 'Improving',
      symptoms: 'Difficulty falling asleep, daytime fatigue',
      medications: 'Melatonin 5mg before bed',
      doctor: 'Dr. David Kim',
      isRecurring: false,
      nextFollowUp: DateTime(2025, 5, 30),
    ),
    HealthIssue(
      id: '9',
      name: 'Eczema',
      startDate: DateTime(2021, 7, 12),
      severity: 'Mild',
      status: 'Controlled',
      symptoms: 'Dry, itchy, inflamed skin patches',
      medications: 'Hydrocortisone cream as needed',
      doctor: 'Dr. Amanda Lee',
      isRecurring: true,
      nextFollowUp: DateTime(2025, 8, 15),
    ),
    HealthIssue(
      id: '10',
      name: 'Hypothyroidism',
      startDate: DateTime(2022, 9, 5),
      severity: 'Moderate',
      status: 'Ongoing',
      symptoms: 'Fatigue, weight gain, cold intolerance',
      medications: 'Levothyroxine 50mcg daily',
      doctor: 'Dr. Thomas Brown',
      isRecurring: true,
      nextFollowUp: DateTime(2025, 6, 20),
    ),
  ];
  
  // Linked accounts
  final List<LinkedAccount> _linkedAccounts = [
    LinkedAccount(
      id: '1',
      name: 'Mom',
      relationship: 'Mother',
      healthIssues: [
        HealthIssue(
          id: 'm1',
          name: 'Hypertension',
          startDate: DateTime(2020, 5, 10),
          severity: 'Moderate',
          status: 'Ongoing',
          symptoms: 'Occasional headaches',
          medications: 'Amlodipine 5mg daily',
          doctor: 'Dr. Jennifer Adams',
          isRecurring: true,
          nextFollowUp: DateTime(2025, 6, 15),
        ),
      ],
    ),
    LinkedAccount(
      id: '2',
      name: 'Dad',
      relationship: 'Father',
      healthIssues: [
        HealthIssue(
          id: 'd1',
          name: 'Diabetes',
          startDate: DateTime(2018, 3, 22),
          severity: 'Moderate',
          status: 'Ongoing',
          symptoms: 'Fatigue, increased thirst',
          medications: 'Insulin injections, Metformin',
          doctor: 'Dr. Richard Taylor',
          isRecurring: true,
          nextFollowUp: DateTime(2025, 5, 10),
        ),
      ],
    ),
    LinkedAccount(
      id: '3',
      name: 'Ahmed',
      relationship: 'Brother',
      healthIssues: [
        HealthIssue(
          id: 'a1',
          name: 'Allergy',
          startDate: DateTime(2023, 4, 15),
          severity: 'Mild',
          status: 'Seasonal',
          symptoms: 'Sneezing, itchy eyes',
          medications: 'Loratadine 10mg as needed',
          doctor: 'Dr. Sarah Johnson',
          isRecurring: true,
          nextFollowUp: DateTime(2025, 7, 5),
        ),
      ],
    ),
  ];
  
  // Calendar events
  final List<CalendarEvent> _calendarEvents = [
    CalendarEvent(
      id: '1',
      title: 'Take Blood Pressure Medication',
      date: DateTime.now().add(const Duration(days: 3)),
      type: 'Medication',
      isCompleted: false,
    ),
    CalendarEvent(
      id: '2',
      title: 'Dr. Johnson Appointment',
      date: DateTime.now().add(const Duration(days: 5)),
      type: 'Appointment',
      isCompleted: false,
    ),
    CalendarEvent(
      id: '3',
      title: 'Blood Test',
      date: DateTime.now().add(const Duration(days: 7)),
      type: 'Custom',
      isCompleted: false,
    ),
  ];
  
  // History logs
  final List<HistoryLog> _historyLogs = [
    HistoryLog(
      id: '1',
      title: 'Took Blood Pressure Medication',
      date: DateTime.now().subtract(const Duration(days: 1)),
      type: 'Medication',
    ),
    HistoryLog(
      id: '2',
      title: 'Uploaded Blood Test Results',
      date: DateTime.now().subtract(const Duration(days: 2)),
      type: 'File Upload',
    ),
    HistoryLog(
      id: '3',
      title: 'Chat with Support Agent',
      date: DateTime.now().subtract(const Duration(days: 3)),
      type: 'Chat',
    ),
    HistoryLog(
      id: '4',
      title: 'Dr. Wilson Appointment',
      date: DateTime.now().subtract(const Duration(days: 5)),
      type: 'Doctor Visit',
    ),
    HistoryLog(
      id: '5',
      title: 'Set Medication Reminder',
      date: DateTime.now().subtract(const Duration(days: 7)),
      type: 'Reminder',
    ),
  ];
  
  // User profile
  final UserProfile _userProfile = UserProfile(
    name: 'Alex Johnson',
    dateOfBirth: DateTime(1985, 5, 15),
    gender: 'Male',
    emergencyContact: 'Sarah Johnson (Wife) - +1 234 567 8901',
    preferredDoctor: 'Dr. Michael Chen',
    language: 'English',
    subscription: 'Monthly – 150 EGP',
  );
  
  // Getters
  bool get isLoggedIn => _isLoggedIn;
  List<HealthIssue> get healthIssues => _healthIssues;
  List<LinkedAccount> get linkedAccounts => _linkedAccounts;
  List<CalendarEvent> get calendarEvents => _calendarEvents;
  List<HistoryLog> get historyLogs => _historyLogs;
  UserProfile get userProfile => _userProfile;
  
  // Methods
  void login() {
    _isLoggedIn = true;
    notifyListeners();
  }
  
  void logout() {
    _isLoggedIn = false;
    notifyListeners();
  }
  
  void addHealthIssue(HealthIssue issue) {
    _healthIssues.add(issue);
    notifyListeners();
  }
  
  void updateHealthIssue(HealthIssue updatedIssue) {
    final index = _healthIssues.indexWhere((issue) => issue.id == updatedIssue.id);
    if (index != -1) {
      _healthIssues[index] = updatedIssue;
      notifyListeners();
    }
  }
  
  void toggleCalendarEventCompletion(String id) {
    final index = _calendarEvents.indexWhere((event) => event.id == id);
    if (index != -1) {
      _calendarEvents[index] = _calendarEvents[index].copyWith(
        isCompleted: !_calendarEvents[index].isCompleted,
      );
      notifyListeners();
    }
  }
  
  void addHistoryLog(HistoryLog log) {
    _historyLogs.add(log);
    notifyListeners();
  }
  
  void updateSubscription(String subscription) {
    _userProfile.subscription = subscription;
    notifyListeners();
  }
}

// Models
class HealthIssue {
  final String id;
  final String name;
  final DateTime startDate;
  final String severity;
  final String status;
  final String symptoms;
  final String medications;
  final String doctor;
  final bool isRecurring;
  final DateTime nextFollowUp;
  
  HealthIssue({
    required this.id,
    required this.name,
    required this.startDate,
    required this.severity,
    required this.status,
    required this.symptoms,
    required this.medications,
    required this.doctor,
    required this.isRecurring,
    required this.nextFollowUp,
  });
  
  HealthIssue copyWith({
    String? id,
    String? name,
    DateTime? startDate,
    String? severity,
    String? status,
    String? symptoms,
    String? medications,
    String? doctor,
    bool? isRecurring,
    DateTime? nextFollowUp,
  }) {
    return HealthIssue(
      id: id ?? this.id,
      name: name ?? this.name,
      startDate: startDate ?? this.startDate,
      severity: severity ?? this.severity,
      status: status ?? this.status,
      symptoms: symptoms ?? this.symptoms,
      medications: medications ?? this.medications,
      doctor: doctor ?? this.doctor,
      isRecurring: isRecurring ?? this.isRecurring,
      nextFollowUp: nextFollowUp ?? this.nextFollowUp,
    );
  }
}

class LinkedAccount {
  final String id;
  final String name;
  final String relationship;
  final List<HealthIssue> healthIssues;
  
  LinkedAccount({
    required this.id,
    required this.name,
    required this.relationship,
    required this.healthIssues,
  });
}

class CalendarEvent {
  final String id;
  final String title;
  final DateTime date;
  final String type;
  final bool isCompleted;
  
  CalendarEvent({
    required this.id,
    required this.title,
    required this.date,
    required this.type,
    required this.isCompleted,
  });
  
  CalendarEvent copyWith({
    String? id,
    String? title,
    DateTime? date,
    String? type,
    bool? isCompleted,
  }) {
    return CalendarEvent(
      id: id ?? this.id,
      title: title ?? this.title,
      date: date ?? this.date,
      type: type ?? this.type,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}

class HistoryLog {
  final String id;
  final String title;
  final DateTime date;
  final String type;
  
  HistoryLog({
    required this.id,
    required this.title,
    required this.date,
    required this.type,
  });
}

class UserProfile {
  final String name;
  final DateTime dateOfBirth;
  final String gender;
  final String emergencyContact;
  final String preferredDoctor;
  final String language;
  String subscription;
  
  UserProfile({
    required this.name,
    required this.dateOfBirth,
    required this.gender,
    required this.emergencyContact,
    required this.preferredDoctor,
    required this.language,
    required this.subscription,
  });
}
