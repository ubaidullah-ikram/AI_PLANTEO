// import 'dart:developer';

// import 'package:flutter/material.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:timezone/data/latest.dart' as tz;
// import 'package:timezone/timezone.dart' as tz;

// class NotificationService {
//   NotificationService._();
//   static final NotificationService instance = NotificationService._();

//   final FlutterLocalNotificationsPlugin _notificationsPlugin =
//       FlutterLocalNotificationsPlugin();

//   /// 🔹 Call this on app start (main)
//   Future<void> init() async {
//     // Timezone init (VERY IMPORTANT)
//     await Permission.notification.request();
//     tz.initializeTimeZones();
//     tz.setLocalLocation(tz.getLocation('Asia/Karachi'));

//     const AndroidInitializationSettings androidInit =
//         AndroidInitializationSettings('@mipmap/ic_launcher');

//     const InitializationSettings initSettings = InitializationSettings(
//       android: androidInit,
//     );

//     await _notificationsPlugin.initialize(initSettings);
//   }

//   Future<void> scheduleNotification({
//     required int id,
//     required String title,
//     required String body,
//   }) async {
//     final DateTime now = DateTime.now();
//     final DateTime testTime = now.add(const Duration(minutes: 1));

//     log('NOW (local)          : $now');
//     log('SCHEDULED (DateTime) : $testTime');

//     final tz.TZDateTime tzDateTime = tz.TZDateTime.from(testTime, tz.local);

//     log('SCHEDULED (TZ)       : $tzDateTime');
//     log('TIMEZONE             : ${tz.local.name}');

//     const AndroidNotificationDetails androidDetails =
//         AndroidNotificationDetails(
//           'plant_reminder_channel',
//           'Plant Reminders',
//           channelDescription: 'Plant care reminders',
//           importance: Importance.max,
//           priority: Priority.high,
//         );

//     const NotificationDetails notificationDetails = NotificationDetails(
//       android: androidDetails,
//     );

//     await _notificationsPlugin.zonedSchedule(
//       id,
//       title,
//       body,
//       tzDateTime,
//       notificationDetails,

//       // 🔥 IMPORTANT: EXACT ALARM
//       androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
//     );

//     log('✅ Notification scheduled successfully (ID: $id)');
//   }

//   /// 🧪 INSTANT TEST NOTIFICATION
//   Future<void> showTestNotification() async {
//     const AndroidNotificationDetails androidDetails =
//         AndroidNotificationDetails(
//           'test_channel',
//           'Test Notifications',
//           channelDescription: 'Instant test notification channel',
//           importance: Importance.max,
//           priority: Priority.high,
//         );

//     const NotificationDetails notificationDetails = NotificationDetails(
//       android: androidDetails,
//     );

//     await _notificationsPlugin.show(
//       999, // unique test ID
//       '🔔 Test Notification',
//       'If you see this, notifications are working!',
//       notificationDetails,
//     );
//   }

//   /// ❌ Cancel single notification
//   Future<void> cancel(int id) async {
//     await _notificationsPlugin.cancel(id);
//   }

//   /// ❌ Cancel all notifications
//   Future<void> cancelAll() async {
//     await _notificationsPlugin.cancelAll();
//   }
// }
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  NotificationService._();
  static final NotificationService instance = NotificationService._();

  final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  /// 🔹 Call this on app start (main)
  Future<void> init() async {
    // Request permissions
    await Permission.notification.request();

    // Android 12+ exact alarm permission
    if (await Permission.scheduleExactAlarm.isDenied) {
      await Permission.scheduleExactAlarm.request();
    }

    // Timezone init (VERY IMPORTANT)
    tz.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation('Asia/Karachi'));

    const AndroidInitializationSettings androidInit =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initSettings = InitializationSettings(
      android: androidInit,
    );

    await _notificationsPlugin.initialize(initSettings);

    log('✅ Notification Service Initialized');
  }

  Future<void> scheduleNotification({
    required int id,
    required String title,
    required String body,
    int minutesFromNow = 5, // کم از کم 5 منٹ
  }) async {
    try {
      final DateTime now = DateTime.now();
      final DateTime scheduledTime = now.add(Duration(minutes: minutesFromNow));

      log('NOW (Local)          : $now');
      log('SCHEDULED (DateTime) : $scheduledTime');

      // TZDateTime میں convert کریں
      final tz.TZDateTime tzDateTime = tz.TZDateTime(
        tz.getLocation('Asia/Karachi'),
        scheduledTime.year,
        scheduledTime.month,
        scheduledTime.day,
        scheduledTime.hour,
        scheduledTime.minute,
        scheduledTime.second,
      );

      log('SCHEDULED (TZ)       : $tzDateTime');
      log('TIMEZONE             : ${tz.local.name}');

      const AndroidNotificationDetails androidDetails =
          AndroidNotificationDetails(
            'plant_reminder_channel',
            'Plant Reminders',
            channelDescription: 'Plant care reminders',
            importance: Importance.max,
            priority: Priority.high,
            enableVibration: true,
            playSound: true,
          );

      const NotificationDetails notificationDetails = NotificationDetails(
        android: androidDetails,
      );

      await _notificationsPlugin.zonedSchedule(
        id,
        title,
        body,
        tzDateTime,
        notificationDetails,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      );

      log('✅ Notification Scheduled (ID: $id, Time: $tzDateTime)');
    } catch (e) {
      log('❌ Error scheduling notification: $e');
    }
  }

  /// 🧪 INSTANT TEST NOTIFICATION
  Future<void> showTestNotification() async {
    try {
      const AndroidNotificationDetails androidDetails =
          AndroidNotificationDetails(
            'test_channel',
            'Test Notifications',
            channelDescription: 'Instant test notification channel',
            importance: Importance.max,
            priority: Priority.high,
            enableVibration: true,
            playSound: true,
          );

      const NotificationDetails notificationDetails = NotificationDetails(
        android: androidDetails,
      );

      await _notificationsPlugin.show(
        999,
        '🔔 Test Notification',
        'If you see this, notifications are working!',
        notificationDetails,
      );

      log('✅ Test notification shown');
    } catch (e) {
      log('❌ Error showing test: $e');
    }
  }

  /// Get pending notifications
  Future<List<PendingNotificationRequest>> getPendingNotifications() async {
    return await _notificationsPlugin.pendingNotificationRequests();
  }

  /// ❌ Cancel single notification
  Future<void> cancel(int id) async {
    await _notificationsPlugin.cancel(id);
    log('Cancelled notification ID: $id');
  }

  /// ❌ Cancel all notifications
  Future<void> cancelAll() async {
    await _notificationsPlugin.cancelAll();
    log('All notifications cancelled');
  }
}
