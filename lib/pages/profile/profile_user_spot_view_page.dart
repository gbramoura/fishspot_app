import 'package:fishspot_app/constants/shared_preferences_constants.dart';
import 'package:fishspot_app/enums/spot_difficulty_type.dart';
import 'package:fishspot_app/enums/spot_risk_type.dart';
import 'package:fishspot_app/models/spot.dart';
import 'package:fishspot_app/providers/settings_provider.dart';
import 'package:fishspot_app/services/api_service.dart';
import 'package:fishspot_app/services/auth_service.dart';
import 'package:fishspot_app/services/image_service.dart';
import 'package:fishspot_app/widgets/fish_card.dart';
import 'package:fishspot_app/widgets/location_card.dart';
import 'package:fishspot_app/widgets/risk_card.dart';
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
  final ImageService _imageService = ImageService();
  final AuthService _authService = AuthService();

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
      await _authService.refreshCredentials(context);

      if (!mounted) return;

      var settings = Provider.of<SettingProvider>(context, listen: false);
      var token = settings.getString(SharedPreferencesConstants.jwtToken) ?? '';

      var resp = await _apiService.getSpot(widget.spotId, token);
      var spot = Spot.fromJson(resp.response);

      setState(() {
        _spot = spot;
      });
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

  _gridAxisCount(num count) {
    return count < 2 ? 1 : 2;
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return _loadingContent();
    }

    return Scaffold(
      appBar: _appBar(),
      body: Container(
        padding: EdgeInsets.only(left: 20, right: 20),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
          ),
        ),
        child: CustomScrollView(
          slivers: _render(),
        ),
      ),
    );
  }

  List<Widget> _render() {
    return [
      _header(),
      _margin(25),
      _images(),
      _margin(25),
      _sectionHeader('Peixes'),
      _margin(15),
      _fishes(),
      _margin(15),
      _sectionHeader('Localização'),
      _margin(15),
      _location(),
      _margin(15),
      _sectionHeader('Riscos'),
      _margin(15),
      _risk(),
      _margin(25),
    ];
  }

  _header() {
    return SliverToBoxAdapter(
      child: Row(
        children: [
          Expanded(
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
                    fontSize: 24,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  DateFormat('dd/MM/yyyy').format(
                    _spot?.date ?? DateTime(0, 0, 0),
                  ),
                  style: TextStyle(
                    color: Theme.of(context).textTheme.titleLarge?.color,
                    fontWeight: FontWeight.w400,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  _images() => (_spot?.images ?? []).isEmpty ? _emptyImages() : _filledImages();

  _emptyImages() {
    return SliverToBoxAdapter(
      child: SizedBox(
        height: 300,
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
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
    );
  }

  _filledImages() {
    return SliverGrid(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: _gridAxisCount(_spot?.images.length ?? 0),
        crossAxisSpacing: 5.0,
        mainAxisSpacing: 5.0,
        childAspectRatio: 1.0,
      ),
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) {
          final image = _spot?.images[index];

          if (image == null) {
            return SizedBox.shrink();
          }

          return Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              image: DecorationImage(
                fit: BoxFit.cover,
                image: NetworkImage(
                  _imageService.getImagePath(context, image),
                ),
              ),
            ),
          );
        },
        childCount: _spot?.images.length ?? 0,
      ),
    );
  }

  _fishes() {
    if (_spot == null || _spot!.fishes.isEmpty) {
      return SliverToBoxAdapter(
        child: Center(
          child: Text('Nenhum peixe registrado.'),
        ),
      );
    }

    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          final fish = _spot!.fishes[index];
          return Padding(
            padding: EdgeInsets.only(bottom: 5),
            child: FishCard(
              name: fish.name,
              unitMeasure: fish.unitMeasure,
              weight: fish.weight,
              lures: fish.lures,
            ),
          );
        },
        childCount: _spot!.fishes.length,
      ),
    );
  }

  _location() {
    var observation = 'Nenhuma observação foi incluida';
    var rate = SpotDifficultyType.veryEasy;

    if (_spot != null && _spot!.locationDifficulty.observation.isNotEmpty) {
      observation = _spot!.locationDifficulty.observation;
    }

    if (_spot != null) {
      rate = _spot!.locationDifficulty.rate;
    }

    return SliverToBoxAdapter(
      child: LocationCard(observation: observation, rate: rate),
    );
  }

  _risk() {
    var observation = 'Nenhuma observação foi incluida';
    var rate = SpotRiskType.veryLow;

    if (_spot != null && _spot!.locationRisk.observation.isNotEmpty) {
      observation = _spot!.locationRisk.observation;
    }

    if (_spot != null) {
      rate = _spot!.locationRisk.rate;
    }

    return SliverToBoxAdapter(
      child: RiskCard(observation: observation, rate: rate),
    );
  }

  _loadingContent() {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      child: CustomScrollView(
        slivers: [
          _margin(80),
          SliverToBoxAdapter(
            child: Center(
              child: CircularProgressIndicator(
                color: Theme.of(context).textTheme.headlineLarge?.color,
              ),
            ),
          ),
        ],
      ),
    );
  }

  _sectionHeader(String label) {
    return SliverToBoxAdapter(
      child: Text(
        label,
        softWrap: true,
        style: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 22,
          color: Theme.of(context).textTheme.titleLarge?.color,
        ),
      ),
    );
  }

  _margin(double size) => SliverToBoxAdapter(child: SizedBox(height: size));

  _appBar() {
    return AppBar(
      titleSpacing: 0,
      backgroundColor: Theme.of(context).colorScheme.surface,
      surfaceTintColor: Theme.of(context).colorScheme.surface,
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
    );
  }
}
