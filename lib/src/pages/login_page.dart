import 'package:fishspot_app/src/components/custom_input_text.dart';
import 'package:fishspot_app/src/components/custom_text_button.dart';
import 'package:fishspot_app/src/utils/hex_color_utils.dart';
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
      backgroundColor: HexColor('#292A2C'),
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
                style: TextStyle(
                    color: HexColor('#F8FAFC'),
                    fontWeight: FontWeight.w500,
                    fontSize: 42),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(10, 10, 10, 45),
                child: Text(
                  "Seja bem vindo ao aplicativo para registro de locais de pesca",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: HexColor('#E2E8F0'),
                    fontWeight: FontWeight.w500,
                    fontSize: 18,
                  ),
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
                    child: Text(
                      'Esqueceu sua senha?',
                      style: TextStyle(
                        color: HexColor('#F8FAFC'),
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 50),
              CustomButton(
                onPressed: () {},
                fixedSize: Size(286, 48),
                label: 'Entrar',
              ),
              SizedBox(height: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Não possui uma conta?',
                    style: TextStyle(
                      color: HexColor('#F8FAFC'),
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                    ),
                  ),
                  CustomTextButton(
                    label: 'Registre-se',
                    onPressed: () {},
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
