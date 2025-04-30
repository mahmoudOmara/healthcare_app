import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tz;

class NotificationService {
  static final NotificationService _notificationService = NotificationService._internal();

  factory NotificationService() {
    return _notificationService;
  }

  NotificationService._internal();

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

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
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
      // onDidReceiveLocalNotification: onDidReceiveLocalNotification, // Optional callback
    );

    // Linux initialization settings (optional)
    // const LinuxInitializationSettings initializationSettingsLinux = 
    //     LinuxInitializationSettings(defaultActionName: 'Open notification');

    // Combine settings
    const InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
      // linux: initializationSettingsLinux,
    );

    // Initialize the plugin
    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      // onDidReceiveNotificationResponse: onDidReceiveNotificationResponse, // Optional callback for notification tap
    );

    // Request permissions for Android 13+
    _requestAndroidPermissions();
  }

  void _requestAndroidPermissions() {
     flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission(); // For Android 13+
     flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestExactAlarmsPermission(); // For scheduling exact alarms
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
      matchDateTimeComponents: DateTimeComponents.time, // Match time for daily recurrence if needed, or remove for one-time
    );
     print('NotificationService: Scheduled notification $id for $scheduledDate');
  }

  Future<void> cancelNotification(int id) async {
    await flutterLocalNotificationsPlugin.cancel(id);
     print('NotificationService: Canceled notification $id');
  }

  Future<void> cancelAllNotifications() async {
    await flutterLocalNotificationsPlugin.cancelAll();
     print('NotificationService: Canceled all notifications');
  }

  // --- Example Usage (to be called from AppState or relevant screens) ---

  // Example: Schedule a reminder based on a CalendarEvent
  // void scheduleReminderFromEvent(CalendarEvent event) {
  //   // Ensure event.id can be parsed to int or generate a unique int ID
  //   try {
  //     int notificationId = int.parse(event.id); 
  //     scheduleNotification(
  //       id: notificationId,
  //       title: 'Reminder: ${event.type}',
  //       body: event.title,
  //       scheduledDate: event.date, 
  //     );
  //   } catch (e) {
  //     print('Error scheduling notification from event: Invalid ID format or other error: $e');
  //     // Handle error, maybe generate a hashcode ID?
  //     // int notificationId = event.hashCode; 
  //   }
  // }

  // --- Optional Callbacks (Define these outside the class or pass them in) ---

  // static void onDidReceiveNotificationResponse(NotificationResponse notificationResponse) async {
  //   final String? payload = notificationResponse.payload;
  //   if (notificationResponse.payload != null) {
  //     debugPrint('notification payload: $payload');
  //   }
  //   // Handle notification tap action, e.g., navigate to a specific screen
  // }

  // static void onDidReceiveLocalNotification(
  //     int id, String? title, String? body, String? payload) async {
  //   // Displaying an alert dialog for iOS < 10
  //   // Handle foreground notification display for older iOS versions
  // }
}

