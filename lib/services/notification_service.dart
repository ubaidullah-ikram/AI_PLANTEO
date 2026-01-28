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
//     // Request permissions
//     await Permission.notification.request();

//     // Android 12+ exact alarm permission
//     if (await Permission.scheduleExactAlarm.isDenied) {
//       await Permission.scheduleExactAlarm.request();
//     }

//     // Timezone init (VERY IMPORTANT)
//     tz.initializeTimeZones();
//     tz.setLocalLocation(tz.getLocation('Asia/Karachi'));

//     const AndroidInitializationSettings androidInit =
//         AndroidInitializationSettings('@mipmap/ic_launcher');

//     const InitializationSettings initSettings = InitializationSettings(
//       android: androidInit,
//     );

//     await _notificationsPlugin.initialize(initSettings);

//     log('✅ Notification Service Initialized');
//   }

//   Future<void> scheduleNotification({
//     required int id,
//     required String title,
//     required String body,
//     int minutesFromNow = 5, // کم از کم 5 منٹ
//   }) async {
//     try {
//       final DateTime now = DateTime.now();
//       final DateTime scheduledTime = now.add(Duration(minutes: minutesFromNow));

//       log('NOW (Local)          : $now');
//       log('SCHEDULED (DateTime) : $scheduledTime');

//       // TZDateTime میں convert کریں
//       final tz.TZDateTime tzDateTime = tz.TZDateTime(
//         tz.getLocation('Asia/Karachi'),
//         scheduledTime.year,
//         scheduledTime.month,
//         scheduledTime.day,
//         scheduledTime.hour,
//         scheduledTime.minute,
//         scheduledTime.second,
//       );

//       log('SCHEDULED (TZ)       : $tzDateTime');
//       log('TIMEZONE             : ${tz.local.name}');

//       const AndroidNotificationDetails androidDetails =
//           AndroidNotificationDetails(
//             'plant_reminder_channel',
//             'Plant Reminders',
//             channelDescription: 'Plant care reminders',
//             importance: Importance.max,
//             priority: Priority.high,
//             enableVibration: true,
//             playSound: true,
//           );

//       const NotificationDetails notificationDetails = NotificationDetails(
//         android: androidDetails,
//       );

//       await _notificationsPlugin.zonedSchedule(
//         id,
//         title,
//         body,
//         tzDateTime,
//         notificationDetails,
//         androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
//       );

//       log('✅ Notification Scheduled (ID: $id, Time: $tzDateTime)');
//     } catch (e) {
//       log('❌ Error scheduling notification: $e');
//     }
//   }

//   /// 🧪 INSTANT TEST NOTIFICATION
//   Future<void> showTestNotification() async {
//     try {
//       const AndroidNotificationDetails androidDetails =
//           AndroidNotificationDetails(
//             'test_channel',
//             'Test Notifications',
//             channelDescription: 'Instant test notification channel',
//             importance: Importance.max,
//             priority: Priority.high,
//             enableVibration: true,
//             playSound: true,
//           );

//       const NotificationDetails notificationDetails = NotificationDetails(
//         android: androidDetails,
//       );

//       await _notificationsPlugin.show(
//         999,
//         '🔔 Test Notification',
//         'If you see this, notifications are working!',
//         notificationDetails,
//       );

//       log('✅ Test notification shown');
//     } catch (e) {
//       log('❌ Error showing test: $e');
//     }
//   }

//   /// Get pending notifications
//   Future<List<PendingNotificationRequest>> getPendingNotifications() async {
//     return await _notificationsPlugin.pendingNotificationRequests();
//   }

//   /// ❌ Cancel single notification
//   Future<void> cancel(int id) async {
//     await _notificationsPlugin.cancel(id);
//     log('Cancelled notification ID: $id');
//   }

//   /// ❌ Cancel all notifications
//   Future<void> cancelAll() async {
//     await _notificationsPlugin.cancelAll();
//     log('All notifications cancelled');
//   }
// // }
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

//   /// 🔹 Initialize on app start
//   Future<void> init() async {
//     await Permission.notification.request();
//     if (await Permission.scheduleExactAlarm.isDenied) {
//       await Permission.scheduleExactAlarm.request();
//     }

//     tz.initializeTimeZones();
//     tz.setLocalLocation(tz.getLocation('Asia/Karachi'));

//     const AndroidInitializationSettings androidInit =
//         AndroidInitializationSettings('@mipmap/ic_launcher');

//     const InitializationSettings initSettings = InitializationSettings(
//       android: androidInit,
//     );

