import 'dart:io';

import 'package:fishspot_app/widgets/alert_modal.dart';
import 'package:fishspot_app/widgets/button.dart';
import 'package:fishspot_app/widgets/profile_circle_avatar.dart';
import 'package:fishspot_app/widgets/text_input.dart';
import 'package:fishspot_app/constants/colors_constants.dart';
import 'package:fishspot_app/constants/shared_preferences_constants.dart';
import 'package:fishspot_app/enums/custom_dialog_alert_type.dart';
import 'package:fishspot_app/exceptions/http_response_exception.dart';
import 'package:fishspot_app/models/http_multipart_file.dart';
import 'package:fishspot_app/models/http_response.dart';
import 'package:fishspot_app/models/user_profile.dart';
import 'package:fishspot_app/pages/commons/loading_page.dart';
import 'package:fishspot_app/providers/settings_provider.dart';
import 'package:fishspot_app/services/api_service.dart';
import 'package:fishspot_app/services/auth_service.dart';
import 'package:fishspot_app/services/image_service.dart';
import 'package:fishspot_app/services/navigation_service.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class ProfileUserEditPage extends StatefulWidget {
  const ProfileUserEditPage({super.key});

  @override
  State<ProfileUserEditPage> createState() => _ProfileUserEditPageState();
}

class _ProfileUserEditPageState extends State<ProfileUserEditPage> {
  final ApiService _apiService = ApiService();
  final ImageService _imageService = ImageService();
  final NavigationService _navigationService = NavigationService();
  final AuthService _authService = AuthService();

  final _formGlobalKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _usernameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _streetController = TextEditingController();
  final _numberController = TextEditingController();
  final _neighborhoodController = TextEditingController();
  final _zipCodeController = TextEditingController();

  String _imageId = '';
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

    try {
      var settings = Provider.of<SettingProvider>(context, listen: false);
      var token = settings.getString(SharedPreferencesConstants.jwtToken) ?? '';

      await _authService.refreshCredentials(context);
      HttpResponse resp = await _apiService.getUser(token);
      UserProfile user = UserProfile.fromJson(resp.response);

      _imageId = user.image ?? '';
      _nameController.text = user.name;
      _usernameController.text = user.username;
      _descriptionController.text = user.description ?? '';
      _streetController.text = user.address?.street ?? '';
      _neighborhoodController.text = user.address?.neighborhood ?? '';
      _zipCodeController.text = user.address?.zipCode ?? '';

      if (user.address?.number != null && user.address!.number > 0) {
        _numberController.text = user.address!.number.toString();
      }
    } catch (e) {
      if (mounted) {
        _authService.clearCredentials(context);
        _authService.showInternalErrorDialog(context);
      }
    }

