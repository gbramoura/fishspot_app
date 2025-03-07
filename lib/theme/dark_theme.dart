import 'package:fishspot_app/utils/hex_color_utils.dart';
import 'package:flutter/material.dart';

Color defaultColor = HexColor('#FFFFF');
Color white = HexColor('#F8FAFC');
Color gray = HexColor('#E2E8F0');
Color gray350 = HexColor('#35383A');
Color gray150 = HexColor('#666B70');
Color green250 = HexColor('00D389');
Color green200 = HexColor('#00D389');
Color surface = HexColor('#292A2C');
Color red250 = HexColor('#ee2b2b');

ThemeData darkMode = ThemeData(
  splashFactory: NoSplash.splashFactory,
  brightness: Brightness.dark,
  colorScheme: ColorScheme.dark(
    surface: surface,
  ),
  iconTheme: IconThemeData(color: gray150),
  textTheme: TextTheme(
    headlineLarge: TextStyle(
      color: white,
      fontWeight: FontWeight.w500,
      fontSize: 42,
    ),
    headlineMedium: TextStyle(
      color: gray,
      fontWeight: FontWeight.w500,
      fontSize: 18,
    ),
    titleLarge: TextStyle(
      color: white,
      fontWeight: FontWeight.w600,
      fontSize: 18,
    ),
    titleMedium: TextStyle(
      color: white,
      fontWeight: FontWeight.w600,
      fontSize: 14,
    ),
    displayLarge: TextStyle(
      color: white,
      fontWeight: FontWeight.w400,
      fontSize: 18,
    ),
    displayMedium: TextStyle(
      color: white,
      fontWeight: FontWeight.w400,
      fontSize: 14,
    ),
    labelMedium: TextStyle(
      color: gray350,
      fontWeight: FontWeight.w500,
      fontSize: 16,
    ),
    labelSmall: TextStyle(
      color: green200,
      fontWeight: FontWeight.w400,
      fontSize: 14,
    ),
  ),
  buttonTheme: ButtonThemeData(
    colorScheme: ColorScheme(
      brightness: Brightness.dark,
      primary: green250,
      onPrimary: gray350,
      secondary: defaultColor,
      onSecondary: defaultColor,
      error: defaultColor,
      onError: defaultColor,
      surface: defaultColor,
      onSurface: defaultColor,
    ),
  ),
  inputDecorationTheme: InputDecorationTheme(
    errorBorder: OutlineInputBorder(
      borderSide: BorderSide(
        color: red250,
      ),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderSide: BorderSide(
        color: HexColor('#ee2b2b'),
        width: 1.5,
      ),
    ),
    errorStyle: TextStyle(
      color: red250,
    ),
  ),
);
