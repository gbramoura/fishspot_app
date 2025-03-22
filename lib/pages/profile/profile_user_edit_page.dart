import 'dart:io';

import 'package:fishspot_app/components/custom_alert_dialog.dart';
import 'package:fishspot_app/components/custom_button.dart';
import 'package:fishspot_app/components/custom_circle_avatar.dart';
import 'package:fishspot_app/components/custom_text_form_field.dart';
import 'package:fishspot_app/constants/colors_constants.dart';
import 'package:fishspot_app/constants/shared_preferences_constants.dart';
import 'package:fishspot_app/enums/custom_dialog_alert_type.dart';
import 'package:fishspot_app/models/http_response.dart';
import 'package:fishspot_app/pages/loading_page.dart';
import 'package:fishspot_app/repositories/settings_repository.dart';
import 'package:fishspot_app/services/api_service.dart';
import 'package:fishspot_app/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class ProfileUserEditPage extends StatefulWidget {
  const ProfileUserEditPage({super.key});

  @override
  State<ProfileUserEditPage> createState() => _ProfileUserEditPagePageState();
}

class _ProfileUserEditPagePageState extends State<ProfileUserEditPage> {
  final ApiService _apiService = ApiService();
  final _formGlobalKey = GlobalKey<FormState>();

  String _image_id = '';
  File? _image;

  final _nameController = TextEditingController();
  final _usernameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _streetController = TextEditingController();
  final _numberController = TextEditingController();
  final _neighborhoodController = TextEditingController();
  final _zipCodeController = TextEditingController();

  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _loadAppData();
  }

  _loadAppData() async {
    setState(() {
      _loading = true;
    });

    var settings = Provider.of<SettingRepository>(context, listen: false);
    var token = settings.getString(SharedPreferencesConstants.jwtToken) ?? '';

    try {
      AuthService.refreshCredentials(context);
      HttpResponse resp = await _apiService.getUser(token);

      _image_id = resp.response['image'] ?? '';
      _nameController.text = resp.response['name'] ?? '';
      _usernameController.text = resp.response['username'] ?? '';
      _descriptionController.text = resp.response['description'] ?? '';
      _streetController.text = resp.response['address']['street'] ?? '';
      _neighborhoodController.text =
          resp.response['address']['neighborhood'] ?? '';
      _zipCodeController.text = resp.response['address']['zipCode'] ?? '';

      if (resp.response['address']['number'] != null &&
          resp.response['address']['number'] > 0) {
        _numberController.text = resp.response['address']['number'].toString();
      }
    } catch (e) {
      if (mounted) {
        AuthService.clearCredentials(context);
        AuthService.showInternalErrorDialog(context);
      }
    }

    setState(() {
      _loading = false;
    });
  }

  _handleChangeImage(dynamic context) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile == null) {
      return;
    }

    var settings = Provider.of<SettingRepository>(context, listen: false);
    var token = settings.getString(SharedPreferencesConstants.jwtToken) ?? '';

    try {
      HttpResponse response = await _apiService.attachUserImage(
        {'file': File(pickedFile.path)},
        token,
      );

      setState(() {
        _image_id = response.response.toString();
      });
    } catch (e) {
      _renderProfileImageError(context);
    }
  }

  _getUserImagePath() {
    var settings = Provider.of<SettingRepository>(context, listen: false);
    var token = settings.getString(SharedPreferencesConstants.jwtToken) ?? '';

    if (_image_id.isEmpty) {
      return '';
    }
    return _apiService.getResource(_image_id, token);
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return LoadingPage();
    }

    return Scaffold(
      appBar: _renderAppBar(context),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _renderEditProfileImage(context),
            _renderProfileForm(),
          ],
        ),
      ),
    );
  }

  _renderEditProfileImage(context) {
    return Column(
      children: [
        SizedBox(height: 30),
        SizedBox(
          height: 100,
          width: 100,
          child: CustomCircleAvatar(
            imageUrl: _getUserImagePath(),
          ),
        ),
        SizedBox(height: 10),
        Semantics(
          label: 'Editar Foto',
          button: true,
          child: GestureDetector(
            onTap: () => _handleChangeImage(context),
            child: RichText(
              text: TextSpan(
                text: 'Editar Foto',
                style: TextStyle(
                  color: ColorsConstants.blue150,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  _renderProfileForm() {
    return Padding(
      padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
      child: Form(
        key: _formGlobalKey,
        child: Column(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 35),
                CustomTextFormField(
                  controller: _nameController,
                  hintText: 'Name',
                  icon: Icon(
                    Icons.person,
                    color: Theme.of(context).iconTheme.color,
                  ),
                ),
                SizedBox(height: 20),
                CustomTextFormField(
                  controller: _usernameController,
                  hintText: 'Nome de usuário',
                  icon: Icon(
                    Icons.alternate_email,
                    color: Theme.of(context).iconTheme.color,
                  ),
                ),
                SizedBox(height: 20),
                CustomTextFormField(
                  controller: _descriptionController,
                  hintText: 'Descrição',
                ),
                SizedBox(height: 45),
                Text(
                  'Endereço',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).textTheme.headlineLarge?.color,
                  ),
                ),
                Text(
                  'Informar o endereço não é obrigatorio',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Theme.of(context).textTheme.headlineLarge?.color,
                  ),
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    Flexible(
                      flex: 3,
                      child: CustomTextFormField(
                        controller: _streetController,
                        hintText: 'Rua',
                        icon: Icon(
                          Icons.home,
                          color: Theme.of(context).iconTheme.color,
                        ),
                      ),
                    ),
                    SizedBox(width: 15),
                    Flexible(
                      flex: 1,
                      child: CustomTextFormField(
                        controller: _numberController,
                        hintText: 'N°',
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Row(
                  children: [
                    Flexible(
                      flex: 3,
                      child: CustomTextFormField(
                        controller: _neighborhoodController,
                        hintText: 'Bairro',
                        icon: Icon(
                          Icons.fence,
                          color: Theme.of(context).iconTheme.color,
                        ),
                      ),
                    ),
                    SizedBox(width: 15),
                    Flexible(
                      flex: 2,
                      child: CustomTextFormField(
                        controller: _zipCodeController,
                        hintText: 'CEP',
                        icon: Icon(
                          Icons.location_on,
                          color: Theme.of(context).iconTheme.color,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 45),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    CustomButton(
                      label: 'Confirmar',
                      fixedSize: Size(182, 48),
                      onPressed: () {},
                    ),
                  ],
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  _renderAppBar(dynamic context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      title: Row(
        children: [
          Text(
            'Editar Perfil',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: Theme.of(context).textTheme.headlineLarge?.color,
              fontSize: 18,
            ),
          ),
        ],
      ),
    );
  }

  _renderProfileImageError(dynamic context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CustomAlertDialog(
          type: CustomDialogAlertType.error,
          title: 'Error ao Alterar Foto de Perfil',
          message:
              'Devido a algum erro inesperado a foto de perfil não foi alterada',
          button: CustomButton(
            label: 'Ok',
            fixedSize: Size(double.infinity, 48),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        );
      },
    );
  }
}
