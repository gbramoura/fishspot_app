import 'package:fishspot_app/components/custom_text_button.dart';
import 'package:flutter/material.dart';

import '../../components/custom_button.dart';
import '../../components/custom_text_field.dart';

class ValidateRecoverPasswordPage extends StatelessWidget {
  ValidateRecoverPasswordPage({super.key});

  final oneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(0, 25, 0, 0),
                  child: Image(
                    height: 250,
                    width: 250,
                    image: AssetImage('assets/images/fish-spot-icon.png'),
                  ),
                ),
              ),
              Text(
                'Recuperar Senha',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(15, 10, 15, 45),
                child: Text(
                  "Um token de acesso foi enviado para o e-mail informado",
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
              ),
              Column(
                children: [
                  SizedBox(height: 10),
                  CustomTextField(
                    controller: oneController,
                    hintText: '-',
                  ),
                ],
              ),
              SizedBox(height: 45),
              CustomButton(
                onPressed: () {},
                fixedSize: Size(286, 48),
                label: 'Confirmar Token',
              ),
              SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  RichText(
                    text: TextSpan(
                      text: 'Deseja cancelar a recuperação de senha?',
                      style: Theme.of(context).textTheme.displayMedium,
                    ),
                  ),
                  SizedBox(width: 5),
                  CustomTextButton(
                    label: 'Cancelar',
                    onTap: () {},
                    style: TextStyle(
                      color: Theme.of(context).textTheme.labelSmall?.color,
                      fontWeight:
                          Theme.of(context).textTheme.labelSmall?.fontWeight,
                      fontSize:
                          Theme.of(context).textTheme.labelSmall?.fontSize,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
