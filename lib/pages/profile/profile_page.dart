import 'package:fishspot_app/components/custom_button.dart';
import 'package:fishspot_app/components/custom_circle_avatar.dart';
import 'package:fishspot_app/constants/colors_constants.dart';
import 'package:fishspot_app/constants/route_constants.dart';
import 'package:fishspot_app/constants/shared_preferences_constants.dart';
import 'package:fishspot_app/models/http_response.dart';
import 'package:fishspot_app/pages/loading_page.dart';
import 'package:fishspot_app/repositories/settings_repository.dart';
import 'package:fishspot_app/services/api_service.dart';
import 'package:fishspot_app/services/auth_service.dart';
import 'package:fishspot_app/services/navigation_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg_provider/flutter_svg_provider.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final ApiService _apiService = ApiService();
  final Map<String, dynamic> _userProfileData = {};
  final List<dynamic> _userLocationsData = [];

  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  _loadUserData() async {
    setState(() {
      _loading = true;
    });

    var settings = Provider.of<SettingRepository>(context, listen: false);
    var token = settings.getString(SharedPreferencesConstants.jwtToken) ?? '';

    try {
      AuthService.refreshUserCredentials(context);
      HttpResponse userResponse = await _apiService.getUser(token);

      _userProfileData.addAll({
        'name': userResponse.response['name'],
        'description': userResponse.response['description'],
        'image_id': userResponse.response['image'],
        'registries': userResponse.response['spotDetails']['registries'],
        'fishes': userResponse.response['spotDetails']['fishes'],
        'lures': userResponse.response['spotDetails']['lures']
      });
    } catch (e) {
      if (mounted) {
        AuthService.clearUserCredentials(context);
        AuthService.showInternalErrorDialog(context);
      }
    }

    try {
      HttpResponse locationsResponse = await _apiService.getUserLocations({
        'PageSize': '12',
        'PageNumber': '1',
      }, token);

      _userLocationsData.addAll(locationsResponse.response);
    } catch (e) {
      if (mounted) {
        AuthService.clearUserCredentials(context);
        AuthService.showInternalErrorDialog(context);
      }
    }

    setState(() {
      _loading = false;
    });
  }

  _getUserImagePath() {
    var settings = Provider.of<SettingRepository>(context, listen: false);
    var token = settings.getString(SharedPreferencesConstants.jwtToken) ?? '';

    if (_userProfileData['image_id'] != null &&
        _userProfileData['image_id'] != '') {
      return _apiService.getResource(_userProfileData['image_id'], token);
    }

    return '';
  }

  @override
  Widget build(BuildContext context) {
    final divider =
        Divider(color: Theme.of(context).iconTheme.color, thickness: 0.3);
    final spotRegistered = _userLocationsData.isEmpty
        ? _renderEmptySpotRegistered()
        : _renderSpotRegistered(context);

    if (_loading) {
      return LoadingPage();
    }

    return Scaffold(
      appBar: _renderAppBar(context),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _renderUserDescription(context),
              divider,
              spotRegistered,
            ],
          ),
        ),
      ),
    );
  }

  _renderUserDescription(dynamic context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(20, 20, 20, 30),
          child: Row(
            children: [
              SizedBox(
                height: 100,
                width: 100,
                child: CustomCircleAvatar(
                  imageUrl: _getUserImagePath(),
                ),
              ),
              SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _userProfileData['name'],
                      softWrap: true,
                      style: TextStyle(
                        color: Theme.of(context).textTheme.headlineLarge?.color,
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      _userProfileData['description'],
                      textAlign: TextAlign.start,
                      softWrap: true,
                      style: TextStyle(
                        color: Theme.of(context).textTheme.headlineLarge?.color,
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Row(
          children: [
            Expanded(
              child: Column(
                children: [
                  Text(_userProfileData['registries'].toString()),
                  Text('Registros'),
                ],
              ),
            ),
            Expanded(
              child: Column(
                children: [
                  Text(_userProfileData['fishes'].toString()),
                  Text('Peixes'),
                ],
              ),
            ),
            Expanded(
              child: Column(
                children: [
                  Text(_userProfileData['lures'].toString()),
                  Text('Iscas'),
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: 20),
        Padding(
          padding: EdgeInsets.fromLTRB(22, 0, 22, 0),
          child: CustomButton(
            label: 'Editar Perfil',
            onPressed: () {
              NavigationService.push(context, RouteConstants.editUser);
            },
            fixedSize: Size(double.maxFinite, 38),
          ),
        ),
        SizedBox(height: 5),
      ],
    );
  }

  _renderSpotRegistered(dynamic context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(20, 10, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Pescas Registradas',
            style: TextStyle(
              color: Theme.of(context).textTheme.headlineLarge?.color,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 15),
          GridView.count(
            primary: true,
            shrinkWrap: true,
            crossAxisCount: 3,
            crossAxisSpacing: 2,
            mainAxisSpacing: 2,
            children: _renderSpotRegistteredItems(),
            physics: NeverScrollableScrollPhysics(),
          ),
        ],
      ),
    );
  }

  _renderSpotRegistteredItems() {
    return _userLocationsData.map((entry) {
      final isImageProvided = entry['image'] != null && entry['image'] != '';
      final icon = DecorationImage(
        image: Svg('assets/images/no-photography.svg'),
        fit: BoxFit.none,
      );

      final image = DecorationImage(
        image: NetworkImage(entry['image']),
        fit: BoxFit.fill,
      );

      return Container(
        color: ColorsConstants.gray100,
        child: Container(
          decoration: BoxDecoration(
            image: isImageProvided ? image : icon,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: Container(
                  padding: EdgeInsets.fromLTRB(3, 0, 3, 0),
                  height: 32,
                  color: Color.fromRGBO(0, 0, 0, 0.35),
                  child: Center(
                    child: Text(
                      entry['title'],
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: ColorsConstants.gray50,
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }).toList();
  }

  _renderEmptySpotRegistered() {
    return Padding(
      padding: EdgeInsets.fromLTRB(20, 10, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Pescas Registradas',
            style: TextStyle(
              color: Theme.of(context).textTheme.headlineLarge?.color,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 90),
          Center(
            child: Column(
              children: [
                Icon(
                  Icons.no_photography,
                  color: Theme.of(context).iconTheme.color,
                  size: 112,
                ),
                Text(
                  'Nenhuma pesca \n registrada',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Theme.of(context).iconTheme.color,
                    fontSize: 28,
                    fontWeight: FontWeight.w400,
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  _renderAppBar(dynamic context) {
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: Theme.of(context).colorScheme.surface,
      foregroundColor: Theme.of(context).colorScheme.surface,
      surfaceTintColor: Theme.of(context).colorScheme.surface,
      shadowColor: ColorsConstants.gray350,
      title: Row(
        children: [
          //SizedBox(width: 5),
          Text(
            'FishSpot',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: Theme.of(context).textTheme.headlineLarge?.color,
              fontSize: 22,
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          onPressed: () {
            NavigationService.push(context, RouteConstants.configuration);
          },
          icon: Icon(Icons.menu),
          color: Theme.of(context).textTheme.headlineLarge?.color,
          iconSize: 32,
        ),
        SizedBox(width: 10)
      ],
    );
  }
}
