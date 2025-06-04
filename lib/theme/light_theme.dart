import 'package:fishspot_app/constants/colors_constants.dart';
import 'package:fishspot_app/services/color_converter_service.dart';
import 'package:flutter/material.dart';

ThemeData lighMode = ThemeData(
  splashFactory: NoSplash.splashFactory,
  brightness: Brightness.light,
  colorScheme: ColorScheme.light(
    surface: ColorsConstants.lightBackground,
    surfaceContainer: ColorsConstants.white,
    primary: ColorsConstants.blue750,
  ),
  textSelectionTheme: TextSelectionThemeData(
    selectionColor: ColorsConstants.blue750.withAlpha(50),
    cursorColor: ColorsConstants.blue750,
    selectionHandleColor: ColorsConstants.blue750,
  ),
  iconTheme: IconThemeData(color: ColorsConstants.gray150),
  textTheme: TextTheme(
    headlineLarge: TextStyle(
      color: ColorsConstants.gray350,
      fontWeight: FontWeight.w500,
      fontSize: 42,
    ),
    headlineMedium: TextStyle(
      color: ColorsConstants.gray150,
      fontWeight: FontWeight.w500,
      fontSize: 18,
    ),
    titleLarge: TextStyle(
      color: ColorsConstants.gray350,
      fontWeight: FontWeight.w600,
      fontSize: 18,
    ),
    titleMedium: TextStyle(
      color: ColorsConstants.gray350,
      fontWeight: FontWeight.w600,
      fontSize: 14,
    ),
    displayLarge: TextStyle(
      color: ColorsConstants.gray350,
      fontWeight: FontWeight.w400,
      fontSize: 18,
    ),
    displayMedium: TextStyle(
      color: ColorsConstants.gray350,
      fontWeight: FontWeight.w400,
      fontSize: 14,
    ),
    labelMedium: TextStyle(
      color: ColorsConstants.white50,
      fontWeight: FontWeight.w500,
      fontSize: 16,
    ),
    labelSmall: TextStyle(
      color: ColorsConstants.blue700,
      fontWeight: FontWeight.w400,
      fontSize: 14,
    ),
  ),
  buttonTheme: ButtonThemeData(
    colorScheme: ColorScheme(
      brightness: Brightness.dark,
      primary: ColorsConstants.blue750,
      onPrimary: ColorsConstants.blue750,
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
        color: ColorConverterService.hexToColor('#ee2b2b'),
        width: 1.5,
      ),
    ),
    errorStyle: TextStyle(
      color: ColorsConstants.red250,
    ),
  ),
  datePickerTheme: DatePickerThemeData(
    backgroundColor: ColorsConstants.lightBackground,
  ),
);
