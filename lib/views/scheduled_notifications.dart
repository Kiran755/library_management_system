import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

Future<void> scheduleNotification(DateTime date) async {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  // Define notification details
  final AndroidNotificationDetails androidPlatformChannelSpecifics =
      AndroidNotificationDetails(
          'your_channel_id', // Replace with your own channel ID
          'Scheduled Notifications');

  final NotificationDetails platformChannelSpecifics = NotificationDetails(
    android: androidPlatformChannelSpecifics,
  );

  // Define when to trigger the notification (e.g., 1 hour from now)
  final DateTime scheduledDate = DateTime.now().add(Duration(hours: 1));

  // Schedule the notification
  String timeZoneName = 'Asia/Kolkata'; // Replace with your desired time zone

  tz.Location location = tz.getLocation(timeZoneName);
  await flutterLocalNotificationsPlugin.zonedSchedule(
    0, // Notification ID
    'Scheduled Notification Title',
    'Scheduled Notification Body',
    tz.TZDateTime.from(date, location).add(const Duration(hours: 1)),
    platformChannelSpecifics,
    uiLocalNotificationDateInterpretation:
        UILocalNotificationDateInterpretation.wallClockTime,
    androidAllowWhileIdle: true,
  );
}
