import 'package:flutter/material.dart';

class ResponsiveLayout extends StatelessWidget {
  final Widget largeScreen;
  final Widget mediumScreen;
  final Widget smallScreen;

  const ResponsiveLayout(
      {Key key,
      @required this.largeScreen,
      this.mediumScreen,
      this.smallScreen})
      : super(key: key);

  static bool isSmallScreen(BuildContext context) {
    return MediaQuery.of(context).size.width < 800;
  }

  static bool isMediumScreen(BuildContext context) {
    return MediaQuery.of(context).size.width > 800 &&
        MediaQuery.of(context).size.width < 1200;
  }

  static bool isLargeScreen(BuildContext context) {
    return MediaQuery.of(context).size.width > 800;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > 800) {
          return largeScreen;
        } else if (constraints.maxWidth < 1200 && constraints.maxWidth > 800) {
          return mediumScreen ?? largeScreen;
        } else {
          return smallScreen ?? largeScreen;
        }
      },
    );
  }
}

// import 'package:flutter/material.dart';

// class ResponsiveWidget extends StatelessWidget {
//   final Widget largeScreen;
//   final Widget mediumScreen;
//   final Widget smallScreen;

//   const ResponsiveWidget(
//   {Key key, this.largeScreen, this.mediumScreen, this.smallScreen})
//       : super(key: key);

//   static bool isLargeScreen(BuildContext context) {
//     return MediaQuery.of(context).size.width > 1200;
//   }

//   //Small screen is any screen whose width is less than 800 pixels
//   static bool isSmallScreen(BuildContext context) {
//     return MediaQuery.of(context).size.width < 800;
//   }

//   //Medium screen is any screen whose width is less than 1200 pixels,
//   //and more than 800 pixels
//   static bool isMediumScreen(BuildContext context) {
//     return MediaQuery.of(context).size.width > 800 &&
//         MediaQuery.of(context).size.width < 1200;
//   }

//   @override
//   Widget build(BuildContext context) {
//     //Returns the widget which is more appropriate for the screen size
//     return LayoutBuilder(builder: (context, constraints) {
//       if (constraints.maxWidth > 1200) {
//         return largeScreen;
//       } else if (constraints.maxWidth > 800 && constraints.maxWidth < 1200) {
//         //if medium screen not available, then return large screen
//         return mediumScreen ?? largeScreen;
//       } else {
//         //if small screen implementation not available, then return large screen
//         return smallScreen ?? largeScreen;
//       }
//     });
//   }
// }
