import 'package:fishspot_app/components/custom_button.dart';
import 'package:fishspot_app/constants/route_constants.dart';
import 'package:fishspot_app/constants/shared_preferences_constants.dart';
import 'package:fishspot_app/models/http_response.dart';
import 'package:fishspot_app/pages/loading_page.dart';
import 'package:fishspot_app/repositories/settings_repository.dart';
import 'package:fishspot_app/services/api_service.dart';
import 'package:fishspot_app/services/auth_service.dart';
import 'package:fishspot_app/utils/hex_color_utils.dart';
import 'package:flutter/material.dart';
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

    if (_userProfileData['image_id'] != null) {
      try {
        HttpResponse imgResponse = await _apiService.getImage(
          _userProfileData['image_id'],
          token,
        );

        _userProfileData.addAll({'image': imgResponse.response});
      } catch (e) {
        _userProfileData.addAll({'image': null});
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
      body: Center(
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
    );
  }

  _renderUserDescription(dynamic context) {
    final userImage = _userProfileData['image'] != null
        ? Image(fit: BoxFit.fill, image: AssetImage(_userProfileData['image']))
        : Icon(Icons.person, size: 80);

    return Column(
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(20, 20, 20, 30),
          child: Row(
            children: [
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: HexColor('#D9D9D9'),
                  borderRadius: BorderRadius.circular(100),
                  border: Border.all(width: 1, color: HexColor('#D9D9D9')),
                ),
                child: userImage,
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
            onPressed: () {},
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
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
            children: _renderSpotRegistteredItems(),
          )
        ],
      ),
    );
  }

  _renderSpotRegistteredItems() {
    return _userLocationsData.map((entry) {
      var decoration = entry['image'] != null
          ? AssetImage('assets/images/fish-spot-icon.png')
          : AssetImage(entry['image']);

      return Container(
        color: HexColor('#D9D9D9'),
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: decoration,
              fit: BoxFit.fill,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                padding: EdgeInsets.fromLTRB(3, 1, 3, 1),
                color: Color.fromRGBO(0, 0, 0, 0.35),
                child: Text(
                  entry['title'],
                  style: TextStyle(
                    color: HexColor('E2E8F0'),
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
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
      backgroundColor: Colors.transparent,
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
            Navigator.pushNamed(context, RouteConstants.configuration);
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
