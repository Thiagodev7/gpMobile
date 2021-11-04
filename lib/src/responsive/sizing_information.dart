import 'package:flutter/material.dart';
import 'package:gpmobile/src/util/enum/device_screen_type.dart';

class SizingInformation {
  final DeviceScreenType deviceScreenType;
  final Size screenSize;
  final Size localWidgetSize;

  SizingInformation(
      {this.deviceScreenType, this.screenSize, this.localWidgetSize});
}
