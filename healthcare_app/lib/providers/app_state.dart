import 'dart:async';
import 'package:flutter/material.dart';
import 'package:healthcare_app/services/mock/mock_auth_service.dart'; // Import Mock Auth
import 'package:healthcare_app/services/mock/mock_firestore_service.dart'; // Import Mock Firestore
import 'package:collection/collection.dart'; // Import for firstWhereOrNull

class AppState extends ChangeNotifier {
  final MockAuthService _authService;
  final MockFirestoreService _firestoreService;
  StreamSubscription<MockUser?>? _authStateSubscription;

  // User authentication state
  MockUser? _currentUser;
  bool _isLoadingData = false;

  // Data lists (will be fetched from mock firestore)
  List<HealthIssue> _healthIssues = [];
  List<LinkedAccount> _linkedAccounts = [];
  List<CalendarEvent> _calendarEvents = [];
  List<HistoryLog> _historyLogs = [];
  UserProfile? _userProfile;

  AppState(this._authService, this._firestoreService) {
    // Listen to authentication state changes from the mock service
    _authStateSubscription = _authService.authStateChanges.listen((user) {
      _currentUser = user;
      if (_currentUser != null) {
        print('AppState: User logged in (mock): ${_currentUser!.uid}');
        _fetchInitialData(); // Fetch data when user logs in
      } else {
        print('AppState: User logged out (mock)');
        _clearData(); // Clear data when user logs out
      }
      notifyListeners(); // Notify listeners about auth state change
    });
  }

  // Getters
  bool get isLoggedIn => _currentUser != null;
  MockUser? get currentUser => _currentUser;
  bool get isLoadingData => _isLoadingData;
  List<HealthIssue> get healthIssues => _healthIssues;
  List<LinkedAccount> get linkedAccounts => _linkedAccounts;
  List<CalendarEvent> get calendarEvents => _calendarEvents;
  List<HistoryLog> get historyLogs => _historyLogs;
  UserProfile? get userProfile => _userProfile;

  // --- Data Fetching ---
  Future<void> _fetchInitialData() async {
    if (_currentUser == null) return;
    print("AppState: Starting _fetchInitialData..."); // DEBUG
    _isLoadingData = true;
    notifyListeners();

    try {
      print("AppState: Calling Future.wait..."); // DEBUG
      await Future.wait([
        _fetchHealthIssues(),
        _fetchCalendarEvents(),
        _fetchHistoryLogs(),
        _fetchLinkedAccounts(),
        _fetchUserProfile(), // Fetch user profile data
      ]);
      print("AppState: Future.wait completed."); // DEBUG
    } catch (e) {
      print("Error fetching initial data: $e");
      // Handle error appropriately, maybe show a message to the user
    } finally {
      print("AppState: Setting isLoadingData = false."); // DEBUG
      _isLoadingData = false;
      notifyListeners();
    }
  }

  Future<void> _fetchHealthIssues() async {
    if (_currentUser == null) return;
    try {
      final snapshot = await _firestoreService
          .collection('users')
          .doc(_currentUser!.uid)
          .collection('healthIssues')
          .get();
      _healthIssues = snapshot.docs
          .map((doc) => HealthIssue.fromMap(doc.id, doc.data()!))
          .toList();
      print("Fetched ${_healthIssues.length} health issues.");
    } catch (e) {
      print("Error fetching health issues: $e");
      _healthIssues = []; // Clear list on error
    }
  }

  Future<void> _fetchCalendarEvents() async {
    if (_currentUser == null) return;
    try {
      final snapshot = await _firestoreService
          .collection('users')
          .doc(_currentUser!.uid)
          .collection('calendarEvents')
          .get();
      _calendarEvents = snapshot.docs
          .map((doc) => CalendarEvent.fromMap(doc.id, doc.data()!))
          .toList();
      print("Fetched ${_calendarEvents.length} calendar events.");
    } catch (e) {
      print("Error fetching calendar events: $e");
      _calendarEvents = []; // Clear list on error
    }
  }

  Future<void> _fetchHistoryLogs() async {
    if (_currentUser == null) return;
    try {
      final snapshot = await _firestoreService
          .collection('users')
          .doc(_currentUser!.uid)
          .collection('historyLogs')
          .get();
      _historyLogs = snapshot.docs
          .map((doc) => HistoryLog.fromMap(doc.id, doc.data()!))
          .toList();
      _historyLogs.sort((a, b) => b.date.compareTo(a.date)); // Sort by date descending
      print("Fetched ${_historyLogs.length} history logs.");
    } catch (e) {
      print("Error fetching history logs: $e");
      _historyLogs = []; // Clear list on error
    }
  }

