import 'package:fishspot_app/utils/hex_color_utils.dart';
import 'package:flutter/material.dart';

Color defaultColor = HexColor('#FFFFF');
Color white = HexColor('#F8FAFC');
Color gray350 = HexColor('#35383A');
Color gray150 = HexColor('#666B70');
Color blue750 = HexColor('#2A5967');
Color blue700 = HexColor('#2A5967');
Color surface = HexColor('#F4F3F3');
Color red250 = HexColor('#ee2b2b');

ThemeData lighMode = ThemeData(
  brightness: Brightness.light,
  colorScheme: ColorScheme.light(
    surface: surface,
  ),
  iconTheme: IconThemeData(color: gray150),
  textTheme: TextTheme(
    headlineLarge: TextStyle(
      color: gray350,
      fontWeight: FontWeight.w500,
      fontSize: 42,
    ),
    headlineMedium: TextStyle(
      color: gray150,
      fontWeight: FontWeight.w500,
      fontSize: 18,
    ),
    titleLarge: TextStyle(
      color: gray350,
      fontWeight: FontWeight.w600,
      fontSize: 18,
    ),
    titleMedium: TextStyle(
      color: gray350,
      fontWeight: FontWeight.w600,
      fontSize: 14,
    ),
    displayLarge: TextStyle(
      color: gray350,
      fontWeight: FontWeight.w400,
      fontSize: 18,
    ),
    displayMedium: TextStyle(
      color: gray350,
      fontWeight: FontWeight.w400,
      fontSize: 14,
    ),
    labelMedium: TextStyle(
      color: white,
      fontWeight: FontWeight.w500,
      fontSize: 16,
    ),
    labelSmall: TextStyle(
      color: blue700,
      fontWeight: FontWeight.w400,
      fontSize: 14,
    ),
  ),
  buttonTheme: ButtonThemeData(
    colorScheme: ColorScheme(
      brightness: Brightness.dark,
      primary: blue750,
      onPrimary: blue750,
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
