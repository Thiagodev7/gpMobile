import 'package:flutter/material.dart';
import 'package:gpmobile/src/util/enum/device_screen_type.dart';

import 'responsive_builder.dart';

class ScreenTypeLayout extends StatelessWidget {
  final Widget mobile;
  final Widget tablet;
  final Widget desktop;
  const ScreenTypeLayout({
    Key key,
    this.mobile,
    this.tablet,
    this.desktop,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      builder: (context, sizingInformation) {
        switch (sizingInformation.deviceScreenType) {
          case DeviceScreenType.Mobile:
            return mobile;
            break;
          case DeviceScreenType.Tablet:
            return tablet;
            break;
          case DeviceScreenType.Desktop:
            return desktop;
            break;
          default:
            return Container();
        }
      },
    );
  }
}
