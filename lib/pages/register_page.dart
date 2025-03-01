import 'package:fishspot_app/components/custom_alert_dialog.dart';
import 'package:fishspot_app/components/custom_button.dart';
import 'package:fishspot_app/components/custom_text_form_field.dart';
import 'package:fishspot_app/constants/route_constants.dart';
import 'package:fishspot_app/enums/custom_dialog_alert_type.dart';
import 'package:fishspot_app/exceptions/http_response_exception.dart';
import 'package:fishspot_app/services/api_service.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final apiService = ApiService();

  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final formGlobalKey = GlobalKey<FormState>();

  bool passwordObscureText = true;
  bool confirmPasswordObscureText = true;
  bool loadingHttpRequest = false;

  void handleRegisterButton() async {
    if (!formGlobalKey.currentState!.validate()) {
      return;
    }

    setState(() {
      loadingHttpRequest = true;
    });

    try {
      await apiService.register({
        'name': usernameController.text,
        'email': emailController.text,
        'password': passwordController.text,
      });

      renderSuccessDialog();
    } on HttpResponseException catch (e) {
      renderDialog(e.data.code, e.data.message);
    } catch (e) {
      renderDialog(500, null);
    } finally {
      setState(() {
        loadingHttpRequest = false;
      });
    }
  }

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

  String? handleNameValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Nome é obrigatório';
    }
    return null;
  }

  String? handleMailValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'E-mail é obrigatório';
    }
    return null;
  }

  String? handlePasswordValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Senha é obrigatória';
    }
    if (value.length < 8) {
      return 'A senha deve ter mais que 8 caracteres';
    }
    return null;
  }

  String? handleConfirmPasswordValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Confirmação de senha é obrigatória';
    }
    if (value.length < 8) {
      return 'A confirmação deve ter mais que 8 caracteres';
    }
    if (passwordController.text != confirmPasswordController.text) {
      return 'As senhas não se coincidem';
    }
    return null;
  }

  void renderSuccessDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CustomAlertDialog(
          type: CustomDialogAlertType.success,
          title: 'Registrado com Sucesso',
          message:
              'Seus dados foram registrados com sucesso sendo possível realizar a autenticação.',
          button: CustomButton(
            label: 'Ok',
            fixedSize: Size(double.infinity, 48),
            onPressed: () {
              Navigator.pushNamed(context, RouteConstants.login);
            },
          ),
        );
      },
    );
  }

  void renderDialog(int code, String? message) {
    String errorMessage =
        'Não foi possivel registrar o usuário devido a um erro desconhecido';
    String errorTitle = 'Erro ao Realizar Registro';
    String errorButtonLabel = 'Tentar Novamente';

    String warnTitle = 'Registro não Realizado';
    String warnMessage = message ?? '';

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CustomAlertDialog(
          type: code == 400
              ? CustomDialogAlertType.warn
              : CustomDialogAlertType.error,
          title: code == 400 ? warnTitle : errorTitle,
          message: code == 400 ? warnMessage : errorMessage,
          button: CustomButton(
            label: code == 400 ? 'Ok' : errorButtonLabel,
            fixedSize: Size(double.infinity, 48),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        );
      },
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
                        CustomTextFormField(
                          controller: usernameController,
                          hintText: 'Name',
                          validator: handleNameValidator,
                          icon: Icon(
                            Icons.person,
                            color: Theme.of(context).iconTheme.color,
                          ),
                        ),
                        SizedBox(height: 25),
                        CustomTextFormField(
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
                        CustomTextFormField(
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
                        CustomTextFormField(
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
                      loading: loadingHttpRequest,
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
                      onTap: () {
                        Navigator.pop(context);
                      },
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

  Widget renderVisibleIcon(bool isVisible) {
    return Icon(
      isVisible ? Icons.visibility : Icons.visibility_off,
      color: Theme.of(context).iconTheme.color,
    );
  }
}
