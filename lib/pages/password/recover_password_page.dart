import 'package:fishspot_app/components/custom_alert_dialog.dart';
import 'package:fishspot_app/components/custom_button.dart';
import 'package:fishspot_app/components/custom_text_button.dart';
import 'package:fishspot_app/components/custom_text_form_field.dart';
import 'package:fishspot_app/enums/custom_dialog_alert_type.dart';
import 'package:fishspot_app/exceptions/http_response_exception.dart';
import 'package:fishspot_app/pages/password/validate_token_page.dart';
import 'package:fishspot_app/repositories/recover_password_repository.dart';
import 'package:fishspot_app/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RecoverPasswordPage extends StatefulWidget {
  const RecoverPasswordPage({super.key});

  @override
  State<RecoverPasswordPage> createState() => _RecoverPasswordPageState();
}

class _RecoverPasswordPageState extends State<RecoverPasswordPage> {
  final _api = ApiService();
  final _mailController = TextEditingController();
  final _formGlobalKey = GlobalKey<FormState>();

  bool _loading = false;

  _handleSend() async {
    setState(() {
      _loading = true;
    });

    var repo = Provider.of<RecoverPasswordRepository>(context, listen: false);
    var route = MaterialPageRoute(builder: (context) => ValidateTokenPage());

    if (!_formGlobalKey.currentState!.validate()) {
      setState(() {
        _loading = false;
      });
      return;
    }

    try {
      repo.setEmail(_mailController.text);

      await _api.recoverPassword({'email': _mailController.text});

      if (mounted) {
        Navigator.push(context, route);
      }
    } on HttpResponseException catch (e) {
      _renderDialog(null, e.data.message);
    } catch (e) {
      _renderDialog(null, null);
    }

    setState(() {
      _loading = false;
    });
  }

  _handleCancel() {
    Provider.of<RecoverPasswordRepository>(context, listen: false).clear();
    Navigator.pop(context);
  }

  String? _mailValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email não pode ser vazio';
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
          "Um token de acesso sera enviado para o e-mail informado para validação",
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
            validator: _mailValidator,
            controller: _mailController,
            hintText: 'E-mail',
            icon: Icon(
              Icons.mail,
              color: Theme.of(context).iconTheme.color,
            ),
          ),
          SizedBox(height: 45),
          CustomButton(
            onPressed: _handleSend,
            fixedSize: Size(286, 48),
            loading: _loading,
            label: 'Enviar',
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

  _renderDialog(String? title, String? message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CustomAlertDialog(
          type: CustomDialogAlertType.error,
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
}
