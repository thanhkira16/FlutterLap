import 'package:flutter/material.dart';
import 'package:flutter_reminder_app/epap.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'dart:io';
import 'package:flutter/services.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> setupTimezone() async {
  tz.initializeTimeZones();

  try {
    final timezoneInfo = await FlutterTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(timezoneInfo.identifier));
  } catch (e) {
    print("Timezone error: $e");
    tz.setLocalLocation(tz.getLocation('Asia/Ho_Chi_Minh'));
  }
}

Future<void> requestNotificationPermission() async {
  final androidImpl =
      flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>();

  await androidImpl?.requestNotificationsPermission();
}

Future<void> requestExactAlarmPermission() async {
  if (!Platform.isAndroid) return;

  final info = await DeviceInfoPlugin().androidInfo;
  if (info.version.sdkInt >= 31) {
    const platform = MethodChannel('exact_alarm_channel');
    try {
      await platform.invokeMethod('requestExactAlarmPermission');
    } catch (e) {
      print("Exact Alarm permission error: $e");
    }
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await setupTimezone();

  const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
  const initSettings = InitializationSettings(android: androidInit);

  await flutterLocalNotificationsPlugin.initialize(initSettings);

  // ✅ Gọi xin quyền thông báo
  await requestNotificationPermission();

  // ✅ Gọi xin quyền exact alarm (Android 12+)
  await requestExactAlarmPermission();

  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: Epap(),
  ));
}
