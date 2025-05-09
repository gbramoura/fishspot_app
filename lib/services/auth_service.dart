import 'package:fishspot_app/components/custom_alert_dialog.dart';
import 'package:fishspot_app/components/custom_button.dart';
import 'package:fishspot_app/constants/route_constants.dart';
import 'package:fishspot_app/constants/shared_preferences_constants.dart';
import 'package:fishspot_app/enums/custom_dialog_alert_type.dart';
import 'package:fishspot_app/models/user_tokens.dart';
import 'package:fishspot_app/repositories/location_repository.dart';
import 'package:fishspot_app/repositories/settings_repository.dart';
import 'package:fishspot_app/repositories/spot_repository.dart';
import 'package:fishspot_app/repositories/widget_control_repository.dart';
import 'package:fishspot_app/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AuthService {
  static Future<bool> isUserAuthenticated(dynamic context) async {
    var settings = Provider.of<SettingRepository>(context, listen: false);
    var apiService = ApiService();

    var token = settings.getString(SharedPreferencesConstants.jwtToken);

    if (token == null || token.isEmpty) {
      return false;
    }

    try {
      await apiService.isAuth(token);
      return true;
    } catch (e) {
      return false;
    }
  }

  static Future<void> refreshCredentials(dynamic context) async {
    var settings = Provider.of<SettingRepository>(context, listen: false);
    var apiService = ApiService();

    var token = settings.getString(SharedPreferencesConstants.jwtToken);
    var rToken = settings.getString(SharedPreferencesConstants.refreshToken);
    var userTokens = UserTokens(
      token: token ?? '',
      refreshToken: rToken ?? '',
    );

    var response = await apiService.refreshToken(userTokens.toJson());
    var user = UserTokens.fromJson(response.response);

    settings.setString(SharedPreferencesConstants.jwtToken, user.token);
    settings.setString(
      SharedPreferencesConstants.refreshToken,
      user.refreshToken,
    );
  }

  static void clearCredentials(dynamic context) {
    Provider.of<SettingRepository>(context, listen: false).clear();
    Provider.of<SpotRepository>(context, listen: false).clear();
    Provider.of<LocationRepository>(context, listen: false).clear();
    Provider.of<WidgetControlRepository>(context, listen: false).clear();
    Provider.of<WidgetControlRepository>(context, listen: false).clear();
  }

  static void showAuthDialog(dynamic context) {
    var title = 'Usuário não autenticado';
    var message = 'O usuário não autenticado devido a sessão ter expirado';

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CustomAlertDialog(
          type: CustomDialogAlertType.warn,
          title: title,
          message: message,
          button: CustomButton(
            label: 'Ok',
            fixedSize: Size(double.infinity, 48),
            onPressed: () {
              Navigator.pushNamed(context, RouteConstants.login);
            },
          ),
        );
      },
    );
  }

  static void showInternalErrorDialog(dynamic context) {
    var title = 'Erro Interno do Servidor';
    var message =
        'Devido a um erro desconhecido no servidor não é possivel seguir com a utilização do software';

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CustomAlertDialog(
          type: CustomDialogAlertType.error,
          title: title,
          message: message,
          button: CustomButton(
            label: 'Ok',
            fixedSize: Size(double.infinity, 48),
            onPressed: () {
              Navigator.pushNamed(context, RouteConstants.login);
            },
          ),
        );
      },
    );
  }
}
