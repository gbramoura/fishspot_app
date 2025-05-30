import 'package:fishspot_app/components/custom_alert_dialog.dart';
import 'package:fishspot_app/components/custom_button.dart';
import 'package:fishspot_app/components/custom_text_button.dart';
import 'package:fishspot_app/components/custom_text_form_field.dart';
import 'package:fishspot_app/constants/route_constants.dart';
import 'package:fishspot_app/enums/custom_dialog_alert_type.dart';
import 'package:fishspot_app/exceptions/http_response_exception.dart';
import 'package:fishspot_app/repositories/recover_password_repository.dart';
import 'package:fishspot_app/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final _api = ApiService();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _formGlobalKey = GlobalKey<FormState>();

  bool _passwordObscureText = true;
  bool _confirmPasswordObscureText = true;
  bool _loading = false;

  _handleSend() async {
    setState(() {
      _loading = true;
    });

    var repo = Provider.of<RecoverPasswordRepository>(context, listen: false);

    if (!_formGlobalKey.currentState!.validate()) {
      setState(() {
        _loading = false;
      });
      return;
    }

    try {
      await _api.changePassword({
        'email': repo.getEmail(),
        'token': repo.getToken(),
        'newPassword': _passwordController.text,
      });

      _renderDialog(
        title: "Senha Alterada",
        message: "A senha foi alterada com sucesso",
        type: CustomDialogAlertType.success,
      );
    } on HttpResponseException catch (e) {
      _renderDialog(message: e.data.message);
    } catch (e) {
      _renderDialog();
    }

    setState(() {
      _loading = false;
    });
  }

  _handleCancel() {
    Provider.of<RecoverPasswordRepository>(context, listen: false).clear();
    Navigator.of(context).popUntil((route) {
      return route.settings.name == RouteConstants.login;
    });
  }

  String? _passwordValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Senha é obrigatória';
    }
    if (value.length < 8) {
      return 'A senha deve ter mais que 8 caracteres';
    }
    return null;
  }

  String? _confirmPasswordValidator(String? value) {
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

  _handlePressedPasswordObscureText() {
    setState(() {
      _passwordObscureText = !_passwordObscureText;
    });
  }

  _handlePressedConfirmPasswordObscureText() {
    setState(() {
      _confirmPasswordObscureText = !_confirmPasswordObscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    var header = _renderHeader(context);
    var form = _renderForm(context);

    return Scaffold(
      extendBody: true,
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(32),
          child: Column(
            children: [
              ...header,
              form,
            ],
          ),
        ),
      ),
    );
  }

  _renderHeader(BuildContext context) {
    return [
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
    ];
  }

  _renderForm(BuildContext context) {
    return Form(
      key: _formGlobalKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomTextFormField(
            validator: _passwordValidator,
            controller: _passwordController,
            hintText: 'Senha',
            obscureText: _passwordObscureText,
            icon: Icon(
              Icons.lock,
              color: Theme.of(context).iconTheme.color,
            ),
            actionIcon: IconButton(
              onPressed: _handlePressedPasswordObscureText,
              icon: _renderVisibleIcon(_passwordObscureText),
            ),
          ),
          SizedBox(height: 15),
          CustomTextFormField(
            validator: _confirmPasswordValidator,
            controller: _confirmPasswordController,
            hintText: 'Confirmar senha',
            obscureText: _confirmPasswordObscureText,
            icon: Icon(
              Icons.lock,
              color: Theme.of(context).iconTheme.color,
            ),
            actionIcon: IconButton(
              onPressed: _handlePressedConfirmPasswordObscureText,
              icon: _renderVisibleIcon(_confirmPasswordObscureText),
            ),
          ),
          SizedBox(height: 45),
          CustomButton(
            onPressed: _handleSend,
            fixedSize: Size(286, 48),
            loading: _loading,
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
              CustomTextButton(
                label: 'Cancelar',
                onTap: _handleCancel,
                style: TextStyle(
                  color: Theme.of(context).textTheme.labelSmall?.color,
                  fontWeight:
                      Theme.of(context).textTheme.labelSmall?.fontWeight,
                  fontSize: Theme.of(context).textTheme.labelSmall?.fontSize,
                  decoration: TextDecoration.underline,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  _renderDialog({String? title, String? message, CustomDialogAlertType? type}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CustomAlertDialog(
          type: type ?? CustomDialogAlertType.error,
          title: title ?? "Erro ao tentar alterar senha",
          message: message ??
              "Não foi possivel alterar sua senha devido a um erro não indetificado",
          button: CustomButton(
            label: "Ok",
            fixedSize: Size(double.infinity, 48),
            onPressed: _handleCancel,
          ),
        );
      },
    );
  }

  _renderVisibleIcon(bool isVisible) {
    return Icon(
      isVisible ? Icons.visibility : Icons.visibility_off,
      color: Theme.of(context).iconTheme.color,
    );
  }
}
