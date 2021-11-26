import 'package:flutter/material.dart';
import 'package:gpmobile/src/pages/login/entrar/view/EntrarWidget.dart';
import 'package:gpmobile/src/util/constants.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'splash/SplashWidget.dart';

class AppWidget extends StatefulWidget {
  @override
  _AppWidgetState createState() => new _AppWidgetState();
}

class _AppWidgetState extends State<AppWidget> {
  //
  final themeData = ThemeData(
    backgroundColor: Color(0xFFC42224),
  );
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: themeData,
      builder: (context, widget) => ResponsiveWrapper.builder(
          BouncingScrollWrapper.builder(context, widget),
          maxWidth: double.infinity,
          minWidth: 450,
          defaultScale: true,
          breakpoints: [
            ResponsiveBreakpoint.resize(450, name: MOBILE),
            ResponsiveBreakpoint.autoScale(800, name: DESKTOP),
            ResponsiveBreakpoint.autoScale(1000, name: DESKTOP),
            ResponsiveBreakpoint.resize(1200, name: DESKTOP),
            ResponsiveBreakpoint.autoScale(2460, name: "4K"),
          ],
          background: Container(color: Color(0xFFF5F5F5))),
      home: new SplashWidget(),
    );
  }
}
