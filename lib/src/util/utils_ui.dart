import 'package:flutter/cupertino.dart';
import 'package:gpmobile/src/util/enum/device_screen_type.dart';

// ignore: missing_return
DeviceScreenType getDeviceScreenType(MediaQueryData mediaQuery) {
  double deviceWidth = mediaQuery.size.shortestSide;

  if (deviceWidth > 600) {
    return DeviceScreenType.Tablet;
  }

  if (deviceWidth > 800) {
    return DeviceScreenType.Desktop;
  }

  if (deviceWidth < 600) {
    return DeviceScreenType.Mobile;
  }
}
