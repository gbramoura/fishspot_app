import 'package:fishspot_app/constants/colors_constants.dart';
import 'package:fishspot_app/enums/spot_difficulty_type.dart';
import 'package:fishspot_app/enums/spot_risk_type.dart';
import 'package:fishspot_app/enums/unit_measure_type.dart';
import 'package:flutter/material.dart';

/// Provides utility methods for displaying and converting spot-related data.
///
/// This service helps with mapping risk levels, difficulty levels, and unit
/// measures to their corresponding colors, display text, and enum values.
class SpotDisplayService {
  /// Gets the color for a given [SpotRiskType].
  ///
  /// Uses predefined colors from `ColorsConstants`. Falls back to the
  /// theme's title large color if the type is unknown.
  static Color? getRiskColor(SpotRiskType? rate, BuildContext context) =>
      switch (rate) {
        SpotRiskType.VeryLow => ColorsConstants.green50,
        SpotRiskType.Low => ColorsConstants.green100,
        SpotRiskType.Medium => ColorsConstants.yellow50,
        SpotRiskType.High => ColorsConstants.red100,
        SpotRiskType.VeryHigh => ColorsConstants.red100,
        _ => Theme.of(context).textTheme.titleLarge?.color,
      };

  /// Gets the display text for a given [SpotRiskType].
  ///
  /// Returns "Nenhum" (None) if the type is unknown.
  static String getRiskText(SpotRiskType? rate) => switch (rate) {
        SpotRiskType.VeryLow => "Muito Baixo",
        SpotRiskType.Low => "Baixo",
        SpotRiskType.Medium => "Mediano(a)",
        SpotRiskType.High => "Alto(a)",
        SpotRiskType.VeryHigh => "Muito Alto(a)",
        _ => "Nenhum",
      };

  /// Converts a risk text [String] back to a [SpotRiskType].
  ///
  /// Returns [SpotRiskType.VeryLow] if the text is unknown.
  static SpotRiskType getRiskFromText(String? rate) => switch (rate) {
        "Muito Baixo" => SpotRiskType.VeryLow,
        "Baixo" => SpotRiskType.Low,
        "Mediano(a)" => SpotRiskType.Medium,
        "Alto(a)" => SpotRiskType.High,
        "Muito Alto(a)" => SpotRiskType.VeryHigh,
        _ => SpotRiskType.VeryLow,
      };

  /// Gets the color for a given [SpotDifficultyType].
  ///
  /// Uses predefined colors from `ColorsConstants`. Falls back to the
  /// theme's title large color if the type is unknown.
  static Color? getDifficultyColor(
          SpotDifficultyType? rate, BuildContext context) =>
      switch (rate) {
        SpotDifficultyType.VeryEasy => ColorsConstants.green50,
        SpotDifficultyType.Easy => ColorsConstants.green100,
        SpotDifficultyType.Medium => ColorsConstants.yellow50,
        SpotDifficultyType.Hard => ColorsConstants.red100,
        SpotDifficultyType.VeryHard => ColorsConstants.red100,
        _ => Theme.of(context).textTheme.titleLarge?.color,
      };

  /// Gets the display text for a given [SpotDifficultyType].
  ///
  /// Returns "Nenhum(a)" (None) if the type is unknown.
  static String getDifficultyText(SpotDifficultyType? rate) => switch (rate) {
        SpotDifficultyType.VeryEasy => "Muito Facil",
        SpotDifficultyType.Easy => "Facil",
        SpotDifficultyType.Medium => "Mediano(a)",
        SpotDifficultyType.Hard => "Difícil",
        SpotDifficultyType.VeryHard => "Muito Difícil",
        _ => "Nenhum(a)",
      };

  /// Converts a difficulty text [String] back to a [SpotDifficultyType].
  ///
  /// Returns [SpotDifficultyType.VeryEasy] if the text is unknown.
  static SpotDifficultyType getDifficultyFromText(String? rate) =>
      switch (rate) {
        "Muito Facil" => SpotDifficultyType.VeryEasy,
        "Facil" => SpotDifficultyType.Easy,
        "Mediano(a)" => SpotDifficultyType.Medium,
        "Difícil" => SpotDifficultyType.Hard,
        "Muito Difícil" => SpotDifficultyType.VeryHard,
        _ => SpotDifficultyType.VeryEasy,
      };

  /// Gets the short unit symbol for a given [UnitMeasureType].
  ///
  /// Returns an empty string if the type is unknown.
  static String getUnitMeasure(UnitMeasureType? unit) => switch (unit) {
        UnitMeasureType.Grams => 'g',
        UnitMeasureType.Kilograms => 'Kg',
        UnitMeasureType.Ton => 't',
        _ => '',
      };

  /// Gets the full display text for a given [UnitMeasureType].
  ///
  /// Returns an empty string if the type is unknown.
  static String getUnitMeasureText(UnitMeasureType? unit) => switch (unit) {
        UnitMeasureType.Grams => 'Grama(s)',
        UnitMeasureType.Kilograms => 'Quilograma(s)',
        UnitMeasureType.Ton => 'Tonelada(s)',
        _ => '',
      };

  /// Converts a unit measure text [String] back to a [UnitMeasureType].
  ///
  /// Returns [UnitMeasureType.Grams] if the text is unknown.
  static UnitMeasureType getUnitMeasureFromText(String? unit) => switch (unit) {
        'Grama(s)' => UnitMeasureType.Grams,
        'Quilograma(s)' => UnitMeasureType.Kilograms,
        'Tonelada(s)' => UnitMeasureType.Ton,
        _ => UnitMeasureType.Grams,
      };
}
