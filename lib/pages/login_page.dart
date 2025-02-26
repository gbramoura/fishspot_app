import 'package:fishspot_app/components/custom_input_form_text.dart';
import 'package:flutter/material.dart';

import '../components/custom_button.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  bool passwordObscureText = true;

  void handlePressedPasswordObscureText() {
    setState(() {
      passwordObscureText = !passwordObscureText;
    });
  }

  Widget renderVisibleIcon(bool isVisible) {
    return Icon(
      isVisible ? Icons.visibility : Icons.visibility_off,
      color: Theme.of(context).iconTheme.color,
    );
  }

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
                  CustomInputFormText(
                    controller: usernameController,
                    hintText: 'Email',
                    icon: Icon(
                      Icons.email,
                      color: Theme.of(context).iconTheme.color,
                    ),
                  ),
                  SizedBox(height: 25),
                  CustomInputFormText(
                    controller: passwordController,
                    hintText: 'Senha',
                    obscureText: passwordObscureText,
                    icon: Icon(
                      Icons.lock,
                      color: Theme.of(context).iconTheme.color,
                    ),
                    actionIcon: IconButton(
                      onPressed: handlePressedPasswordObscureText,
                      icon: renderVisibleIcon(passwordObscureText),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, 15, 0, 0),
                    child: Semantics(
                      label: 'Esqueceu sua senha?',
                      button: true,
                      child: GestureDetector(
                        onTap: () {},
                        child: RichText(
                          text: TextSpan(
                            text: 'Esqueceu sua senha?',
                            style: Theme.of(context).textTheme.displayMedium,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 55),
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
                      text: 'Não possui uma conta?',
                      style: Theme.of(context).textTheme.displayMedium,
                    ),
                  ),
                  SizedBox(width: 5),
                  Semantics(
                    label: 'Registre-se',
                    button: true,
                    child: GestureDetector(
                      onTap: () {},
                      child: RichText(
                        text: TextSpan(
                          text: 'Registre-se',
                          style: TextStyle(
                            color:
                                Theme.of(context).textTheme.labelSmall?.color,
                            fontWeight: Theme.of(context)
                                .textTheme
                                .labelSmall
                                ?.fontWeight,
                            fontSize: Theme.of(context)
                                .textTheme
                                .labelSmall
                                ?.fontSize,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
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
