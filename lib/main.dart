// import 'dart:async';
// import 'dart:io';
import 'dart:isolate';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
//https://blog.codemagic.io/flutter-web-getting-started-with-responsive-design/

import 'package:desktop_window/desktop_window.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:gpmobile/src/util/ThemeController.dart';
import 'package:universal_io/io.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'src/AppWidget.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('ic_launcher');

final InitializationSettings initializationSettings =
    InitializationSettings(android: initializationSettingsAndroid);

void main() async {
  Get.lazyPut<ThemeController>(
      () => ThemeController()); //definir o mode antes de inicializar o app
  WidgetsFlutterBinding.ensureInitialized();

  initializeDateFormatting('pt_BR', 'null'); //dependecnia
  HttpOverrides.global =
      new MyHttpOverrides(); //Faz com que http aceite todos os certificados.

  SystemChrome.setPreferredOrientations(
          [DeviceOrientation.portraitUp]) //Não permite orientacao paisagem
      .then((_) async {
    if (!kIsWeb &&
        (Platform.isMacOS || Platform.isLinux || Platform.isWindows)) {
      await DesktopWindow.setMinWindowSize(const Size(600, 800));
    }

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);

    runApp(
      new AppWidget(),
    );
  });
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
