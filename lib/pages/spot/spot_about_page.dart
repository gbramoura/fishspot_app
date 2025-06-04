import 'package:fishspot_app/widgets/custom_alert_dialog.dart';
import 'package:fishspot_app/widgets/button.dart';
import 'package:fishspot_app/widgets/date_input.dart';
import 'package:fishspot_app/widgets/text_input.dart';
import 'package:fishspot_app/constants/colors_constants.dart';
import 'package:fishspot_app/constants/route_constants.dart';
import 'package:fishspot_app/constants/shared_preferences_constants.dart';
import 'package:fishspot_app/enums/custom_dialog_alert_type.dart';
import 'package:fishspot_app/models/http_multipart_file.dart';
import 'package:fishspot_app/pages/commons/loading_page.dart';
import 'package:fishspot_app/providers/settings_provider.dart';
import 'package:fishspot_app/providers/spot_data_provider.dart';
import 'package:fishspot_app/services/api_service.dart';
import 'package:fishspot_app/services/navigation_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class SpotAboutPage extends StatefulWidget {
  const SpotAboutPage({super.key});

  @override
  State<SpotAboutPage> createState() => _SpotAboutPageState();
}

class _SpotAboutPageState extends State<SpotAboutPage> {
  final _apiService = ApiService();
  final _formGlobalKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _dateController = TextEditingController();
  final _observationController = TextEditingController();

  bool _loading = false;
  String _loadingMessage = "";

  String? _titleValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Titulo não pode ser vazio';
    }
    if (value.length > 245) {
      return 'Numero maximo de 245 caracters atingida';
    }
    return null;
  }

  String? _observationValidator(String? value) {
    if (value != null && value.length > 245) {
      return 'Numero maximo de 245 caracters atingida';
    }
    return null;
  }

  String? _dateValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Data não pode ser vazio';
    }
    return null;
  }

  _handleNextButton() async {
    if (!_formGlobalKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _loading = true;
      _loadingMessage = "A gravação dos dados \n pode levar tempo";
    });

    var settings = Provider.of<SettingProvider>(context, listen: false);
    var spotProvider = Provider.of<SpotDataProvider>(context, listen: false);
    var token = settings.getString(SharedPreferencesConstants.jwtToken) ?? '';
    var spotId = "";

    try {
      spotProvider.setDescription(
        _titleController.text,
        _observationController.text,
        DateFormat("dd/MM/yyyy").parse(_dateController.text),
      );

      var createSpotResponse = await _apiService.createSpot(
        spotProvider.toPayload(),
        token,
      );

      spotId = createSpotResponse.response["id"];

      // Atach image
      if (spotProvider.getImages().isNotEmpty) {
        var fields = {"spotId": spotId};
        var files = spotProvider
            .getImages()
            .map((e) => HttpMultipartFile(file: e.file, path: 'files'))
            .toList();

        await _apiService.attachspotImage(files, fields, token);
      }

      _renderDialog(
        CustomDialogAlertType.success,
        "Registro feito",
        "Sua pesca foi registrada com sucesso!",
      );
    } catch (e) {
      if (spotId.isNotEmpty) {
        await _apiService.deleteSpot(spotId, token);
      }

      _renderDialog(
        CustomDialogAlertType.error,
        "Falha ao Registrar",
        "Não foi possivel registrar uma pesca devido a um erro inesperado",
      );
    }

    setState(() {
      _loading = false;
      _loadingMessage = "";
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return LoadingPage(message: _loadingMessage);
    }

    return Scaffold(
      appBar: _renderAppBar(context),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(height: 10),
            _renderForm(),
            _renderNext(context),
            SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  _renderForm() {
    return Padding(
      padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
      child: Form(
        key: _formGlobalKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Titulo da pesca',
              style: TextStyle(
                color: Theme.of(context).textTheme.headlineLarge?.color,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 5),
            Text(
              'Nomeie o seu local de pesca',
              style: TextStyle(
                color: Theme.of(context).textTheme.headlineLarge?.color,
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
            ),
            SizedBox(height: 15),
            TextInput(
              label: 'Titulo',
              validator: _titleValidator,
              controller: _titleController,
              icon: Icons.description,
            ),
            SizedBox(height: 20),
            DateInput(
              label: 'Data do registro da pesca',
              controller: _dateController,
              validator: _dateValidator,
            ),
            SizedBox(height: 25),
            Text(
              'Observação da pesca',
              style: TextStyle(
                color: Theme.of(context).textTheme.headlineLarge?.color,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 5),
            Text(
              'De uma breve descrição sobre a pesca',
              style: TextStyle(
                color: Theme.of(context).textTheme.headlineLarge?.color,
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
            ),
            SizedBox(height: 15),
            SizedBox(
              height: 120,
              width: double.infinity,
              child: TextInput(
                label: 'Observação',
                validator: _observationValidator,
                controller: _observationController,
                textInputType: TextInputType.multiline,
                expands: true,
                maxLines: null,
              ),
            ),
            SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  _renderNext(dynamic context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Button(
            label: "Finalizar",
            onPressed: _handleNextButton,
            fixedSize: Size(182, 48),
          ),
        ],
      ),
    );
  }

  _renderAppBar(dynamic context) {
    return AppBar(
      shadowColor: ColorsConstants.gray350,
      title: Row(
        children: [
          Text(
            'Sobre e Observação',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: Theme.of(context).textTheme.headlineLarge?.color,
              fontSize: 18,
            ),
          ),
        ],
      ),
    );
  }

  void _renderDialog(
    CustomDialogAlertType type,
    String title,
    String? message,
  ) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CustomAlertDialog(
          type: type,
          title: title,
          message: message ?? "",
          button: Button(
            label: 'Ok',
            fixedSize: Size(double.infinity, 48),
            onPressed: () {
              Provider.of<SpotDataProvider>(context, listen: false).clear();
              NavigationService.popUntil(context, [RouteConstants.home]);
            },
          ),
        );
      },
    );
  }
}