//     await _notificationsPlugin.initialize(initSettings);
//     log('✅ Notification Service Initialized');
//   }

//   /// 🔹 Schedule notification with repeat
//   Future<void> scheduleReminderNotification({
//     required int id,
//     required String title,
//     required String body,
//     required int hour,
//     required int minute,
//     required int repeatEveryDays,
//   }) async {
//     try {
//       // Create TZ DateTime
//       final now = DateTime.now();
//       final tz.TZDateTime scheduledTime = tz.TZDateTime(
//         tz.getLocation('Asia/Karachi'),
//         now.year,
//         now.month,
//         now.day,
//         hour,
//         minute,
//       );

//       // If time passed, schedule for next day
//       tz.TZDateTime adjustedTime = scheduledTime;
//       if (adjustedTime.isBefore(
//         tz.TZDateTime.now(tz.getLocation('Asia/Karachi')),
//       )) {
//         adjustedTime = adjustedTime.add(const Duration(days: 1));
//       }
//       log('Adjusted Time: $adjustedTime');
//       const AndroidNotificationDetails androidDetails =
//           AndroidNotificationDetails(
//             'plant_reminder_channel',
//             'Plant Reminders',
//             channelDescription: 'Plant care reminders',
//             importance: Importance.max,
//             priority: Priority.high,
//             enableVibration: true,
//             playSound: true,
//           );

//       const NotificationDetails notificationDetails = NotificationDetails(
//         android: androidDetails,
//       );

//       // Schedule with repeat
//       await _notificationsPlugin.zonedSchedule(
//         id,
//         title,
//         body,
//         adjustedTime,
//         notificationDetails,
//         androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
//         matchDateTimeComponents:
//             DateTimeComponents.time, // ✅ Repeat daily at same time
//       );

//       log(
//         '✅ Repeating Notification Scheduled: $title at ${adjustedTime.hour}:${adjustedTime.minute} every $repeatEveryDays days',
//       );
//     } catch (e) {
//       log('❌ Error scheduling notification: $e');
//     }
//   }

//   /// 🔹 Schedule one-time notification
//   Future<void> scheduleNotification({
//     required int id,
//     required String title,
//     required String body,
//     int minutesFromNow = 5,
//   }) async {
//     try {
//       final now = DateTime.now();
//       final scheduledTime = now.add(Duration(minutes: minutesFromNow));

//       final tz.TZDateTime tzDateTime = tz.TZDateTime(
//         tz.getLocation('Asia/Karachi'),
//         scheduledTime.year,
//         scheduledTime.month,
//         scheduledTime.day,
//         scheduledTime.hour,
//         scheduledTime.minute,
//       );

//       const AndroidNotificationDetails androidDetails =
//           AndroidNotificationDetails(
//             'plant_reminder_channel',
//             'Plant Reminders',
//             channelDescription: 'Plant care reminders',
//             importance: Importance.max,
//             priority: Priority.high,
//             enableVibration: true,
//             playSound: true,
//           );

//       const NotificationDetails notificationDetails = NotificationDetails(
//         android: androidDetails,
//       );

//       await _notificationsPlugin.zonedSchedule(
//         id,
//         title,
//         body,
//         tzDateTime,
//         notificationDetails,
//         androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
//       );

//       log('✅ One-time Notification Scheduled (ID: $id)');
//     } catch (e) {
//       log('❌ Error: $e');
//     }
//   }

//   /// 🧪 Instant test notification
//   Future<void> showTestNotification() async {
//     try {
//       const AndroidNotificationDetails androidDetails =
//           AndroidNotificationDetails(
//             'test_channel',
//             'Test Notifications',
//             channelDescription: 'Instant test notification',
//             importance: Importance.max,
//             priority: Priority.high,
//             enableVibration: true,
//             playSound: true,
//           );

//       const NotificationDetails notificationDetails = NotificationDetails(
//         android: androidDetails,
//       );

//       await _notificationsPlugin.show(
//         999,
//         '🔔 Test Notification',
//         'If you see this, notifications are working!',
//         notificationDetails,
//       );

//       log('✅ Test notification shown');
//     } catch (e) {
//       log('❌ Error: $e');
//     }
//   }

//   /// Get pending notifications
//   Future<List<PendingNotificationRequest>> getPendingNotifications() async {
//     return await _notificationsPlugin.pendingNotificationRequests();
//   }

//   /// Cancel single notification
//   Future<void> cancel(int id) async {
//     await _notificationsPlugin.cancel(id);
//     log('Cancelled notification ID: $id');
//   }

