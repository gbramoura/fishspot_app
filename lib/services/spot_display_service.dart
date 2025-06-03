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
        SpotRiskType.veryLow => ColorsConstants.green50,
        SpotRiskType.low => ColorsConstants.green100,
        SpotRiskType.medium => ColorsConstants.yellow50,
        SpotRiskType.high => ColorsConstants.red100,
        SpotRiskType.veryHigh => ColorsConstants.red100,
        _ => Theme.of(context).textTheme.titleLarge?.color,
      };

  /// Gets the display text for a given [SpotRiskType].
  ///
  /// Returns "Nenhum" (None) if the type is unknown.
  static String getRiskText(SpotRiskType? rate) => switch (rate) {
        SpotRiskType.veryLow => "Muito Baixo",
        SpotRiskType.low => "Baixo",
        SpotRiskType.medium => "Mediano(a)",
        SpotRiskType.high => "Alto(a)",
        SpotRiskType.veryHigh => "Muito Alto(a)",
        _ => "Nenhum",
      };

  /// Converts a risk text [String] back to a [SpotRiskType].
  ///
  /// Returns [SpotRiskType.veryLow] if the text is unknown.
  static SpotRiskType getRiskFromText(String? rate) => switch (rate) {
        "Muito Baixo" => SpotRiskType.veryLow,
        "Baixo" => SpotRiskType.low,
        "Mediano(a)" => SpotRiskType.medium,
        "Alto(a)" => SpotRiskType.high,
        "Muito Alto(a)" => SpotRiskType.veryHigh,
        _ => SpotRiskType.veryLow,
      };

  /// Gets the color for a given [SpotDifficultyType].
  ///
  /// Uses predefined colors from `ColorsConstants`. Falls back to the
  /// theme's title large color if the type is unknown.
  static Color? getDifficultyColor(
          SpotDifficultyType? rate, BuildContext context) =>
      switch (rate) {
        SpotDifficultyType.veryEasy => ColorsConstants.green50,
        SpotDifficultyType.easy => ColorsConstants.green100,
        SpotDifficultyType.medium => ColorsConstants.yellow50,
        SpotDifficultyType.hard => ColorsConstants.red100,
        SpotDifficultyType.veryHard => ColorsConstants.red100,
        _ => Theme.of(context).textTheme.titleLarge?.color,
      };

  /// Gets the display text for a given [SpotDifficultyType].
  ///
  /// Returns "Nenhum(a)" (None) if the type is unknown.
  static String getDifficultyText(SpotDifficultyType? rate) => switch (rate) {
        SpotDifficultyType.veryEasy => "Muito Facil",
        SpotDifficultyType.easy => "Facil",
        SpotDifficultyType.medium => "Mediano(a)",
        SpotDifficultyType.hard => "Difícil",
        SpotDifficultyType.veryHard => "Muito Difícil",
        _ => "Nenhum(a)",
      };

  /// Converts a difficulty text [String] back to a [SpotDifficultyType].
  ///
  /// Returns [SpotDifficultyType.veryEasy] if the text is unknown.
  static SpotDifficultyType getDifficultyFromText(String? rate) =>
      switch (rate) {
        "Muito Facil" => SpotDifficultyType.veryEasy,
        "Facil" => SpotDifficultyType.easy,
        "Mediano(a)" => SpotDifficultyType.medium,
        "Difícil" => SpotDifficultyType.hard,
        "Muito Difícil" => SpotDifficultyType.veryHard,
        _ => SpotDifficultyType.veryEasy,
      };

  /// Gets the short unit symbol for a given [UnitMeasureType].
  ///
  /// Returns an empty string if the type is unknown.
  static String getUnitMeasure(UnitMeasureType? unit) => switch (unit) {
        UnitMeasureType.grams => 'g',
        UnitMeasureType.kilograms => 'Kg',
        UnitMeasureType.ton => 't',
        _ => '',
      };

  /// Gets the full display text for a given [UnitMeasureType].
  ///
  /// Returns an empty string if the type is unknown.
  static String getUnitMeasureText(UnitMeasureType? unit) => switch (unit) {
        UnitMeasureType.grams => 'Grama(s)',
        UnitMeasureType.kilograms => 'Quilograma(s)',
        UnitMeasureType.ton => 'Tonelada(s)',
        _ => '',
      };

  /// Converts a unit measure text [String] back to a [UnitMeasureType].
  ///
  /// Returns [UnitMeasureType.grams] if the text is unknown.
  static UnitMeasureType getUnitMeasureFromText(String? unit) => switch (unit) {
        'Grama(s)' => UnitMeasureType.grams,
        'Quilograma(s)' => UnitMeasureType.kilograms,
        'Tonelada(s)' => UnitMeasureType.ton,
        _ => UnitMeasureType.grams,
      };
}
