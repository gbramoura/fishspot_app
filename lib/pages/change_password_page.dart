import 'package:flutter/material.dart';

import '../components/custom_button.dart';
import '../components/custom_input_text.dart';

class ChangePasswordPage extends StatelessWidget {
  ChangePasswordPage({super.key});

  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

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
                'Redefinir Senha',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(20, 10, 20, 45),
                child: Text(
                  "Informe a nova senha e a confirmação da propria",
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
              ),
              Column(
                children: [
                  SizedBox(height: 10),
                  CustomInputText(
                    controller: passwordController,
                    hintText: 'Senha',
                    icon: Icon(
                      Icons.lock,
                      color: Theme.of(context).iconTheme.color,
                    ),
                    obscureText: true,
                  ),
                  SizedBox(height: 25),
                  CustomInputText(
                    controller: confirmPasswordController,
                    hintText: 'Confirmar Senha',
                    icon: Icon(
                      Icons.lock,
                      color: Theme.of(context).iconTheme.color,
                    ),
                    obscureText: true,
                  ),
                ],
              ),
              SizedBox(height: 45),
              CustomButton(
                onPressed: () {},
                fixedSize: Size(286, 48),
                label: 'Redefinir Senha',
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
                  Semantics(
                    label: 'Cancelar',
                    button: true,
                    child: GestureDetector(
                      onTap: () {},
                      child: RichText(
                        text: TextSpan(
                          text: 'Cancelar',
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
