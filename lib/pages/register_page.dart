import 'package:fishspot_app/components/custom_input_text.dart';
import 'package:flutter/material.dart';

import '../components/custom_button.dart';

class RegisterPage extends StatefulWidget {
  RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  bool passwordObscureText = true;
  bool confirmPasswordObscureText = true;

  handlePressedPasswordObscureText() {
    setState(() {
      passwordObscureText = !passwordObscureText;
    });
  }

  handlePressedConfirmPasswordObscureText() {
    setState(() {
      confirmPasswordObscureText = !confirmPasswordObscureText;
    });
  }

  renderVisibleIcon(bool isVisible) {
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
                'Registre-se',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              SizedBox(height: 35),
              Column(
                children: [
                  CustomInputText(
                    controller: usernameController,
                    hintText: 'Name',
                    icon: Icon(
                      Icons.person,
                      color: Theme.of(context).iconTheme.color,
                    ),
                  ),
                  SizedBox(height: 25),
                  CustomInputText(
                    controller: emailController,
                    hintText: 'E-mail',
                    icon: Icon(
                      Icons.email,
                      color: Theme.of(context).iconTheme.color,
                    ),
                  ),
                  SizedBox(height: 25),
                  CustomInputText(
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
                  SizedBox(height: 25),
                  CustomInputText(
                    controller: confirmPasswordController,
                    hintText: 'Confirmar Senha',
                    obscureText: confirmPasswordObscureText,
                    icon: Icon(
                      Icons.lock,
                      color: Theme.of(context).iconTheme.color,
                    ),
                    actionIcon: IconButton(
                      onPressed: handlePressedConfirmPasswordObscureText,
                      icon: renderVisibleIcon(confirmPasswordObscureText),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 45),
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
                      text: 'Já possui uma conta?',
                      style: Theme.of(context).textTheme.displayMedium,
                    ),
                  ),
                  SizedBox(width: 5),
                  Semantics(
                    label: 'Entre',
                    button: true,
                    child: GestureDetector(
                      onTap: () {},
                      child: RichText(
                        text: TextSpan(
                          text: 'Entre',
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
