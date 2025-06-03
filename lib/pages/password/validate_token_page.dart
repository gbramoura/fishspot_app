import 'package:fishspot_app/components/custom_alert_dialog.dart';
import 'package:fishspot_app/components/custom_button.dart';
import 'package:fishspot_app/components/custom_text_button.dart';
import 'package:fishspot_app/components/custom_text_form_field.dart';
import 'package:fishspot_app/constants/route_constants.dart';
import 'package:fishspot_app/enums/custom_dialog_alert_type.dart';
import 'package:fishspot_app/exceptions/http_response_exception.dart';
import 'package:fishspot_app/models/http_response.dart';
import 'package:fishspot_app/models/validate_token.dart';
import 'package:fishspot_app/pages/password/change_password_page.dart';
import 'package:fishspot_app/providers/recover_password_provider.dart';
import 'package:fishspot_app/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ValidateTokenPage extends StatefulWidget {
  const ValidateTokenPage({super.key});

  @override
  State<ValidateTokenPage> createState() => _ValidateTokenPageState();
}

class _ValidateTokenPageState extends State<ValidateTokenPage> {
  final _api = ApiService();
  final _tokenController = TextEditingController();
  final _formGlobalKey = GlobalKey<FormState>();

  bool _loading = false;

  _handleSend() async {
    setState(() {
      _loading = true;
    });

    var provider = Provider.of<RecoverPasswordProvider>(context, listen: false);
    var route = MaterialPageRoute(builder: (context) => ChangePasswordPage());

    if (!_formGlobalKey.currentState!.validate()) {
      setState(() {
        _loading = false;
      });
      return;
    }

    try {
      provider.setToken(_tokenController.text);

      HttpResponse response = await _api.validateRecoverToken({
        'email': provider.getEmail(),
        'token': provider.getToken(),
      });

      ValidateToken parsedResponse = ValidateToken.fromJson(response.response);

      if (!mounted) return;

      if (!parsedResponse.isValid) {
        _renderDialog(
          title: "Token Invalido",
          message: "O token informado se encontra invalido",
          type: CustomDialogAlertType.warn,
        );
        return;
      }

      Navigator.push(context, route);
    } on HttpResponseException catch (e) {
      _renderDialog(message: e.data.message);
    } catch (e) {
      _renderDialog();
    }

    setState(() {
      _loading = true;
    });
  }

  _handleCancel() {
    Provider.of<RecoverPasswordProvider>(context, listen: false).clear();
    Navigator.of(context).popUntil((route) {
      return route.settings.name == RouteConstants.login;
    });
  }

  String? _tokenValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Token não pode ser vazio';
    }
    return null;
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
        'Recuperar Senha',
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.headlineLarge,
      ),
      Padding(
        padding: EdgeInsets.fromLTRB(15, 10, 15, 45),
        child: Text(
          "Um token de acesso foi enviado para o e-mail informado",
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
            maxLength: 5,
            validator: _tokenValidator,
            controller: _tokenController,
            textInputType: TextInputType.number,
            hintText: 'Token',
            icon: Icon(
              Icons.numbers,
              color: Theme.of(context).iconTheme.color,
            ),
          ),
          SizedBox(height: 45),
          CustomButton(
            onPressed: _handleSend,
            fixedSize: Size(286, 48),
            label: 'Confirmar Token',
            loading: _loading,
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
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        );
      },
    );
  }
}
