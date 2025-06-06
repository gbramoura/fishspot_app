import 'package:fishspot_app/widgets/button.dart';
import 'package:fishspot_app/widgets/select_input.dart';
import 'package:fishspot_app/constants/colors_constants.dart';
import 'package:fishspot_app/enums/spot_difficulty_type.dart';
import 'package:fishspot_app/enums/spot_risk_type.dart';
import 'package:fishspot_app/pages/commons/loading_page.dart';
import 'package:fishspot_app/pages/spot/spot_image_page.dart';
import 'package:fishspot_app/providers/spot_data_provider.dart';
import 'package:fishspot_app/services/navigation_service.dart';
import 'package:fishspot_app/services/spot_display_service.dart';
import 'package:fishspot_app/widgets/text_input.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SpotDescriptionPage extends StatefulWidget {
  const SpotDescriptionPage({super.key});

  @override
  State<SpotDescriptionPage> createState() => _SpotDescriptionPageState();
}

class _SpotDescriptionPageState extends State<SpotDescriptionPage> {
  final NavigationService _navigationService = NavigationService();

  final _formGlobalKey = GlobalKey<FormState>();
  final _riskObservationController = TextEditingController();
  final _difficultyObservationController = TextEditingController();

  SpotDifficultyType _difficulty = SpotDifficultyType.veryEasy;
  SpotRiskType _risk = SpotRiskType.veryLow;
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  _loadData() {
    setState(() {
      _loading = true;
    });

    var spotProvider = Provider.of<SpotDataProvider>(context, listen: false);
    var difficulty = spotProvider.getDifficulty();
    var risk = spotProvider.getRisk();

    setState(() {
      _riskObservationController.text = risk.observation;
      _risk = risk.rate;
      _difficultyObservationController.text = difficulty.observation;
      _difficulty = difficulty.rate;
      _loading = false;
    });
  }

  String? _riskObservationValidator(String? value) {
    if (value != null && value.length > 245) {
      return 'Numero maximo de 245 caracters atingida';
    }
    return null;
  }

  String? _difficultyObservationValidator(String? value) {
    if (value != null && value.length > 245) {
      return 'Numero maximo de 245 caracters atingida';
    }
    return null;
  }

  _handleChangeDifficulty(String? value) {
    if (value == null || value.isEmpty) {
      return;
    }
    _difficulty = SpotDisplayService.getDifficultyFromText(value);
  }

  _handleChangeRisk(String? value) {
    if (value == null || value.isEmpty) {
      return;
    }
    _risk = SpotDisplayService.getRiskFromText(value);
  }

  _handleNextButton() {
    if (!_formGlobalKey.currentState!.validate()) {
      return;
    }

    var route = MaterialPageRoute(builder: (context) => SpotImagePage());
    var spotProvider = Provider.of<SpotDataProvider>(context, listen: false);

    spotProvider.setDifficulty(
      _difficulty,
      _difficultyObservationController.text,
    );
    spotProvider.setRisk(
      _risk,
      _riskObservationController.text,
    );

    _navigationService.push(context, route);
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return LoadingPage();
    }

    return Scaffold(
      appBar: _renderAppBar(context),
      body: SingleChildScrollView(
        child: Center(
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
              'Localização',
              style: TextStyle(
                color: Theme.of(context).textTheme.headlineLarge?.color,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 5),
            Text(
              'Qual a dificuldade de chegar no local?',
              style: TextStyle(
                color: Theme.of(context).textTheme.headlineLarge?.color,
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
            ),
            SizedBox(height: 15),
            SelectInput(
              hintText: 'Escolha',
              values: SpotDifficultyType.values
                  .map((e) => SpotDisplayService.getDifficultyText(e))
                  .toList(),
              onChange: _handleChangeDifficulty,
            ),
            SizedBox(height: 20),
            SizedBox(
              height: 120,
              width: double.infinity,
              child: TextInput(
                label: 'Observação',
                validator: _riskObservationValidator,
                controller: _riskObservationController,
                textInputType: TextInputType.multiline,
                expands: true,
                maxLines: null,
              ),
            ),
            SizedBox(height: 25),
            Text(
              'Riscos ou Perigos',
              style: TextStyle(
                color: Theme.of(context).textTheme.headlineLarge?.color,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 5),
            Text(
              'Qual o nivel de risco ou perigo do local?',
              style: TextStyle(
                color: Theme.of(context).textTheme.headlineLarge?.color,
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
            ),
            SizedBox(height: 15),
            SelectInput(
              hintText: 'Escolha',
              values: SpotRiskType.values
                  .map((e) => SpotDisplayService.getRiskText(e))
                  .toList(),
              onChange: _handleChangeRisk,
            ),
            SizedBox(height: 20),
            SizedBox(
              height: 120,
              width: double.infinity,
              child: TextInput(
                label: 'Observação',
                validator: _difficultyObservationValidator,
                controller: _difficultyObservationController,
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
            label: "Proximo",
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
      surfaceTintColor: Theme.of(context).colorScheme.surface,
      titleSpacing: 0,
      title: Row(
        children: [
          Text(
            'Dificuldades e Riscos',
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
