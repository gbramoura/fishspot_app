import 'package:cached_network_image/cached_network_image.dart';
import 'package:fishspot_app/constants/colors_constants.dart';
import 'package:fishspot_app/constants/shared_preferences_constants.dart';
import 'package:fishspot_app/extensions/string_extension.dart';
import 'package:fishspot_app/models/spot.dart';
import 'package:fishspot_app/pages/commons/loading_page.dart';
import 'package:fishspot_app/repositories/settings_repository.dart';
import 'package:fishspot_app/services/api_service.dart';
import 'package:fishspot_app/services/auth_service.dart';
import 'package:fishspot_app/utils/image_utils.dart';
import 'package:fishspot_app/utils/spot_view_utils.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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
      AuthService.refreshCredentials(context);

      var settings = Provider.of<SettingRepository>(context, listen: false);
      var token = settings.getString(SharedPreferencesConstants.jwtToken) ?? '';

      var resp = await _apiService.getSpot(widget.spotId, token);
      var spot = Spot.fromJson(resp.response);

      setState(() {
        _spot = spot;
      });
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

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return LoadingPage();
    }

    return Scaffold(
      appBar: _renderAppBar(context),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _renderHeader(context),
          _renderBodyImages(context),
          _renderTabs(context)
        ],
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
                'Dia da Pesca: ',
                style: TextStyle(
                  color: Theme.of(context).textTheme.titleLarge?.color,
                  fontWeight: FontWeight.w400,
                  fontSize: 14,
                ),
              ),
              Text(
                DateFormat('yyyy/MM/dd - hh:mm').format(
                  _spot?.date ?? DateTime(0, 0, 0),
                ),
                style: TextStyle(
                  color: Theme.of(context).textTheme.titleLarge?.color,
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

  _renderBodyImages(dynamic context) {
    if ((_spot?.images ?? []).isEmpty) {
      return Padding(
        padding: EdgeInsets.fromLTRB(20, 10, 20, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 100),
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
            SizedBox(height: 100),
          ],
        ),
      );
    }

    // TODO: View this after include more images in the database
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

  _renderTabs(dynamic context) {
    return Expanded(
      child: DefaultTabController(
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
              overlayColor: WidgetStateProperty.all<Color>(
                Theme.of(context)
                        .textTheme
                        .headlineLarge!
                        .color
                        ?.withValues(alpha: 0.1) ??
                    ColorsConstants.gray50,
              ),
              tabs: [
                Tab(text: 'Peixes Pego(s)'),
                Tab(text: 'Dificuldade'),
                Tab(text: 'Riscos'),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  _renderFishesTab(),
                  _renderLocationTab(),
                  _renderRiskTab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  _renderFishesTab() {
    if (_spot == null || _spot!.fishes.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(16.0),
        child: Center(child: Text('Nenhum peixe registrado.')),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(20, 15, 20, 20),
      scrollDirection: Axis.vertical,
      primary: false,
      shrinkWrap: true,
      itemCount: _spot!.fishes.length,
      itemBuilder: (context, index) {
        final fish = _spot!.fishes[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.fromLTRB(20, 10, 10, 10),
          decoration: BoxDecoration(
            color: Theme.of(context).textTheme.headlineLarge?.color,
            border: Border.all(
              color: ColorsConstants.gray50,
              width: 1.0,
            ),
            borderRadius: BorderRadius.circular(5),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    fish.name.toTitleCase,
                    style: TextStyle(
                      color: Theme.of(context).textTheme.labelMedium?.color,
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(width: 5),
                  Text(
                    '●',
                    style: TextStyle(
                      color: Theme.of(context).textTheme.labelMedium?.color,
                      fontWeight: FontWeight.w600,
                      fontSize: 10,
                    ),
                  ),
                  SizedBox(width: 5),
                  Text(
                    '${fish.weight} ${SpotViewUtils.getUnitMeasure(fish.unitMeasure)}',
                    style: TextStyle(
                      color: Theme.of(context).textTheme.labelMedium?.color,
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  )
                ],
              ),
              Text(
                fish.lures.join(', ').toTitleCase,
                softWrap: true,
                style: TextStyle(
                  color: Theme.of(context).textTheme.labelMedium?.color,
                  fontWeight: FontWeight.w400,
                  fontSize: 12,
                ),
              )
            ],
          ),
        );
      },
    );
  }

  _renderLocationTab() {
    var obs = 'Nenhuma observação foi incluida';
    if (_spot != null && _spot!.locationDifficulty.observation.isNotEmpty) {
      obs = _spot!.locationDifficulty.observation;
    }

    return Padding(
      padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: Expanded(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Flexible(
              flex: 1,
              child: Text(
                'Descrição sobre a dificuldade de chegar até o local',
                softWrap: true,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  color: Theme.of(context).textTheme.titleLarge?.color,
                ),
              ),
            ),
            SizedBox(height: 10),
            Flexible(
              flex: 6,
              fit: FlexFit.tight,
              child: Text(
                obs,
                softWrap: true,
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 14,
                  color: Theme.of(context).textTheme.headlineMedium?.color,
                ),
              ),
            ),
            Flexible(
              flex: 1,
              child: _renderDifficultyText(),
            )
          ],
        ),
      ),
    );
  }

  _renderRiskTab() {
    var obs = 'Nenhuma observação foi incluida';
    if (_spot != null && _spot!.locationRisk.observation.isNotEmpty) {
      obs = _spot!.locationRisk.observation;
    }

    return Padding(
      padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: Expanded(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Flexible(
              flex: 1,
              child: Text(
                'Descrição dos riscos encontrados',
                softWrap: true,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  color: Theme.of(context).textTheme.titleLarge?.color,
                ),
              ),
            ),
            SizedBox(height: 10),
            Flexible(
              flex: 6,
              fit: FlexFit.tight,
              child: Text(
                obs,
                softWrap: true,
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 14,
                  color: Theme.of(context).textTheme.headlineMedium?.color,
                ),
              ),
            ),
            Flexible(
              flex: 1,
              child: _renderRiskText(),
            )
          ],
        ),
      ),
    );
  }

  _renderImages() {
    handle(dynamic ctx, String url, DownloadProgress download) {
      return Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: ColorsConstants.gray75,
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
        imageUrl: ImageUtils.getImagePath(image, context),
        width: 100,
        fit: BoxFit.cover,
        progressIndicatorBuilder: handle,
      );
    }).toList();
  }

  _renderRiskText() {
    return Row(
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
          SpotViewUtils.getRiskText(_spot?.locationRisk.rate),
          style: TextStyle(
            color:
                SpotViewUtils.getRiskColor(_spot?.locationRisk.rate, context),
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        )
      ],
    );
  }

  _renderDifficultyText() {
    return Row(
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
          SpotViewUtils.getDifficultyText(_spot?.locationDifficulty.rate),
          style: TextStyle(
            color: SpotViewUtils.getDifficultyColor(
              _spot?.locationDifficulty.rate,
              context,
            ),
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        )
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
