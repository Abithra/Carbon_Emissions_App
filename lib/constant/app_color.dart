import 'package:flutter/material.dart';

class AppColors {
  static const int _primaryDarkValue = 0xFF1e453e;
  static const int _primaryValue = 0xFF182c25;
  static const int _primaryLightValue = 0xFF2c4c3b;
  static const int _primaryLighterValue = 0xFF306844;
 static const int _primaryVeryLighterValue = 0xFF90EE90;

  static const MaterialColor primaryDark = MaterialColor(
    _primaryDarkValue,
    <int, Color>{
      50: Color(0xFF4e7c75),
      100: Color(0xFF4e7c75),
      200: Color(0xFF4e7c75),
      300: Color(0xFF4e7c75),
      400: Color(0xFF4e7c75),
      500: Color(_primaryDarkValue),
      600: Color(0xFF4e7c75),
      700: Color(0xFF4e7c75),
      800: Color(0xFF4e7c75),
      900: Color(0xFF4e7c75),
    },
  );

  static const MaterialColor primary = MaterialColor(
    _primaryValue,
    <int, Color>{
      50: Color(0xFF365744),
      100: Color(0xFF365744),
      200: Color(0xFF365744),
      300: Color(0xFF365744),
      400: Color(0xFF365744),
      500: Color(_primaryValue),
      600: Color(0xFF365744),
      700: Color(0xFF365744),
      800: Color(0xFF365744),
      900: Color(0xFF365744),
    },
  );

  static const MaterialColor primaryLight = MaterialColor(
    _primaryLightValue,
    <int, Color>{
      50: Color(0xFF4a8c6e),
      100: Color(0xFF4a8c6e),
      200: Color(0xFF4a8c6e),
      300: Color(0xFF4a8c6e),
      400: Color(0xFF4a8c6e),
      500: Color(_primaryLightValue),
      600: Color(0xFF4a8c6e),
      700: Color(0xFF4a8c6e),
      800: Color(0xFF4a8c6e),
      900: Color(0xFF4a8c6e),
    },
  );

  static const MaterialColor primaryLighter = MaterialColor(
    _primaryLighterValue,
    <int, Color>{
      50: Color(0xFF4a8c6e),
      100: Color(0xFF4a8c6e),
      200: Color(0xFF4a8c6e),
      300: Color(0xFF4a8c6e),
      400: Color(0xFF4a8c6e),
      500: Color(_primaryLighterValue),
      600: Color(0xFF4a8c6e),
      700: Color(0xFF4a8c6e),
      800: Color(0xFF4a8c6e),
      900: Color(0xFF4a8c6e),
    },
  );

  static const MaterialColor primaryVeryLighter = MaterialColor(
    _primaryVeryLighterValue,
    <int, Color>{
      50: Color(0xFF90EE90),
      100: Color(0xFF90EE90),
      200: Color(0xFF90EE90),
      300: Color(0xFF90EE90),
      400: Color(0xFF90EE90),
      500: Color(_primaryLighterValue),
      600: Color(0xFF90EE90),
      700: Color(0xFF90EE90),
      800: Color(0xFF90EE90),
      900: Color(0xFF90EE90),
    },
  );


  static const Color textColorDark = Colors.white;
  static const Color textColorLight = Colors.black;

}
