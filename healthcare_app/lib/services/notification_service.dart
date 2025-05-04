import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tz;
import 'dart:io' show Platform;

class NotificationService {
  static final NotificationService _notificationService = NotificationService._internal();

  factory NotificationService() {
    return _notificationService;
  }

  NotificationService._internal();

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  bool _permissionsRequested = false; // Flag to avoid multiple requests
  bool _notificationPermissionGranted = false;

  bool get notificationPermissionGranted => _notificationPermissionGranted;

  Future<void> init() async {
    // Initialize timezone database
    tz.initializeTimeZones();
    // TODO: Get the local timezone dynamically if possible/needed
    // tz.setLocalLocation(tz.getLocation('Africa/Cairo')); // Example: Set local timezone

    // Android initialization settings
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher'); // Use default app icon

    // iOS initialization settings
    const DarwinInitializationSettings initializationSettingsIOS = DarwinInitializationSettings(
      requestAlertPermission: false, // Request permissions explicitly later
      requestBadgePermission: false,
      requestSoundPermission: false,
      // onDidReceiveLocalNotification: onDidReceiveLocalNotification, // Optional callback
    );

    // Combine settings
    const InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    // Initialize the plugin
    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      // onDidReceiveNotificationResponse: onDidReceiveNotificationResponse, // Optional callback for notification tap
    );

    // Don't request permissions automatically on init. Request them explicitly when needed.
    // await requestPermissions(); // Moved out of init
  }

  // Method to explicitly request permissions when needed (e.g., from settings screen)
  Future<bool> requestPermissions() async {
    if (_permissionsRequested) {
      // Optional: Check current status again if needed, but avoid re-requesting aggressively
      print("NotificationService: Permissions already requested.");
      return _notificationPermissionGranted;
    }

    bool? result = false;
    if (Platform.isAndroid) {
      final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
          flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>();
      
      // Request notification permission (Android 13+)
      result = await androidImplementation?.requestNotificationsPermission();
      print("NotificationService: Android notification permission result: $result");

      // Request exact alarm permission (optional, handle separately if needed)
      // await androidImplementation?.requestExactAlarmsPermission();
      // print("NotificationService: Android exact alarm permission requested.");

    } else if (Platform.isIOS) {
      result = await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(
            alert: true,
            badge: true,
            sound: true,
          );
      print("NotificationService: iOS permission result: $result");
    }

    _permissionsRequested = true;
    _notificationPermissionGranted = result ?? false;
    return _notificationPermissionGranted;
  }


  // --- Scheduling Methods --- 

  Future<void> scheduleNotification(
      {required int id,
      required String title,
      required String body,
      required DateTime scheduledDate}) async {
    
    // Ensure the date is in the future
    if (scheduledDate.isBefore(DateTime.now())) {
      print('NotificationService: Scheduled date must be in the future.');
      return;
    }
    
    // Optional: Check if permissions are granted before scheduling
    // if (!_notificationPermissionGranted) {
    //   print('NotificationService: Notification permission not granted. Cannot schedule.');
    //   // Optionally, trigger requestPermissions() here or guide user to settings
    //   return; 
    // }

    try {
      await flutterLocalNotificationsPlugin.zonedSchedule(
        id,
        title,
        body,
        tz.TZDateTime.from(scheduledDate, tz.local), // Use local timezone
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'healthcare_app_channel_id', // Channel ID
            'Healthcare Reminders', // Channel Name
            channelDescription: 'Channel for medication and appointment reminders',
            importance: Importance.max,
            priority: Priority.high,
            icon: '@mipmap/ic_launcher', // Use default app icon
          ),
          iOS: DarwinNotificationDetails(
            presentAlert: true,
            presentBadge: true,
            presentSound: true,
          ),
        ),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
        // matchDateTimeComponents: DateTimeComponents.time, // Match time for daily recurrence if needed, or remove for one-time
      );
      print('NotificationService: Scheduled notification $id for $scheduledDate');
    } catch (e) {
       print('NotificationService: Error scheduling notification $id: $e');
    }
  }

  Future<void> cancelNotification(int id) async {
    await flutterLocalNotificationsPlugin.cancel(id);
     print('NotificationService: Canceled notification $id');
  }

  Future<void> cancelAllNotifications() async {
    await flutterLocalNotificationsPlugin.cancelAll();
     print('NotificationService: Canceled all notifications');
  }

}

