import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import '../../../main.dart';

class Notific extends StatelessWidget {
  const Notific({Key key}) : super(key: key);

  Future showNotificationWithShedule() async {
    final String currentTimeZone =
        await FlutterNativeTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(currentTimeZone));

    await flutterLocalNotificationsPlugin.zonedSchedule(
        0,
        'Seu almoço acabou',
        'Vai bater o ponto',
        tz.TZDateTime.now(tz.local).add(const Duration(seconds: 10)),
        const NotificationDetails(
            android: AndroidNotificationDetails(
                'your channel id', 'your channel name',
                channelDescription: 'your channel description')),
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime);
  }

  Future showNotificationWithChronometer() async {
    const int insistentFlag = 2;
    final AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails('1', 'Ponto',
            channelDescription: 'Horario de Almoço',
            importance: Importance.max,
            priority: Priority.high,
            when: DateTime.now().millisecondsSinceEpoch + 10 * 1000,
            visibility: NotificationVisibility.public,
            usesChronometer: true,
            autoCancel: true,
            additionalFlags: Int32List.fromList(<int>[insistentFlag]),
            color: Colors.red);
    final NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
        0, 'Hora do Almoço', '', platformChannelSpecifics,
        payload: 'item x');
    print('ate aqui funfou 2');
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
