import 'package:fishspot_app/constants/colors_constants.dart';
import 'package:flutter/material.dart';

class SpotViewUtils {
  static getRiskColor(String? rate, dynamic context) => switch (rate) {
        'VeryLow' => ColorsConstants.green50,
        'Low' => ColorsConstants.green100,
        'Medium' => ColorsConstants.yellow50,
        'High' => ColorsConstants.red100,
        'VeryHigh' => ColorsConstants.red100,
        _ => Theme.of(context).textTheme.titleLarge?.color,
      };

  static getRiskText(String? rate) => switch (rate) {
        'VeryLow' => "Muito Baixo",
        'Low' => "Baixo",
        'Medium' => "Mediano(a)",
        'High' => "Alto(a)",
        'VeryHigh' => "Muito Alto(a)",
        _ => "Nenhum",
      };

  static getDifficultyColor(String? rate, dynamic context) => switch (rate) {
        'VeryEasy' => ColorsConstants.green50,
        'Easy' => ColorsConstants.green100,
        'Medium' => ColorsConstants.yellow50,
        'Hard' => ColorsConstants.red100,
        'VeryHard' => ColorsConstants.red100,
        _ => Theme.of(context).textTheme.titleLarge?.color,
      };

  static getDifficultyText(String? rate) => switch (rate) {
        'VeryEasy' => "Muito Facil",
        'Easy' => "Facil",
        'Medium' => "Mediano(a)",
        'Hard' => "Difícil",
        'VeryHard' => "Muito Difícil",
        _ => "Nenhum(a)",
      };

  static getUnitMeasure(String? unit) => switch (unit) {
        'Grams' => 'g',
        'Kilograms' => 'Kg',
        'Ton' => 'T',
        _ => '',
      };
}
