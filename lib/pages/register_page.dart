import 'package:fishspot_app/components/custom_button.dart';
import 'package:fishspot_app/components/custom_input_form_text.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  final formGlobalKey = GlobalKey<FormState>();

  bool passwordObscureText = true;
  bool confirmPasswordObscureText = true;

  void handlePressedPasswordObscureText() {
    setState(() {
      passwordObscureText = !passwordObscureText;
    });
  }

  void handlePressedConfirmPasswordObscureText() {
    setState(() {
      confirmPasswordObscureText = !confirmPasswordObscureText;
    });
  }

  void handleRegisterButton() {
    if (!formGlobalKey.currentState!.validate()) {
      return;
    }
  }

  String? handleNameValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'O campo nome é obrigatório';
    }
    return null;
  }

  String? handleMailValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'O campo e-mail é obrigatório';
    }
    return null;
  }

  String? handlePasswordValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'O campo senha é obrigatório';
    }
    return null;
  }

  String? handleConfirmPasswordValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'O campo senha é obrigatório';
    }
    if (passwordController.text != confirmPasswordController.text) {
      return 'As senhas não se coincidem';
    }
    return null;
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
                'Registre-se',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              SizedBox(height: 35),
              Form(
                key: formGlobalKey,
                child: Column(
                  children: [
                    Column(
                      children: [
                        CustomInputFormText(
                          controller: usernameController,
                          hintText: 'Name',
                          validator: handleNameValidator,
                          icon: Icon(
                            Icons.person,
                            color: Theme.of(context).iconTheme.color,
                          ),
                        ),
                        SizedBox(height: 25),
                        CustomInputFormText(
                          controller: emailController,
                          hintText: 'E-mail',
                          validator: handleMailValidator,
                          textInputType: TextInputType.emailAddress,
                          icon: Icon(
                            Icons.email,
                            color: Theme.of(context).iconTheme.color,
                          ),
                        ),
                        SizedBox(height: 25),
                        CustomInputFormText(
                          controller: passwordController,
                          hintText: 'Senha',
                          validator: handlePasswordValidator,
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
                        CustomInputFormText(
                          controller: confirmPasswordController,
                          hintText: 'Confirmar Senha',
                          validator: handleConfirmPasswordValidator,
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
                    SizedBox(height: 35),
                    CustomButton(
                      onPressed: handleRegisterButton,
                      fixedSize: Size(286, 48),
                      label: 'Registrar',
                    ),
                  ],
                ),
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
