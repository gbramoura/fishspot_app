import 'package:fishspot_app/components/custom_button.dart';
import 'package:fishspot_app/constants/colors_constants.dart';
import 'package:flutter/material.dart';

class SpotAddFishPage extends StatefulWidget {
  const SpotAddFishPage({super.key});

  @override
  State<SpotAddFishPage> createState() => _SpotAddFishPageState();
}

class _SpotAddFishPageState extends State<SpotAddFishPage> {
  final _formGlobalKey = GlobalKey<FormState>();
  final _defaultController = TextEditingController();

  String? _defaultValidator(String? value) {
    if (value != null && value.length > 245) {
      return 'Numero maximo de 245 caracters atingida';
    }
    return null;
  }

  _handleNextButton() {
    if (!_formGlobalKey.currentState!.validate()) {
      return;
    }

    // TODO: search a way here to save and share the data between pages
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _renderAppBar(context),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 10),
            Flexible(child: _renderForm(), flex: 7),
            Flexible(child: _renderConfirm(context), flex: 1),
          ],
        ),
      ),
    );
  }

  _renderForm() {
    return Padding(
      padding: EdgeInsets.fromLTRB(20, 0, 30, 0),
      child: Form(
        key: _formGlobalKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Peixe Registrado',
              style: TextStyle(
                color: Theme.of(context).textTheme.headlineLarge?.color,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  _renderConfirm(dynamic context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          CustomButton(
            label: "Confirmar",
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
            'Adicionar Especie',
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
}