  Future<void> _fetchLinkedAccounts() async {
    if (_currentUser == null) return;
    try {
      final snapshot = await _firestoreService
          .collection('users')
          .doc(_currentUser!.uid)
          .collection('linkedAccounts')
          .get();
      _linkedAccounts = snapshot.docs
          .map((doc) => LinkedAccount.fromMap(doc.id, doc.data()!))
          .toList();
      print("Fetched ${_linkedAccounts.length} linked accounts.");
    } catch (e) {
      print("Error fetching linked accounts: $e");
      _linkedAccounts = []; // Clear list on error
    }
  }

  // Fetch User Profile Data
  Future<void> _fetchUserProfile() async {
     if (_currentUser == null) return;
     print("AppState: Fetching user profile..."); // DEBUG
     try {
       // Get the user document itself, assuming profile data is stored there
       final doc = await _firestoreService.collection('users').doc(_currentUser!.uid).get();
       if (doc.exists && doc.data() != null) {
          _userProfile = UserProfile.fromMap(doc.data()!); 
          print("AppState: User profile fetched: ${_userProfile?.name}");
       } else {
          // If the user document doesn't exist or has no data, create a default profile
          print("AppState: User profile document not found for ${_currentUser!.uid}. Creating default.");
          _userProfile = UserProfile(
             name: "Mock User",
             dateOfBirth: DateTime(1990, 1, 1),
             gender: "Other",
             emergencyContact: "N/A",
             preferredDoctor: "N/A",
             language: "English",
             subscription: "Monthly – 150 EGP" // Default plan
          );
          // Optionally save this default profile back to mock Firestore
          // This assumes the user doc should exist after login, even if empty initially
          await _firestoreService.collection('users').doc(_currentUser!.uid).set(_userProfile!.toMap());
          print("AppState: Saved default user profile.");
       }
     } catch (e) {
       print("Error fetching user profile: $e");
       _userProfile = null; // Clear profile on error
     }
     print("AppState: Finished fetching user profile."); // DEBUG
   }


  void _clearData() {
    _healthIssues = [];
    _linkedAccounts = [];
    _calendarEvents = [];
    _historyLogs = [];
    _userProfile = null;
    // No notifyListeners here, handled by auth listener
  }

  // --- Health Issue CRUD (Unchanged) ---
  Future<void> addHealthIssue(HealthIssue issue) async {
    if (_currentUser == null) return;
    try {
      final data = issue.toMap();
      final docRef = await _firestoreService
          .collection('users')
          .doc(_currentUser!.uid)
          .collection('healthIssues')
          .add(data);
      _healthIssues.add(issue.copyWith(id: docRef.id));
      notifyListeners();
      print("Added health issue: ${docRef.id}");
    } catch (e) {
      print("Error adding health issue: $e");
    }
  }

  Future<void> updateHealthIssue(HealthIssue updatedIssue) async {
    if (_currentUser == null) return;
    try {
      final data = updatedIssue.toMap();
      await _firestoreService
          .collection('users')
          .doc(_currentUser!.uid)
          .collection('healthIssues')
          .doc(updatedIssue.id)
          .update(data);
      final index = _healthIssues.indexWhere((issue) => issue.id == updatedIssue.id);
      if (index != -1) {
        _healthIssues[index] = updatedIssue;
        notifyListeners();
        print("Updated health issue: ${updatedIssue.id}");
      }
    } catch (e) {
      print("Error updating health issue: $e");
    }
  }

  Future<void> deleteHealthIssue(String issueId) async {
    if (_currentUser == null) return;
    try {
      await _firestoreService
          .collection('users')
          .doc(_currentUser!.uid)
          .collection('healthIssues')
          .doc(issueId)
          .delete();
      _healthIssues.removeWhere((issue) => issue.id == issueId);
      notifyListeners();
      print("Deleted health issue: $issueId");
    } catch (e) {
      print("Error deleting health issue: $e");
    }
  }

