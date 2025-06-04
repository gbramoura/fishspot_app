import 'package:fishspot_app/widgets/custom_alert_dialog.dart';
import 'package:fishspot_app/widgets/custom_button.dart';
import 'package:fishspot_app/widgets/custom_text_button.dart';
import 'package:fishspot_app/widgets/text_input.dart';
import 'package:fishspot_app/constants/route_constants.dart';
import 'package:fishspot_app/constants/shared_preferences_constants.dart';
import 'package:fishspot_app/enums/custom_dialog_alert_type.dart';
import 'package:fishspot_app/exceptions/http_response_exception.dart';
import 'package:fishspot_app/models/http_response.dart';
import 'package:fishspot_app/providers/settings_provider.dart';
import 'package:fishspot_app/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final apiService = ApiService();

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formGlobalKey = GlobalKey<FormState>();

  bool _loadingHttpRequest = false;

  void _handleLogin() async {
    if (!_formGlobalKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _loadingHttpRequest = true;
    });

    try {
      HttpResponse response = await apiService.login({
        'email': _emailController.text,
        'password': _passwordController.text,
      });

      if (!mounted) return;
      var settings = Provider.of<SettingProvider>(context, listen: false);

      settings.setString(
        SharedPreferencesConstants.jwtToken,
        response.response['token'],
      );
      settings.setString(
        SharedPreferencesConstants.refreshToken,
        response.response['refreshToken'],
      );

      Navigator.pushNamed(context, RouteConstants.home);
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

  void _handleForgetPassword() {
    Navigator.pushNamed(context, RouteConstants.recoverPassword);
  }

  void _handleRegister() {
    Navigator.pushNamed(context, RouteConstants.register);
  }

  void _renderDialog(int code, String? message) {
    String errorMessage =
        'Não foi possivel autenticar usuario devido a um erro desconhecido';
    String errorTitle = 'Erro ao Autenticar-se';
    String errorButtonLabel = 'Tentar Novamente';

    String warnTitle = 'Falha da Autenticação';
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

  String? _handleEmailValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'E-mail é obrigatória';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SingleChildScrollView(
        child: PopScope<Object?>(
          canPop: false,
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
                Form(
                  key: _formGlobalKey,
                  child: Column(
                    children: [
                      Column(
                        children: [
                          SizedBox(height: 10),
                          TextInput(
                            label: 'E-mail',
                            controller: _emailController,
                            validator: _handleEmailValidator,
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
                        ],
                      ),
                      SizedBox(height: 5),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Padding(
                            padding: EdgeInsets.fromLTRB(0, 15, 0, 0),
                            child: CustomTextButton(
                              label: 'Esqueceu sua senha?',
                              onTap: () => _handleForgetPassword(),
                              style: Theme.of(context).textTheme.displayMedium,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 55),
                      CustomButton(
                        loading: _loadingHttpRequest,
                        onPressed: () => _handleLogin(),
                        fixedSize: Size(286, 48),
                        label: 'Entrar',
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
                        text: 'Não possui uma conta?',
                        style: Theme.of(context).textTheme.displayMedium,
                      ),
                    ),
                    SizedBox(width: 5),
                    CustomTextButton(
                      label: 'Registre-se',
                      style: TextStyle(
                        color: Theme.of(context).textTheme.labelSmall?.color,
                        fontWeight:
                            Theme.of(context).textTheme.labelSmall?.fontWeight,
                        fontSize:
                            Theme.of(context).textTheme.labelSmall?.fontSize,
                        decoration: TextDecoration.underline,
                      ),
                      onTap: () => _handleRegister(),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
