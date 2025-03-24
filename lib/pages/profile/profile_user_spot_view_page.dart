import 'package:fishspot_app/constants/shared_preferences_constants.dart';
import 'package:fishspot_app/models/http_response.dart';
import 'package:fishspot_app/models/spot.dart';
import 'package:fishspot_app/pages/loading_page.dart';
import 'package:fishspot_app/repositories/settings_repository.dart';
import 'package:fishspot_app/services/api_service.dart';
import 'package:fishspot_app/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfileUserSpotViewPage extends StatefulWidget {
  final String spotId;

  const ProfileUserSpotViewPage({
    super.key,
    required this.spotId,
  });

  @override
  State<ProfileUserSpotViewPage> createState() =>
      _ProfileUserSpotViewPageState();
}

class _ProfileUserSpotViewPageState extends State<ProfileUserSpotViewPage> {
  final ApiService _apiService = ApiService();

  Spot? _spot;
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _loadUserSpot();
  }

  _loadUserSpot() async {
    setState(() {
      _loading = false;
    });

    try {
      var settings = Provider.of<SettingRepository>(context, listen: false);
      var token = settings.getString(SharedPreferencesConstants.jwtToken) ?? '';

      HttpResponse resp = await _apiService.getSpot(widget.spotId, token);
      setState(() {
        _loading = false;
        _spot = Spot.fromJson(resp.response);
      });

      AuthService.refreshCredentials(context);
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

  _getImagePath(String id) {
    var settings = Provider.of<SettingRepository>(context, listen: false);
    var token = settings.getString(SharedPreferencesConstants.jwtToken) ?? '';

    return _apiService.getResource(id, token);
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return LoadingPage();
    }

    return Scaffold(
      appBar: _renderAppBar(context),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.fromLTRB(20, 5, 20, 0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _renderHeader(context),
            ],
          ),
        ),
      ),
    );
  }

  _renderHeader(dynamic context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          _spot?.title ?? '',
          softWrap: true,
          style: TextStyle(
            color: Theme.of(context).textTheme.titleLarge?.color,
            fontWeight: FontWeight.w600,
            fontSize: 22,
          ),
        ),
        SizedBox(height: 10),
        Text(
          // TODO: change color of rate
          'Dificuldade de Chegada: ${_spot?.locationDifficulty.rate}',
          softWrap: true,
          style: TextStyle(
            color: Theme.of(context).textTheme.titleLarge?.color,
            fontWeight: FontWeight.w400,
            fontSize: 14,
          ),
        ),
        SizedBox(height: 10),
        Text(
          // TODO: change color of rate
          'Nivel de Risco: ${_spot?.locationRisk.rate}',
          softWrap: true,
          style: TextStyle(
            color: Theme.of(context).textTheme.titleLarge?.color,
            fontWeight: FontWeight.w400,
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  _renderAppBar(dynamic context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      title: Row(
        children: [
          Text(
            'Registro de Pesca',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: Theme.of(context).textTheme.headlineLarge?.color,
              fontSize: 18,
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          onPressed: () {},
          icon: Icon(Icons.more_horiz),
          color: Theme.of(context).textTheme.headlineLarge?.color,
          iconSize: 32,
        ),
        SizedBox(width: 10)
      ],
    );
  }
}
