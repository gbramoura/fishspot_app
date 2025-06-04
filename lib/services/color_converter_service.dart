import 'package:flutter/material.dart';

/// A service to convert hex color strings into Flutter `Color` objects.
class ColorConverterService {
  /// Converts a hex color [String] to a `Color` object.
  ///
  /// Supports hex strings like "RRGGBB" (becomes opaque) or "AARRGGBB".
  /// Handles strings with or without a leading '#'.
  /// Throws a [FormatException] for invalid hex strings.
  static Color hexToColor(String hexColorString) {
    String formattedHex = hexColorString.toUpperCase().replaceAll("#", "");

    if (formattedHex.length == 6) {
      formattedHex = "FF$formattedHex"; // Assume full opacity
    }

    return Color(int.parse(formattedHex, radix: 16));
  }
}
