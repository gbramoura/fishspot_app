import 'package:fishspot_app/components/custom_alert_dialog.dart';
import 'package:fishspot_app/components/custom_button.dart';
import 'package:fishspot_app/components/custom_text_form_field.dart';
import 'package:fishspot_app/constants/colors_constants.dart';
import 'package:fishspot_app/constants/route_constants.dart';
import 'package:fishspot_app/constants/shared_preferences_constants.dart';
import 'package:fishspot_app/enums/custom_dialog_alert_type.dart';
import 'package:fishspot_app/models/http_multipart_file.dart';
import 'package:fishspot_app/pages/commons/loading_page.dart';
import 'package:fishspot_app/repositories/settings_repository.dart';
import 'package:fishspot_app/repositories/spot_repository.dart';
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

    var settings = Provider.of<SettingRepository>(context, listen: false);
    var spotRepo = Provider.of<SpotRepository>(context, listen: false);
    var token = settings.getString(SharedPreferencesConstants.jwtToken) ?? '';
    var spotId = "";

    try {
      spotRepo.setDescription(
        _titleController.text,
        _observationController.text,
        DateFormat("dd/MM/yyyy").parse(_dateController.text),
      );

      var createSpotResponse = await _apiService.createSpot(
        spotRepo.toPayload(),
        token,
      );

      spotId = createSpotResponse.response["id"];

      // Atach image
      if (spotRepo.getImages().isNotEmpty) {
        var fields = {"spotId": spotId};
        var files = spotRepo
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

  _handleDatePicker() async {
    DateTime? date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (date != null) {
      setState(() {
        _dateController.text = DateFormat("dd/MM/yyyy").format(date);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return LoadingPage(message: _loadingMessage);
    }

    return Scaffold(
      appBar: _renderAppBar(context),
      body: Center(
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
            CustomTextFormField(
              validator: _titleValidator,
              controller: _titleController,
              textInputType: TextInputType.text,
              hintText: 'Titulo',
              icon: Icon(
                Icons.description,
                color: Theme.of(context).iconTheme.color,
              ),
            ),
            SizedBox(height: 20),
            CustomTextFormField(
              controller: _dateController,
              validator: _dateValidator,
              hintText: 'Data do registro da pesca',
              textInputType: TextInputType.datetime,
              icon: Icon(
                Icons.date_range,
                color: Theme.of(context).iconTheme.color,
              ),
              onTap: _handleDatePicker,
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
              child: CustomTextFormField(
                validator: _observationValidator,
                controller: _observationController,
                textInputType: TextInputType.multiline,
                hintText: 'Observação',
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
          CustomButton(
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
          button: CustomButton(
            label: 'Ok',
            fixedSize: Size(double.infinity, 48),
            onPressed: () {
              Provider.of<SpotRepository>(context, listen: false).clear();
              NavigationService.popUntil(context, [RouteConstants.home]);
            },
          ),
        );
      },
    );
  }
}
