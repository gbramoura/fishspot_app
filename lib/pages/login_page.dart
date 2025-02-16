import 'package:fishspot_app/components/custom_input_text.dart';
import 'package:fishspot_app/utils/hex_color_utils.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../components/custom_button.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

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
                'Bem-Vindo',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(10, 10, 10, 45),
                child: Text(
                  "Seja bem vindo ao aplicativo para registro de locais de pesca",
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
              ),
              Column(
                children: [
                  SizedBox(height: 10),
                  CustomInputText(
                    controller: usernameController,
                    hintText: 'Email',
                    obscureText: false,
                    icon: Icon(
                      Icons.email,
                      color: HexColor('#666B70'),
                    ),
                  ),
                  SizedBox(height: 25),
                  CustomInputText(
                    controller: passwordController,
                    hintText: 'Senha',
                    obscureText: true,
                    icon: Icon(
                      Icons.lock,
                      color: HexColor('#666B70'),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, 15, 0, 0),
                    child: RichText(
                      text: TextSpan(
                        text: 'Esqueceu sua senha?',
                        style: Theme.of(context).textTheme.displayMedium,
                        recognizer: TapGestureRecognizer()..onTap = () => {},
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 40),
              CustomButton(
                onPressed: () {},
                fixedSize: Size(286, 48),
                label: 'Entrar',
              ),
              SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  RichText(
                    text: TextSpan(
                      children: <TextSpan>[
                        TextSpan(
                          text: 'Não possui uma conta? ',
                          style: Theme.of(context).textTheme.displayMedium,
                        ),
                        TextSpan(
                          text: 'Registre-se',
                          style: Theme.of(context).textTheme.labelSmall,
                          recognizer: TapGestureRecognizer()..onTap = () => {},
                        ),
                      ],
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