//   /// Cancel all notifications
//   Future<void> cancelAll() async {
//     await _notificationsPlugin.cancelAll();
//     log('All notifications cancelled');
//   }
// }
import 'dart:developer';
import 'dart:io';
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

  /// 🔹 Initialize on app start
  Future<void> init() async {
    /// 🔔 Permissions
    if (Platform.isAndroid) {
      await Permission.notification.request();

      if (await Permission.scheduleExactAlarm.isDenied) {
        await Permission.scheduleExactAlarm.request();
      }
    } else if (Platform.isIOS) {
      await _notificationsPlugin
          .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin
          >()
          ?.requestPermissions(alert: true, badge: true, sound: true);
    }

    /// 🌍 Timezone
    tz.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation('Asia/Karachi'));

    /// 🤖 Android init
    const AndroidInitializationSettings androidInit =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    /// 🍎 iOS init
    const DarwinInitializationSettings iosInit = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const InitializationSettings initSettings = InitializationSettings(
      android: androidInit,
      iOS: iosInit,
    );

    await _notificationsPlugin.initialize(initSettings);
    log('✅ Notification Service Initialized');
  }

  /// 🔹 Schedule repeating notification (daily / interval)
  Future<void> scheduleReminderNotification({
    required int id,
    required String title,
    required String body,
    required int hour,
    required int minute,
    required int repeatEveryDays,
  }) async {
    try {
      final now = DateTime.now();

      tz.TZDateTime scheduledTime = tz.TZDateTime(
        tz.getLocation('Asia/Karachi'),
        now.year,
        now.month,
        now.day,
        hour,
        minute,
      );

      if (scheduledTime.isBefore(tz.TZDateTime.now(tz.local))) {
        scheduledTime = scheduledTime.add(const Duration(days: 1));
      }

      /// 🤖 Android
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

      /// 🍎 iOS
      const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
        presentAlert: true,
        presentSound: true,
        presentBadge: true,
      );

      const NotificationDetails notificationDetails = NotificationDetails(
        android: androidDetails,
        iOS: iosDetails,
      );

      await _notificationsPlugin.zonedSchedule(
        id,
        title,
        body,
        scheduledTime,
        notificationDetails,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        matchDateTimeComponents: DateTimeComponents.time, // daily
        // uiLocalNotificationDateInterpretation:
        //     UILocalNotificationDateInterpretation.absoluteTime,
      );

      log('✅ Repeating notification scheduled');
    } catch (e) {
      log('❌ Error scheduling notification: $e');
    }
  }

  /// 🔹 One-time notification
  Future<void> scheduleNotification({
    required int id,
    required String title,
    required String body,
    int minutesFromNow = 5,
  }) async {
    try {
      final scheduledTime = tz.TZDateTime.now(
        tz.local,
      ).add(Duration(minutes: minutesFromNow));

      const AndroidNotificationDetails androidDetails =
          AndroidNotificationDetails(
            'plant_reminder_channel',
            'Plant Reminders',
            channelDescription: 'Plant care reminders',
            importance: Importance.max,
            priority: Priority.high,
          );

      const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
        presentAlert: true,
        presentSound: true,
      );

      const NotificationDetails notificationDetails = NotificationDetails(
        android: androidDetails,
        iOS: iosDetails,
      );

      await _notificationsPlugin.zonedSchedule(
        id,
        title,
        body,
        scheduledTime,
        notificationDetails,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,

        // uiLocalNotificationDateInterpretation:
        //     UILocalNotificationDateInterpretation.absoluteTime,
      );

      log('✅ One-time notification scheduled');
    } catch (e) {
      log('❌ Error: $e');
    }
  }

  /// 🧪 Instant test notification
  Future<void> showTestNotification() async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
          'test_channel',
          'Test Notifications',
          channelDescription: 'Instant test notification',
          importance: Importance.max,
          priority: Priority.high,
        );

    const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentSound: true,
    );

    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _notificationsPlugin.show(
      999,
      '🔔 Test Notification',
      'If you see this, notifications are working!',
      notificationDetails,
    );
  }

  /// 📋 Pending notifications
  Future<List<PendingNotificationRequest>> getPendingNotifications() async {
    return _notificationsPlugin.pendingNotificationRequests();
  }

  /// ❌ Cancel single
  Future<void> cancel(int id) async {
    await _notificationsPlugin.cancel(id);
  }

  /// ❌ Cancel all
  Future<void> cancelAll() async {
    await _notificationsPlugin.cancelAll();
  }
}