  // --- Calendar Event CRUD (Unchanged) ---
  Future<void> addCalendarEvent(CalendarEvent event) async {
     if (_currentUser == null) return;
     try {
       final data = event.toMap();
       final docRef = await _firestoreService
           .collection('users')
           .doc(_currentUser!.uid)
           .collection('calendarEvents')
           .add(data);
       _calendarEvents.add(event.copyWith(id: docRef.id));
       notifyListeners();
       print("Added calendar event: ${docRef.id}");
     } catch (e) {
       print("Error adding calendar event: $e");
     }
   }

  Future<void> toggleCalendarEventCompletion(String id) async {
    if (_currentUser == null) return;
    final index = _calendarEvents.indexWhere((event) => event.id == id);
    if (index != -1) {
      final event = _calendarEvents[index];
      final updatedEvent = event.copyWith(isCompleted: !event.isCompleted);
      try {
        await _firestoreService
            .collection('users')
            .doc(_currentUser!.uid)
            .collection('calendarEvents')
            .doc(id)
            .update({'isCompleted': updatedEvent.isCompleted});
        _calendarEvents[index] = updatedEvent;
        notifyListeners();
        print("Toggled calendar event completion: $id");
      } catch (e) {
        print("Error toggling calendar event completion: $e");
      }
    }
  }

  // --- History Log (Unchanged) ---
  Future<void> addHistoryLog(HistoryLog log) async {
    if (_currentUser == null) return;
    try {
      final data = log.toMap();
      final docRef = await _firestoreService
          .collection('users')
          .doc(_currentUser!.uid)
          .collection('historyLogs')
          .add(data);
      // Insert at beginning and re-sort to maintain order
      _historyLogs.insert(0, log.copyWith(id: docRef.id)); 
      _historyLogs.sort((a, b) => b.date.compareTo(a.date));
      notifyListeners();
      print("Added history log: ${docRef.id}");
    } catch (e) {
      print("Error adding history log: $e");
    }
  }

  // --- Linked Account CRUD (Unchanged) ---
  Future<void> addLinkedAccount(LinkedAccount account) async {
    if (_currentUser == null) return;
    try {
      final data = account.toMap();
      final docRef = await _firestoreService
          .collection('users')
          .doc(_currentUser!.uid)
          .collection('linkedAccounts')
          .add(data);
      _linkedAccounts.add(account.copyWith(id: docRef.id));
      notifyListeners();
      print("Added linked account: ${docRef.id}");
    } catch (e) {
      print("Error adding linked account: $e");
    }
  }

  Future<void> updateLinkedAccount(LinkedAccount updatedAccount) async {
    if (_currentUser == null) return;
    try {
      final data = updatedAccount.toMap();
      await _firestoreService
          .collection('users')
          .doc(_currentUser!.uid)
          .collection('linkedAccounts')
          .doc(updatedAccount.id)
          .update(data);
      final index = _linkedAccounts.indexWhere((acc) => acc.id == updatedAccount.id);
      if (index != -1) {
        _linkedAccounts[index] = updatedAccount;
        notifyListeners();
        print("Updated linked account: ${updatedAccount.id}");
      }
    } catch (e) {
      print("Error updating linked account: $e");
    }
  }

  Future<void> deleteLinkedAccount(String accountId) async {
    if (_currentUser == null) return;
    try {
      await _firestoreService
          .collection('users')
          .doc(_currentUser!.uid)
          .collection('linkedAccounts')
          .doc(accountId)
          .delete();
      _linkedAccounts.removeWhere((acc) => acc.id == accountId);
      notifyListeners();
      print("Deleted linked account: $accountId");
    } catch (e) {
      print("Error deleting linked account: $e");
    }
  }

  // --- Other Methods ---
  Future<void> signOut() async {
    await _authService.signOut();
  }

  // Update Subscription - Now updates profile in mock Firestore
  Future<void> updateSubscription(String subscription) async {
    if (_userProfile != null && _currentUser != null) {
      _userProfile!.subscription = subscription;
      try {
        // Update the user document in mock Firestore
        await _firestoreService
            .collection('users')
            .doc(_currentUser!.uid)
            .update({'subscription': subscription});
        print("AppState: Updated subscription in mock Firestore for ${_currentUser!.uid}");
        notifyListeners();
      } catch (e) {
         print("Error updating subscription in mock Firestore: $e");
      }
    } else {
       print("AppState: Cannot update subscription - user profile or current user is null.");
    }
  }

  @override
  void dispose() {
    _authStateSubscription?.cancel();
    super.dispose();
  }
}

// --- Models ---

