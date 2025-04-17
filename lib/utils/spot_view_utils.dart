import 'package:fishspot_app/constants/colors_constants.dart';
import 'package:fishspot_app/enums/spot_difficulty_type.dart';
import 'package:fishspot_app/enums/spot_risk_type.dart';
import 'package:fishspot_app/enums/unit_measure_type.dart';
import 'package:flutter/material.dart';

class SpotViewUtils {
  static getRiskColor(SpotRiskType? rate, dynamic context) => switch (rate) {
        SpotRiskType.VeryLow => ColorsConstants.green50,
        SpotRiskType.Low => ColorsConstants.green100,
        SpotRiskType.Medium => ColorsConstants.yellow50,
        SpotRiskType.High => ColorsConstants.red100,
        SpotRiskType.VeryHigh => ColorsConstants.red100,
        _ => Theme.of(context).textTheme.titleLarge?.color,
      };

  static String getRiskText(SpotRiskType? rate) => switch (rate) {
        SpotRiskType.VeryLow => "Muito Baixo",
        SpotRiskType.Low => "Baixo",
        SpotRiskType.Medium => "Mediano(a)",
        SpotRiskType.High => "Alto(a)",
        SpotRiskType.VeryHigh => "Muito Alto(a)",
        _ => "Nenhum",
      };

  static SpotRiskType getRiskFromText(String? rate) => switch (rate) {
        "Muito Baixo" => SpotRiskType.VeryLow,
        "Baixo" => SpotRiskType.Low,
        "Mediano(a)" => SpotRiskType.Medium,
        "Alto(a)" => SpotRiskType.High,
        "Muito Alto(a)" => SpotRiskType.VeryHigh,
        _ => SpotRiskType.VeryLow,
      };

  static getDifficultyColor(SpotDifficultyType? rate, dynamic context) =>
      switch (rate) {
        SpotDifficultyType.VeryEasy => ColorsConstants.green50,
        SpotDifficultyType.Easy => ColorsConstants.green100,
        SpotDifficultyType.Medium => ColorsConstants.yellow50,
        SpotDifficultyType.Hard => ColorsConstants.red100,
        SpotDifficultyType.VeryHard => ColorsConstants.red100,
        _ => Theme.of(context).textTheme.titleLarge?.color,
      };

  static String getDifficultyText(SpotDifficultyType? rate) => switch (rate) {
        SpotDifficultyType.VeryEasy => "Muito Facil",
        SpotDifficultyType.Easy => "Facil",
        SpotDifficultyType.Medium => "Mediano(a)",
        SpotDifficultyType.Hard => "Difícil",
        SpotDifficultyType.VeryHard => "Muito Difícil",
        _ => "Nenhum(a)",
      };

  static SpotDifficultyType getDifficultyFromText(String? rate) =>
      switch (rate) {
        "Muito Facil" => SpotDifficultyType.VeryEasy,
        "Facil" => SpotDifficultyType.Easy,
        "Mediano(a)" => SpotDifficultyType.Medium,
        "Difícil" => SpotDifficultyType.Hard,
        "Muito Difícil" => SpotDifficultyType.VeryHard,
        _ => SpotDifficultyType.VeryEasy,
      };

  static String getUnitMeasure(UnitMeasureType? unit) => switch (unit) {
        UnitMeasureType.Grams => 'g',
        UnitMeasureType.Kilograms => 'Kg',
        UnitMeasureType.Ton => 't',
        _ => '',
      };

  static String getUnitMeasureText(UnitMeasureType? unit) => switch (unit) {
        UnitMeasureType.Grams => 'Grama(s)',
        UnitMeasureType.Kilograms => 'Quilograma(s)',
        UnitMeasureType.Ton => 'Tonelada(s)',
        _ => '',
      };

  static UnitMeasureType getUnitMeasureFromText(String? unit) => switch (unit) {
        'Grama(s)' => UnitMeasureType.Grams,
        'Quilograma(s)' => UnitMeasureType.Kilograms,
        'Tonelada(s)' => UnitMeasureType.Ton,
        _ => UnitMeasureType.Grams,
      };
}
