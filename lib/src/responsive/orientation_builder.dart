import 'package:flutter/material.dart';

class OrientationLayout extends StatelessWidget {

  final Widget landscape;
  final Widget portrait;


  OrientationLayout({this.landscape, this.portrait});


  @override
  Widget build(BuildContext context) {
    var orientation = MediaQuery.of(context).orientation;
    if(orientation==Orientation.portrait){
      return portrait ?? landscape;
    }
    return landscape;
  }
}