// UserProfile Model
class UserProfile {
  String name;
  DateTime dateOfBirth;
  String gender;
  String emergencyContact;
  String preferredDoctor;
  String language;
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

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'dateOfBirth': dateOfBirth.toIso8601String(),
      'gender': gender,
      'emergencyContact': emergencyContact,
      'preferredDoctor': preferredDoctor,
      'language': language,
      'subscription': subscription,
    };
  }

  factory UserProfile.fromMap(Map<String, dynamic> map) {
    return UserProfile(
      name: map['name'] ?? 'Unknown Name',
      dateOfBirth: DateTime.tryParse(map['dateOfBirth'] ?? '') ?? DateTime.now(),
      gender: map['gender'] ?? 'Unknown',
      emergencyContact: map['emergencyContact'] ?? 'N/A',
      preferredDoctor: map['preferredDoctor'] ?? 'N/A',
      language: map['language'] ?? 'English',
      subscription: map['subscription'] ?? 'None', // Default if missing
    );
  }
}

// HealthIssue Model (Unchanged)
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

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'startDate': startDate.toIso8601String(),
      'severity': severity,
      'status': status,
      'symptoms': symptoms,
      'medications': medications,
      'doctor': doctor,
      'isRecurring': isRecurring,
      'nextFollowUp': nextFollowUp.toIso8601String(),
    };
  }

  factory HealthIssue.fromMap(String id, Map<String, dynamic> map) {
    return HealthIssue(
      id: id,
      name: map['name'] ?? '',
      startDate: DateTime.tryParse(map['startDate'] ?? '') ?? DateTime.now(),
      severity: map['severity'] ?? '',
      status: map['status'] ?? '',
      symptoms: map['symptoms'] ?? '',
      medications: map['medications'] ?? '',
      doctor: map['doctor'] ?? '',
      isRecurring: map['isRecurring'] ?? false,
      nextFollowUp: DateTime.tryParse(map['nextFollowUp'] ?? '') ?? DateTime.now(),
    );
  }

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

// CalendarEvent Model (Unchanged)
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

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'date': date.toIso8601String(),
      'type': type,
      'isCompleted': isCompleted,
    };
  }

  factory CalendarEvent.fromMap(String id, Map<String, dynamic> map) {
    return CalendarEvent(
      id: id,
      title: map['title'] ?? '',
      date: DateTime.tryParse(map['date'] ?? '') ?? DateTime.now(),
      type: map['type'] ?? '',
      isCompleted: map['isCompleted'] ?? false,
    );
  }

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

// HistoryLog Model (Unchanged)
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

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'date': date.toIso8601String(),
      'type': type,
    };
  }

  factory HistoryLog.fromMap(String id, Map<String, dynamic> map) {
    return HistoryLog(
      id: id,
      title: map['title'] ?? '',
      date: DateTime.tryParse(map['date'] ?? '') ?? DateTime.now(),
      type: map['type'] ?? '',
    );
  }

   HistoryLog copyWith({
    String? id,
    String? title,
    DateTime? date,
    String? type,
  }) {
    return HistoryLog(
      id: id ?? this.id,
      title: title ?? this.title,
      date: date ?? this.date,
      type: type ?? this.type,
    );
  }
}

// LinkedAccount Model (Unchanged)
class LinkedAccount {
  final String id;
  final String name;
  final String relationship;
  final List<String> healthIssueIds; // Store IDs

  LinkedAccount({
    required this.id,
    required this.name,
    required this.relationship,
    required this.healthIssueIds,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'relationship': relationship,
      'healthIssueIds': healthIssueIds,
    };
  }

  factory LinkedAccount.fromMap(String id, Map<String, dynamic> map) {
    // Ensure healthIssueIds is parsed correctly as List<String>
    List<String> ids = [];
    if (map['healthIssueIds'] is List) {
      ids = List<String>.from(map['healthIssueIds'].map((item) => item.toString()));
    }
    
    return LinkedAccount(
      id: id,
      name: map['name'] ?? '',
      relationship: map['relationship'] ?? '',
      healthIssueIds: ids,
    );
  }

  LinkedAccount copyWith({
    String? id,
    String? name,
    String? relationship,
    List<String>? healthIssueIds,
  }) {
    return LinkedAccount(
      id: id ?? this.id,
      name: name ?? this.name,
      relationship: relationship ?? this.relationship,
      healthIssueIds: healthIssueIds ?? this.healthIssueIds,
    );
  }
}

