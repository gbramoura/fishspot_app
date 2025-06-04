import 'package:fishspot_app/services/color_converter_service.dart';
import 'package:flutter/material.dart';

class ColorsConstants {
  // BACKGROUND
  static Color darkBackground = ColorConverterService.hexToColor('#292A2C');
  static Color lightBackground = ColorConverterService.hexToColor('#F4F3F3');

  // Green
  static Color green50 = ColorConverterService.hexToColor('#15ff00');
  static Color green100 = ColorConverterService.hexToColor('##0fb300');
  static Color green250 = ColorConverterService.hexToColor('#00D389');
  static Color green200 = ColorConverterService.hexToColor('#00D389');

  // Red
  static Color red50 = ColorConverterService.hexToColor('#ff1414');
  static Color red100 = ColorConverterService.hexToColor('#ad0000');
  static Color red250 = ColorConverterService.hexToColor('#ee2b2b');

  // White
  static Color white = ColorConverterService.hexToColor('#FFFFFF');
  static Color white50 = ColorConverterService.hexToColor('#F8FAFC');

  // Gray
  static Color gray50 = ColorConverterService.hexToColor('#E2E8F0');
  static Color gray75 = ColorConverterService.hexToColor('#D9D9D9');
  static Color gray100 = ColorConverterService.hexToColor("#798087");
  static Color gray150 = ColorConverterService.hexToColor('#666B70');
  static Color gray350 = ColorConverterService.hexToColor('#35383A');

  // Blue
  static Color blue150 = ColorConverterService.hexToColor('#3EC2EA');
  static Color blue750 = ColorConverterService.hexToColor('#2A5967');
  static Color blue700 = ColorConverterService.hexToColor('#2A5967');

  //Yellow
  static Color yellow50 = ColorConverterService.hexToColor('#ffde0a');
}
