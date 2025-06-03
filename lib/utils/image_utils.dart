import 'package:fishspot_app/constants/shared_preferences_constants.dart';
import 'package:fishspot_app/providers/settings_repository.dart';
import 'package:fishspot_app/services/api_service.dart';
import 'package:provider/provider.dart';

class ImageUtils {
  static String getImagePath(String? id, dynamic context) {
    if (id == null || id.isEmpty) {
      return "";
    }

    var apiService = ApiService();
    var settings = Provider.of<SettingRepository>(context, listen: false);
    var token = settings.getString(SharedPreferencesConstants.jwtToken) ?? '';

    return apiService.getResource(id, token);
  }
}