    setState(() {
      _loading = false;
    });
  }

  _handleChangeImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile == null) {
      return;
    }

    try {
      if (!mounted) return;
      var settings = Provider.of<SettingProvider>(context, listen: false);
      var token = settings.getString(SharedPreferencesConstants.jwtToken) ?? '';
      var payload = [
        HttpMultipartFile(path: 'file', file: File(pickedFile.path))
      ];

      HttpResponse response = await _apiService.attachUserImage(payload, token);

      setState(() {
        _imageId = response.response.toString();
      });
    } catch (e) {
      if (!mounted) return;
      _renderProfileImageError(context);
    }
  }

  _handleUpdate() async {
    if (!_formGlobalKey.currentState!.validate()) {
      return;
    }

    try {
      var settings = Provider.of<SettingProvider>(context, listen: false);
      var token = settings.getString(SharedPreferencesConstants.jwtToken) ?? '';

      var strNumber = _numberController.text;
      var payload = {
        'name': _nameController.text,
        'username': _usernameController.text,
        'description': _descriptionController.text,
        'address': {
          'street': _streetController.text,
          'number': int.parse(strNumber.isEmpty ? '0' : strNumber),
          'neighborhood': _neighborhoodController.text,
          'zipCode': _zipCodeController.text,
        }
      };

      await _apiService.updateUser(payload, token);

      if (!mounted) return;

      _navigationService.pop<bool>(context, result: true);
    } on HttpResponseException catch (e) {
      _renderDialog(e.data.code, e.data.message);
    } catch (e) {
      _renderDialog(500, null);
    }
  }

  String? _nameValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Nome não pode ser vazio';
    }
    if (value.length > 245) {
      return 'Numero maximo de 245 caracters atingida';
    }
    return null;
  }

  String? _usernameValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Nome de usuário não pode ser vazio';
    }
    if (value.length > 20) {
      return 'Numero maximo de 20 caracters atingida';
    }
    return null;
  }

  String? _descriptionValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Descrição não pode ser vazio';
    }
    if (value.length > 245) {
      return 'Numero maximo de 245 caracters atingida';
    }
    return null;
  }

  String? _streetValidator(String? value) {
    if (value != null && value.length > 245) {
      return 'Numero maximo de 245 caracters atingida';
    }
    return null;
  }

  String? _numberValidator(String? value) {
    if (value != null && value.length > 8) {
      return 'Numero maximo de caracters atingida';
    }
    return null;
  }

  String? _neighborhoodValidator(String? value) {
    if (value != null && value.length > 245) {
      return 'Numero maximo de 245 caracters atingida';
    }
    return null;
  }

  String? _zipCodeValidator(String? value) {
    if (value != null && value.length > 8) {
      return 'Numero maximo de 8 caracters atingida';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return LoadingPage();
    }

    return Scaffold(
      appBar: _renderAppBar(context),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _renderEditProfileImage(context),
              _renderProfileForm(),
            ],
          ),
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
          child: ProfileCircleAvatar(
            imageUrl: _imageService.getImagePath(context, _imageId),
          ),
        ),
        SizedBox(height: 10),
        Semantics(
          label: 'Editar Foto',
          button: true,
          child: GestureDetector(
            onTap: () => _handleChangeImage(),
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
                TextInput(
                  label: 'Name',
                  validator: _nameValidator,
                  controller: _nameController,
                  icon: Icons.person,
                ),
                SizedBox(height: 20),
                TextInput(
                  label: 'Nome de usuário',
                  validator: _usernameValidator,
                  controller: _usernameController,
                  icon: Icons.alternate_email,
                ),
                SizedBox(height: 20),
                SizedBox(
                  height: 120,
                  width: double.infinity,
                  child: TextInput(
                    label: 'Descrição',
                    validator: _descriptionValidator,
                    controller: _descriptionController,
                    textInputType: TextInputType.multiline,
                    expands: true,
                    maxLines: null,
                  ),
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Flexible(
                      flex: 3,
                      child: TextInput(
                        label: 'Rua',
                        validator: _streetValidator,
                        controller: _streetController,
                        icon: Icons.home,
                      ),
                    ),
                    SizedBox(width: 15),
                    Flexible(
                      flex: 1,
                      child: TextInput(
                        label: 'N°',
                        validator: _numberValidator,
                        controller: _numberController,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Flexible(
                      flex: 3,
                      child: TextInput(
                        label: 'Bairro',
                        validator: _neighborhoodValidator,
                        controller: _neighborhoodController,
                        icon: Icons.fence,
                      ),
                    ),
                    SizedBox(width: 15),
                    Flexible(
                      flex: 2,
                      child: TextInput(
                        label: 'CEP',
                        validator: _zipCodeValidator,
                        controller: _zipCodeController,
                        icon: Icons.location_on,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 45),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Button(
                      label: 'Confirmar',
                      fixedSize: Size(182, 48),
                      onPressed: () => _handleUpdate(),
                    ),
                  ],
                ),
                SizedBox(height: 40),
              ],
            )
          ],
        ),
      ),
    );
  }

  _renderAppBar(dynamic context) {
    return AppBar(
      titleSpacing: 0,
      backgroundColor: Theme.of(context).colorScheme.surface,
      surfaceTintColor: Theme.of(context).colorScheme.surface,
      shadowColor: ColorsConstants.gray350,
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
        return AlertModal(
          type: CustomDialogAlertType.error,
          title: 'Error ao Alterar Foto de Perfil',
          message: '',
          button: Button(
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

  void _renderDialog(int code, String? message) {
    String errorTitle = 'Error ao Alterar Foto de Perfil';
    String errorMessage =
        'Devido a algum erro inesperado a foto de perfil não foi alterada';
    String errorButtonLabel = 'Tentar Novamente';

    String warnTitle = 'Alteração não Realizado';
    String warnMessage = message ?? '';

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertModal(
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
}
