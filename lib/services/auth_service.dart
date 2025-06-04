import 'package:fishspot_app/enums/custom_dialog_alert_type.dart';
import 'package:fishspot_app/constants/route_constants.dart';
import 'package:fishspot_app/constants/shared_preferences_constants.dart';
import 'package:fishspot_app/models/user_tokens.dart';
import 'package:fishspot_app/providers/location_provider.dart';
import 'package:fishspot_app/providers/recover_password_provider.dart';
import 'package:fishspot_app/providers/settings_provider.dart';
import 'package:fishspot_app/providers/spot_data_provider.dart';
import 'package:fishspot_app/providers/visible_control_provider.dart';
import 'package:fishspot_app/services/api_service.dart';
import 'package:fishspot_app/widgets/alert_modal.dart';
import 'package:fishspot_app/widgets/button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AuthService {
  late ApiService _apiService;

  AuthService() {
    _apiService = ApiService();
  }

  Future<bool> isUserAuthenticated(BuildContext context) async {
    var settings = Provider.of<SettingProvider>(context, listen: false);
    var token = settings.getString(SharedPreferencesConstants.jwtToken);

    if (token == null || token.isEmpty) {
      return false;
    }

    try {
      await _apiService.isAuth(token);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<void> refreshCredentials(BuildContext context) async {
    var settings = Provider.of<SettingProvider>(context, listen: false);
    var token = settings.getString(SharedPreferencesConstants.jwtToken);
    var rToken = settings.getString(SharedPreferencesConstants.refreshToken);
    var userTokens = UserTokens(
      token: token ?? '',
      refreshToken: rToken ?? '',
    );

    var response = await _apiService.refreshToken(userTokens.toJson());
    var user = UserTokens.fromJson(response.response);

    settings.setString(SharedPreferencesConstants.jwtToken, user.token);
    settings.setString(
      SharedPreferencesConstants.refreshToken,
      user.refreshToken,
    );
  }

  void clearCredentials(BuildContext context) {
    Provider.of<SettingProvider>(context, listen: false).clear();
    Provider.of<SpotDataProvider>(context, listen: false).clear();
    Provider.of<LocationProvider>(context, listen: false).clear();
    Provider.of<VisibleControlProvider>(context, listen: false).clear();
    Provider.of<RecoverPasswordProvider>(context, listen: false).clear();
  }

  void showAuthDialog(BuildContext context) {
    var title = 'Usuário não autenticado';
    var message = 'O usuário não autenticado devido a sessão ter expirado';

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertModal(
          type: CustomDialogAlertType.warn,
          title: title,
          message: message,
          button: Button(
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

  void showInternalErrorDialog(BuildContext context) {
    var title = 'Erro Interno do Servidor';
    var message =
        'Devido a um erro desconhecido no servidor não é possivel seguir com a utilização do software';

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertModal(
          type: CustomDialogAlertType.warn,
          title: title,
          message: message,
          button: Button(
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
