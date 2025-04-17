import 'package:fishspot_app/components/custom_button.dart';
import 'package:fishspot_app/components/custom_dropdown_button.dart';
import 'package:fishspot_app/components/custom_text_form_field.dart';
import 'package:fishspot_app/constants/colors_constants.dart';
import 'package:fishspot_app/enums/unit_measure_type.dart';
import 'package:fishspot_app/models/spot_fish.dart';
import 'package:fishspot_app/repositories/spot_repository.dart';
import 'package:fishspot_app/services/navigation_service.dart';
import 'package:fishspot_app/utils/spot_view_utils.dart';
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
  final _formLuresKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _weightController = TextEditingController();
  final _lureController = TextEditingController();
  final Map<Uuid, String> _lures = {};

  UnitMeasureType _measure = UnitMeasureType.Grams;
  bool _globalValidatorSwitch = true;

  String? _nameValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Especie não pode ser vazio';
    }
    if (value.length > 245) {
      return 'Numero maximo de 245 caracters atingida';
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
    if (_globalValidatorSwitch && _lures.isEmpty) {
      return 'No minimo uma isca deve ser incluida';
    }
    if (!_globalValidatorSwitch && _lures.entries.length >= 3) {
      return 'O maximo de 3 iscas foi atingido';
    }
    if (!_globalValidatorSwitch && (value == null || value.isEmpty)) {
      return 'Isca não pode ser vazio';
    }
    return null;
  }

  _handleChangeMeasure(String? value) {
    if (value == null || value.isEmpty) {
      return;
    }
    _measure = SpotViewUtils.getUnitMeasureFromText(value);
  }

  _handleAddLure() {
    _globalValidatorSwitch = false;

    if (!_formLuresKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _lures.addAll({Uuid(): _lureController.text});
      _lureController.text = '';
    });
  }

  _handleRemoveLure(Uuid id) {
    setState(() {
      _lures.removeWhere((uuid, lure) => uuid == id);
    });
  }

  _handleNextButton() {
    _globalValidatorSwitch = true;

    var fishValidate = _formFishKey.currentState!.validate();
    var lureValidate = _formLuresKey.currentState!.validate();

    if (!fishValidate || !lureValidate) {
      return;
    }

    var addSpot = Provider.of<SpotRepository>(context, listen: false);
    var weight = _weightController.text.isEmpty ? "0" : _weightController.text;
    var fish = SpotFish(
      id: Uuid(),
      name: _nameController.text,
      weight: num.parse(weight),
      unitMeasure: _measure,
      lures: _lures.entries.map((e) => e.value).toList(),
    );

    addSpot.addFishes([fish]);

    NavigationService.pop(context);
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
            Flexible(child: _renderForms(), flex: 7),
            Flexible(child: _renderConfirm(context), flex: 1),
          ],
        ),
      ),
    );
  }

  _renderForms() {
    return Column(
      children: [
        _renderFishForm(),
        Expanded(child: _renderLuresForm()),
      ],
    );
  }

  _renderFishForm() {
    return Padding(
      padding: EdgeInsets.fromLTRB(20, 0, 30, 0),
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
            CustomTextFormField(
              validator: _nameValidator,
              controller: _nameController,
              hintText: 'Especie',
              textInputType: TextInputType.number,
              icon: Icon(
                Icons.alternate_email,
                color: Theme.of(context).iconTheme.color,
              ),
            ),
            SizedBox(height: 20),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Flexible(
                  flex: 3,
                  child: CustomTextFormField(
                    validator: _weightValidator,
                    controller: _weightController,
                    hintText: 'Peso',
                    icon: Icon(
                      Icons.fitness_center,
                      color: Theme.of(context).iconTheme.color,
                    ),
                  ),
                ),
                SizedBox(width: 15),
                Flexible(
                  flex: 2,
                  child: CustomDropdownButton(
                    hintText: 'Escolha',
                    values: UnitMeasureType.values
                        .map((e) => SpotViewUtils.getUnitMeasureText(e))
                        .toList(),
                    onChange: _handleChangeMeasure,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  _renderLuresForm() {
    return Padding(
      padding: EdgeInsets.fromLTRB(20, 0, 30, 0),
      child: Form(
        key: _formLuresKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
              'Informe ate 3 tipos de iscas ',
              style: TextStyle(
                color: Theme.of(context).textTheme.headlineLarge?.color,
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
            ),
            SizedBox(height: 10),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Flexible(
                  flex: 5,
                  child: CustomTextFormField(
                    controller: _lureController,
                    validator: _lureValidator,
                    hintText: 'Isca',
                  ),
                ),
                SizedBox(width: 15),
                Flexible(
                  flex: 1,
                  child: CustomButton(
                    label: '',
                    icon: Icon(
                      Icons.add,
                      color: Theme.of(context).textTheme.labelMedium?.color,
                      size: 42,
                    ),
                    onPressed: _handleAddLure,
                    fixedSize: Size(50, 53),
                  ),
                ),
              ],
            ),
            SizedBox(height: 25),
            Expanded(child: _renderLures())
          ],
        ),
      ),
    );
  }

  _renderLures() {
    return ListView.builder(
      scrollDirection: Axis.vertical,
      primary: false,
      shrinkWrap: true,
      itemCount: _lures.entries.length,
      itemBuilder: (context, index) {
        return Container(
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.fromLTRB(20, 10, 10, 10),
          decoration: BoxDecoration(
            color: Theme.of(context).textTheme.headlineLarge?.color,
            border: Border.all(
              color: ColorsConstants.gray150,
              width: 1.0,
            ),
            borderRadius: BorderRadius.circular(5),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                _lures.entries.toList()[index].value,
                style: TextStyle(
                  color: Theme.of(context).textTheme.labelMedium?.color,
                  fontWeight: FontWeight.w400,
                  fontSize: 14,
                ),
              ),
              GestureDetector(
                onTap: () =>
                    _handleRemoveLure(_lures.entries.toList()[index].key),
                child: Icon(
                  Icons.delete,
                  color: Theme.of(context).textTheme.labelMedium?.color,
                  size: 24,
                ),
              )
            ],
          ),
        );
      },
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
