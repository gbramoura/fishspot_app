import 'package:fishspot_app/widgets/custom_alert_dialog.dart';
import 'package:fishspot_app/widgets/button.dart';
import 'package:fishspot_app/widgets/ink_button.dart';
import 'package:fishspot_app/widgets/text_input.dart';
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
  final _apiService = ApiService();

  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _formGlobalKey = GlobalKey<FormState>();

  bool _loadingHttpRequest = false;

  void _handleRegisterButton() async {
    if (!_formGlobalKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _loadingHttpRequest = true;
    });

    try {
      await _apiService.register({
        'name': _usernameController.text,
        'email': _emailController.text,
        'password': _passwordController.text,
      });

      _renderSuccessDialog();
    } on HttpResponseException catch (e) {
      _renderDialog(e.data.code, e.data.message);
    } catch (e) {
      _renderDialog(500, null);
    } finally {
      setState(() {
        _loadingHttpRequest = false;
      });
    }
  }

  String? _handleNameValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Nome é obrigatório';
    }
    return null;
  }

  String? _handleMailValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'E-mail é obrigatório';
    }
    return null;
  }

  String? _handlePasswordValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Senha é obrigatória';
    }
    if (value.length < 8) {
      return 'A senha deve ter mais que 8 caracteres';
    }
    return null;
  }

  String? _handleConfirmPasswordValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Confirmação de senha é obrigatória';
    }
    if (value.length < 8) {
      return 'A confirmação deve ter mais que 8 caracteres';
    }
    if (_passwordController.text != _confirmPasswordController.text) {
      return 'As senhas não se coincidem';
    }
    return null;
  }

  void _renderSuccessDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CustomAlertDialog(
          type: CustomDialogAlertType.success,
          title: 'Registrado com Sucesso',
          message:
              'Seus dados foram registrados com sucesso sendo possível realizar a autenticação.',
          button: Button(
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

  void _renderDialog(int code, String? message) {
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
          button: Button(
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
                    image: AssetImage('assets/fish-spot-icon.png'),
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
                key: _formGlobalKey,
                child: Column(
                  children: [
                    Column(
                      children: [
                        TextInput(
                          label: 'Name',
                          controller: _usernameController,
                          validator: _handleNameValidator,
                          icon: Icons.person,
                        ),
                        SizedBox(height: 25),
                        TextInput(
                          label: 'E-mail',
                          controller: _emailController,
                          validator: _handleMailValidator,
                          textInputType: TextInputType.emailAddress,
                          icon: Icons.email,
                        ),
                        SizedBox(height: 25),
                        TextInput(
                          label: 'Senha',
                          controller: _passwordController,
                          validator: _handlePasswordValidator,
                          icon: Icons.lock,
                          obscureText: true,
                          obscureTextAction: true,
                        ),
                        SizedBox(height: 25),
                        TextInput(
                          label: 'Confirmar Senha',
                          controller: _confirmPasswordController,
                          validator: _handleConfirmPasswordValidator,
                          icon: Icons.lock,
                          obscureText: true,
                          obscureTextAction: true,
                        ),
                      ],
                    ),
                    SizedBox(height: 35),
                    Button(
                      onPressed: _handleRegisterButton,
                      fixedSize: Size(286, 48),
                      label: 'Registrar',
                      loading: _loadingHttpRequest,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
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
                  InkButton(
                    label: 'Entre',
                    style: TextStyle(
                      color: Theme.of(context).textTheme.labelSmall?.color,
                      fontWeight:
                          Theme.of(context).textTheme.labelSmall?.fontWeight,
                      fontSize:
                          Theme.of(context).textTheme.labelSmall?.fontSize,
                      decoration: TextDecoration.underline,
                    ),
                    onTap: () {
                      Navigator.pop(context);
                    },
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
