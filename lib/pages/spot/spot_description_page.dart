import 'package:fishspot_app/components/custom_button.dart';
import 'package:fishspot_app/components/custom_text_form_field.dart';
import 'package:fishspot_app/constants/colors_constants.dart';
import 'package:fishspot_app/pages/spot/spot_image_page.dart';
import 'package:fishspot_app/repositories/add_spot_repository.dart';
import 'package:fishspot_app/services/navigation_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SpotDescriptionPage extends StatefulWidget {
  const SpotDescriptionPage({super.key});

  @override
  State<SpotDescriptionPage> createState() => _SpotDescriptionPageState();
}

class _SpotDescriptionPageState extends State<SpotDescriptionPage> {
  final _formGlobalKey = GlobalKey<FormState>();
  final _riskRateController = TextEditingController();
  final _riskObservationController = TextEditingController();
  final _difficultyRateController = TextEditingController();
  final _difficultyObservationController = TextEditingController();

  String? _riskRateValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'O risco não pode ser vazio';
    }
    return null;
  }

  String? _riskObservationValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'A observação não pode ser vazio';
    }
    return null;
  }

  String? _difficultyRateValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'A dificuldade não pode ser vazio';
    }
    return null;
  }

  String? _difficultyObservationValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'A observação não pode ser vazio';
    }
    return null;
  }

  _handleNextButton() {
    var route = MaterialPageRoute(builder: (context) => SpotImagePage());
    var addSpot = Provider.of<AddSpotRepository>(context, listen: false);

    NavigationService.push(context, route);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _renderAppBar(context),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            _renderForm(),
            _renderNext(context),
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
            // TODO: Change to select
            CustomTextFormField(
              validator: _riskRateValidator,
              controller: _riskRateController,
              hintText: 'Escolha',
            ),
            SizedBox(height: 20),
            SizedBox(
              height: 120,
              width: double.infinity,
              child: CustomTextFormField(
                validator: _riskObservationValidator,
                controller: _riskObservationController,
                textInputType: TextInputType.multiline,
                hintText: 'Observação',
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
            // TODO: Change to select
            CustomTextFormField(
              validator: _difficultyRateValidator,
              controller: _difficultyRateController,
              hintText: 'Escolha',
            ),
            SizedBox(height: 20),
            SizedBox(
              height: 120,
              width: double.infinity,
              child: CustomTextFormField(
                validator: _difficultyObservationValidator,
                controller: _difficultyObservationController,
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
