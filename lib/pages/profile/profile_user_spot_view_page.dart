import 'package:cached_network_image/cached_network_image.dart';
import 'package:fishspot_app/constants/colors_constants.dart';
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

  _getDifficultyColor(String rate) {
    switch (rate) {
      case 'VeryEasy':
        return ColorsConstants.green50;
      case 'Easy':
        return ColorsConstants.green100;
      case 'Medium':
        return ColorsConstants.yellow50;
      case 'Hard':
        return ColorsConstants.red100;
      case 'VeryHard':
        return ColorsConstants.red100;
      default:
        return Theme.of(context).textTheme.titleLarge?.color;
    }
  }

  _getRiskColor(String rate) {
    switch (rate) {
      case 'VeryLow':
        return ColorsConstants.green50;
      case 'Low':
        return ColorsConstants.green100;
      case 'Medium':
        return ColorsConstants.yellow50;
      case 'High':
        return ColorsConstants.red100;
      case 'VeryHigh':
        return ColorsConstants.red100;
      default:
        return Theme.of(context).textTheme.titleLarge?.color;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return LoadingPage();
    }

    return Scaffold(
      appBar: _renderAppBar(context),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _renderHeader(context),
            _renderBodyImages(context),
            _renderSpotTab(context)
          ],
        ),
      ),
    );
  }

  _renderHeader(dynamic context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
      child: Column(
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
          Row(
            children: [
              Text(
                'Nivel de Risco: ',
                style: TextStyle(
                  color: Theme.of(context).textTheme.titleLarge?.color,
                  fontWeight: FontWeight.w400,
                  fontSize: 14,
                ),
              ),
              Text(
                '${_spot?.locationRisk.rate}',
                style: TextStyle(
                  color: _getRiskColor(_spot?.locationRisk.rate ?? ''),
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              )
            ],
          ),
          SizedBox(height: 10),
          Row(
            children: [
              Text(
                'Dificuldade de Chegada: ',
                style: TextStyle(
                  color: Theme.of(context).textTheme.titleLarge?.color,
                  fontWeight: FontWeight.w400,
                  fontSize: 14,
                ),
              ),
              Text(
                '${_spot?.locationRisk.rate}',
                style: TextStyle(
                  color:
                      _getDifficultyColor(_spot?.locationDifficulty.rate ?? ''),
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  _renderSpotTab(dynamic context) {
    return DefaultTabController(
      length: 3,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          TabBar(
            dividerColor: Colors.transparent,
            indicatorColor: Theme.of(context).textTheme.titleLarge?.color,
            labelColor: Theme.of(context).textTheme.titleLarge?.color,
            labelStyle: TextStyle(
              color: Theme.of(context).textTheme.titleLarge?.color,
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
            tabs: [
              Tab(text: 'Peixes'),
              Tab(text: 'Localização'),
              Tab(text: 'Riscos'),
            ],
          ),
          // TODO: Change this sized box to Expanded
          SizedBox(
            height: 300.0,
            child: TabBarView(
              children: [
                Center(child: _renderFishesTab()),
                Center(child: Text('Content of Tab 2')),
                Center(child: Text('Content of Tab 3')),
              ],
            ),
          ),
        ],
      ),
    );
  }

  _renderBodyImages(dynamic context) {
    if ((_spot?.images ?? []).isEmpty) {
      return Padding(
        padding: EdgeInsets.fromLTRB(20, 10, 20, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 90),
            Center(
              child: Column(
                children: [
                  Icon(
                    Icons.no_photography,
                    color: Theme.of(context).textTheme.headlineLarge?.color,
                    size: 90,
                  ),
                  Text(
                    'Nenhuma Imagem \n registrada',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Theme.of(context).textTheme.headlineLarge?.color,
                      fontSize: 18,
                      fontWeight: FontWeight.w400,
                    ),
                  )
                ],
              ),
            ),
            SizedBox(height: 90),
          ],
        ),
      );
    }

    return GridView.count(
      primary: true,
      shrinkWrap: true,
      scrollDirection: Axis.horizontal,
      crossAxisCount: 3,
      crossAxisSpacing: 2,
      mainAxisSpacing: 2,
      children: _renderImages(),
    );
  }

  _renderFishesTab() {
    if (_spot == null) return null;

    return GridView.count(
      padding: EdgeInsets.fromLTRB(20, 15, 20, 20),
      scrollDirection: Axis.vertical,
      mainAxisSpacing: 10,
      crossAxisCount: 1,
      childAspectRatio: 5,
      children: _renderFishes(),
    );
  }

  _renderImages() {
    handle(dynamic ctx, String url, DownloadProgress download) {
      return Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: ColorsConstants.gray100,
        ),
        child: Center(
          child: CircularProgressIndicator(
            color: ColorsConstants.gray350,
          ),
        ),
      );
    }

    return _spot?.images.map((image) {
      return CachedNetworkImage(
        imageUrl: _getImagePath(image),
        width: 100,
        fit: BoxFit.cover,
        progressIndicatorBuilder: handle,
      );
    }).toList();
  }

  _renderFishes() {
    return _spot?.fishes.map((fish) {
      return Container(
        padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
        decoration: BoxDecoration(
          color: ColorsConstants.white50,
          border: Border.all(
            color: ColorsConstants.gray50,
            width: 2.0,
          ),
          borderRadius: BorderRadius.circular(5),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  fish.name,
                  style: TextStyle(
                    color: ColorsConstants.gray350,
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
                SizedBox(width: 10),
                Text(
                  '${fish.weight} ${fish.unitMeasure}',
                  style: TextStyle(
                    color: ColorsConstants.gray350,
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: fish.lures.map((lure) {
                return Text(
                  '$lure, ', // TODO: Change this comma
                  style: TextStyle(
                    color: ColorsConstants.gray150,
                    fontWeight: FontWeight.w400,
                    fontSize: 12,
                  ),
                );
              }).toList(),
            )
          ],
        ),
      );
    }).toList();
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
