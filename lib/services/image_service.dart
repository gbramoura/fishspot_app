import 'package:fishspot_app/constants/shared_preferences_constants.dart';
import 'package:fishspot_app/providers/settings_provider.dart';
import 'package:fishspot_app/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Handles retrieving image URLs from the backend.
///
/// This service uses `ApiService` for network requests and `SettingProvider`
/// to access stored application settings like authentication tokens.
class ImageService {
  late ApiService _apiService;

  ImageService() {
    _apiService = ApiService();
  }

  /// Gets the full URL for an image.
  ///
  /// Takes the image [id] and the [context] to access settings.
  /// Returns an empty string if [id] is null or empty.
  String getImagePath(BuildContext context, String? id) {
    if (id == null || id.isEmpty) {
      return '';
    }

    var settings = Provider.of<SettingProvider>(context, listen: false);
    var token = settings.getString(SharedPreferencesConstants.jwtToken) ?? '';

    return _apiService.getResource(id, token);
  }
}
