import 'package:flutter/material.dart';

class Palletas {
  static const Color scaffold = Color(0xFFF0F2F5);

  static const Color facebookBlue = Color(0xFF1777F2);

  static const Color facebookBlack = Color(0xFF111111);

  static const LinearGradient createRoomGradient = LinearGradient(
    colors: [Color(0xFF496AE1), Color(0xFFCE48B1)],
  );

  static const Color online = Color(0xFF4BCB1F);

  static const LinearGradient storyGradient = LinearGradient(
    // begin: Alignment.topCenter,
    // end: Alignment.bottomCenter,
    begin: Alignment.bottomCenter,
    end: Alignment.topCenter,
    colors: [Color(0xFF2e2a4f), Colors.transparent, Color(0xFFC42224)],
  );

  static const LinearGradient storyGradient2 = LinearGradient(
      colors: [const Color(0xFF2e2a4f), const Color(0xFFC42224)],
      begin: const FractionalOffset(0.0, 0.0),
      end: const FractionalOffset(1.0, 0.0),
      stops: [0.0, 1.0],
      tileMode: TileMode.clamp);
}
