import 'package:fishspot_app/widgets/button.dart';
import 'package:fishspot_app/widgets/custom_dropdown_button.dart';
import 'package:fishspot_app/widgets/text_input.dart';
import 'package:fishspot_app/constants/colors_constants.dart';
import 'package:fishspot_app/enums/unit_measure_type.dart';
import 'package:fishspot_app/models/spot_fish.dart';
import 'package:fishspot_app/providers/spot_data_provider.dart';
import 'package:fishspot_app/services/navigation_service.dart';
import 'package:fishspot_app/services/spot_display_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class SpotAddFishPage extends StatefulWidget {
  const SpotAddFishPage({super.key});

  @override
  State<SpotAddFishPage> createState() => _SpotAddFishPageState();
}

class _SpotAddFishPageState extends State<SpotAddFishPage> {
  final _formFishKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _weightController = TextEditingController();
  final _lureController = TextEditingController();

  UnitMeasureType _measure = UnitMeasureType.grams;

  String? _nameValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Especie não pode ser vazio';
    }
    if (value.length > 245) {
      return 'Numero maximo de 245 caracters atingido';
    }
    return null;
  }

  String? _weightValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Peso não pode ser vazio';
    }
    return null;
  }

  String? _lureValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Isca não pode ser vazio';
    }
    if (value.length > 245) {
      return 'Numero maximo de 245 caracters atingido';
    }
    return null;
  }

  _handleChangeMeasure(String? value) {
    if (value == null || value.isEmpty) {
      return;
    }
    _measure = SpotDisplayService.getUnitMeasureFromText(value);
  }

  _handleNextButton() {
    if (!_formFishKey.currentState!.validate()) {
      return;
    }

    var spotProvider = Provider.of<SpotDataProvider>(context, listen: false);
    var weight = _weightController.text.isEmpty ? "0" : _weightController.text;
    var fish = SpotFish(
      id: Uuid(),
      name: _nameController.text,
      weight: num.parse(weight),
      unitMeasure: _measure,
      lures: [_lureController.text],
    );

    spotProvider.addFishes([fish]);

    NavigationService.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _renderAppBar(context),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              SizedBox(height: 10),
              _renderForm(),
              _renderConfirm(context),
              SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  _renderForm() {
    return Padding(
      padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
      child: Form(
        key: _formFishKey,
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
            SizedBox(height: 10),
            TextInput(
              label: 'Especie',
              validator: _nameValidator,
              controller: _nameController,
              icon: Icons.alternate_email,
            ),
            SizedBox(height: 20),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Flexible(
                  flex: 3,
                  child: TextInput(
                    label: 'Peso',
                    validator: _weightValidator,
                    controller: _weightController,
                    textInputType: TextInputType.number,
                    icon: Icons.fitness_center,
                  ),
                ),
                SizedBox(width: 15),
                Flexible(
                  flex: 3,
                  child: CustomDropdownButton(
                    hintText: 'Escolha',
                    values: UnitMeasureType.values
                        .map((e) => SpotDisplayService.getUnitMeasureText(e))
                        .toList(),
                    onChange: _handleChangeMeasure,
                  ),
                ),
              ],
            ),
            SizedBox(height: 25),
            Text(
              'Iscas',
              style: TextStyle(
                color: Theme.of(context).textTheme.headlineLarge?.color,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 5),
            Text(
              'Coloque a isca utilizada para fisgar o peixe',
              style: TextStyle(
                color: Theme.of(context).textTheme.headlineLarge?.color,
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
            ),
            SizedBox(height: 10),
            TextInput(
              label: 'Isca',
              controller: _lureController,
              validator: _lureValidator,
            ),
            SizedBox(height: 25),
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
          Button(
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
      backgroundColor: Theme.of(context).colorScheme.surface,
      surfaceTintColor: Theme.of(context).colorScheme.surface,
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
