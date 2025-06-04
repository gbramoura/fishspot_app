import 'package:fishspot_app/delagates/persistent_header_delegate.dart';
import 'package:fishspot_app/constants/colors_constants.dart';
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

class MapView extends StatefulWidget {
  final BuildContext context;
  final ScrollController scrollController;
  final String spotId;
  final void Function() onClose;

  const MapView({
    super.key,
    required this.context,
    required this.scrollController,
    required this.spotId,
    required this.onClose,
  });

  @override
  State<MapView> createState() => _MapViewState();
}

class _MapViewState extends State<MapView> with SingleTickerProviderStateMixin {
  final ApiService _apiService = ApiService();
  final ImageService _imageService = ImageService();
  final AuthService _authService = AuthService();

  Spot? _spot;
  String _spotId = "";
  bool _loading = true;

  @override
  void initState() {
    super.initState();
  }

  _loadUserSpot() async {
    setState(() {
      _loading = true;
    });

    try {
      if (!await _authService.isUserAuthenticated(context)) {
        if (mounted) {
          _authService.clearCredentials(context);
          _authService.showAuthDialog(context);
        }
        return;
      }

      if (!mounted) return;

      var settings = Provider.of<SettingProvider>(context, listen: false);
      var token = settings.getString(SharedPreferencesConstants.jwtToken) ?? '';

      await _authService.refreshCredentials(context);

      var resp = await _apiService.getSpot(widget.spotId, token);
      var spot = Spot.fromJson(resp.response);

      setState(() {
        _spot = spot;
        _spotId = widget.spotId;
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
    if (widget.spotId != _spotId) {
      _loadUserSpot();
    }

    if (_loading) {
      return _loadingContent();
    }

    return Container(
      padding: EdgeInsets.only(left: 20, right: 20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      child: CustomScrollView(
        controller: widget.scrollController,
        slivers: _render(),
      ),
    );
  }

  List<Widget> _render() {
    return [
      _grab(),
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

  _grab() {
    return SliverPersistentHeader(
      pinned: true,
      floating: true,
      delegate: PersistentHeaderDelegate(
        minExtent: 38.0,
        maxExtent: 38.0,
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
          ),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Container(
                      height: 6,
                      width: 180,
                      decoration: BoxDecoration(
                        color: ColorsConstants.gray100,
                        borderRadius: BorderRadius.circular(50),
                      ),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
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
          IconButton(
            onPressed: widget.onClose,
            icon: Icon(
              size: 32,
              Icons.close,
              color: Theme.of(context).textTheme.headlineLarge?.color,
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
        controller: widget.scrollController,
        slivers: [
          _grab(),
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
}
