import 'dart:async';

// import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

//DarkMode propriedade reativa - https://www.youtube.com/watch?v=UvUsRW-wrAM&t=3526s
class ThemeController extends GetxController {
  var isDark = false.obs;
  Map<String, ThemeMode> themeModes = {
    'light': ThemeMode.light,
    'dark': ThemeMode.dark,
  };
  SharedPreferences prefs;

  static ThemeController get to => Get.find();

  loadThemeMode() async {
    prefs = await SharedPreferences.getInstance();
    String themeText = prefs.getString('theme') ?? 'light';
    isDark.value = themeText == 'dark' ? true : false;
    setMode(themeText);
  }

  Future setMode(String themeText) async {
    ThemeMode themeMode = themeModes[themeText];
    Get.changeThemeMode(themeMode);
    prefs = await SharedPreferences.getInstance();
    await prefs.setString('theme', themeText);
  }

  changeTheme() {
    setMode(isDark.value ? 'light' : 'dark');
    isDark.value = !isDark.value;
    
  }
}
