import 'package:fishspot_app/constants/colors_constants.dart';
import 'package:fishspot_app/utils/hex_color_utils.dart';
import 'package:flutter/material.dart';

ThemeData darkMode = ThemeData(
  splashFactory: NoSplash.splashFactory,
  brightness: Brightness.dark,
  colorScheme: ColorScheme.dark(
    surface: ColorsConstants.darkBackground,
    primary: ColorsConstants.green250,
  ),
  textSelectionTheme: TextSelectionThemeData(
    selectionColor: ColorsConstants.green250.withAlpha(50),
    cursorColor: ColorsConstants.green250,
    selectionHandleColor: ColorsConstants.green250,
  ),
  iconTheme: IconThemeData(color: ColorsConstants.gray150),
  textTheme: TextTheme(
    headlineLarge: TextStyle(
      color: ColorsConstants.white50,
      fontWeight: FontWeight.w500,
      fontSize: 42,
    ),
    headlineMedium: TextStyle(
      color: ColorsConstants.gray50,
      fontWeight: FontWeight.w500,
      fontSize: 18,
    ),
    titleLarge: TextStyle(
      color: ColorsConstants.white50,
      fontWeight: FontWeight.w600,
      fontSize: 18,
    ),
    titleMedium: TextStyle(
      color: ColorsConstants.white50,
      fontWeight: FontWeight.w600,
      fontSize: 14,
    ),
    displayLarge: TextStyle(
      color: ColorsConstants.white50,
      fontWeight: FontWeight.w400,
      fontSize: 18,
    ),
    displayMedium: TextStyle(
      color: ColorsConstants.white50,
      fontWeight: FontWeight.w400,
      fontSize: 14,
    ),
    labelMedium: TextStyle(
      color: ColorsConstants.gray350,
      fontWeight: FontWeight.w500,
      fontSize: 16,
    ),
    labelSmall: TextStyle(
      color: ColorsConstants.green200,
      fontWeight: FontWeight.w400,
      fontSize: 14,
    ),
  ),
  buttonTheme: ButtonThemeData(
    colorScheme: ColorScheme(
      brightness: Brightness.dark,
      primary: ColorsConstants.green250,
      onPrimary: ColorsConstants.gray350,
      secondary: ColorsConstants.white,
      onSecondary: ColorsConstants.white,
      error: ColorsConstants.white,
      onError: ColorsConstants.white,
      surface: ColorsConstants.white,
      onSurface: ColorsConstants.white,
    ),
  ),
  inputDecorationTheme: InputDecorationTheme(
    errorBorder: OutlineInputBorder(
      borderSide: BorderSide(
        color: ColorsConstants.red250,
      ),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderSide: BorderSide(
        color: HexColor('#ee2b2b'),
        width: 1.5,
      ),
    ),
    errorStyle: TextStyle(
      color: ColorsConstants.red250,
    ),
  ),
  datePickerTheme: DatePickerThemeData(
    backgroundColor: ColorsConstants.darkBackground,
  ),
);
