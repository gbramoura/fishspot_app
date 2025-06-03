import 'package:fishspot_app/constants/colors_constants.dart';
import 'package:fishspot_app/constants/shared_preferences_constants.dart';
import 'package:fishspot_app/extensions/string_extension.dart';
import 'package:fishspot_app/models/spot.dart';
import 'package:fishspot_app/pages/commons/loading_page.dart';
import 'package:fishspot_app/providers/settings_repository.dart';
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
      await AuthService.refreshCredentials(context);

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

  _gridAxisCount(num count) {
    return count < 2 ? 1 : 2;
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return LoadingPage();
    }

    return Scaffold(
      appBar: _renderAppBar(),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Flexible(flex: 1, child: _renderHeader(context)),
            Flexible(flex: 6, child: _renderBody(context)),
            Flexible(flex: 5, child: _renderTabs(context)),
          ],
        ),
      ),
    );
  }

  _renderHeader(dynamic context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(20, 10, 20, 0),
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
              fontSize: 18,
            ),
          ),
          SizedBox(height: 5),
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
                DateFormat('dd/MM/yyyy').format(
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

  _renderBody(dynamic context) {
    if ((_spot?.images ?? []).isEmpty) {
      return _renderEmptyImages();
    }
    return _renderImages();
  }

  _renderEmptyImages() {
    return Padding(
      padding: EdgeInsets.fromLTRB(20, 10, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 120),
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
          SizedBox(height: 120),
        ],
      ),
    );
  }

  _renderImages() {
    return Padding(
      padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
      child: GridView.builder(
        shrinkWrap: true,
        primary: true,
        scrollDirection: Axis.horizontal,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: _gridAxisCount(_spot?.images.length ?? 0),
          crossAxisSpacing: 10.0,
          mainAxisSpacing: 10.0,
          childAspectRatio: 1.0,
        ),
        itemCount: _spot?.images.length,
        itemBuilder: (BuildContext context, int index) {
          var image = _spot?.images[index];

          return Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              image: DecorationImage(
                fit: BoxFit.cover,
                image: NetworkImage(
                  ImageUtils.getImagePath(image, context),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  _renderTabs(dynamic context) {
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
            overlayColor: WidgetStateProperty.all<Color>(
              Theme.of(context)
                      .textTheme
                      .headlineLarge!
                      .color
                      ?.withValues(alpha: 0.1) ??
                  ColorsConstants.gray50,
            ),
            tabs: [
              Tab(text: 'Espécies'),
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

  _renderAppBar() {
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
