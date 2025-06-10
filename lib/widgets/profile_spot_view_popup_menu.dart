import 'package:fishspot_app/constants/route_constants.dart';
import 'package:fishspot_app/enums/custom_dialog_alert_type.dart';
import 'package:fishspot_app/enums/profile_menu_item_type.dart';
import 'package:fishspot_app/services/api_service.dart';
import 'package:fishspot_app/services/navigation_service.dart';
import 'package:fishspot_app/widgets/alert_modal.dart';
import 'package:fishspot_app/widgets/button.dart';
import 'package:flutter/material.dart';

class ProfileSpotViewPopupMenu extends StatelessWidget {
  final String token;
  final String spotId;
  final BuildContext context;

  ProfileSpotViewPopupMenu({
    super.key,
    required this.context,
    required this.token,
    required this.spotId,
  });

  final ApiService _apiService = ApiService();

  final NavigationService _navigationService = NavigationService();

  void _delete() async {
    try {
      await _apiService.deleteSpot(spotId, token);
      await _showDeletedSuccess();

      if (context.mounted) {
        _navigationService.pop(context, result: true);
      }
    } catch (err) {
      _showDeletedFailed();
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<ProfileMenuItemType>(
      itemBuilder: _buildItems,
      child: Padding(
        padding: EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 16),
        child: Icon(Icons.more_horiz),
      ),
      onSelected: (ProfileMenuItemType item) {
        switch (item) {
          case ProfileMenuItemType.delete:
            _delete();
            break;
        }
      },
    );
  }

  List<PopupMenuEntry<ProfileMenuItemType>> _buildItems(BuildContext context) {
    return [
      PopupMenuItem<ProfileMenuItemType>(
        value: ProfileMenuItemType.delete,
        child: Row(
          children: [
            Icon(Icons.delete),
            SizedBox(width: 10),
            Text('Remover registro de pesca'),
          ],
        ),
      ),
    ];
  }

  Future<void> _showDeletedSuccess() {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertModal(
          type: CustomDialogAlertType.warn,
          title: "Deletado com Sucesso",
          message: "O registro de pesca foi deletado com sucesso",
          button: Button(
            label: 'Ok',
            fixedSize: Size(100, 48),
            onPressed: () {
              _navigationService.pop(context);
            },
          ),
        );
      },
    );
  }

  void _showDeletedFailed() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertModal(
          type: CustomDialogAlertType.success,
          title: "Erro ao Deletar",
          message:
              "Devido a um erro inesperado, não foi possivel deletar registro de pesca.",
          button: Button(
            label: 'Ok',
            fixedSize: Size(100, 48),
            onPressed: () {
              _navigationService.popUntil(context, [RouteConstants.home]);
            },
          ),
        );
      },
    );
  }
}
