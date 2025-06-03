import 'package:fishspot_app/components/persistent_header_delegate.dart';
import 'package:fishspot_app/constants/colors_constants.dart';
import 'package:fishspot_app/constants/shared_preferences_constants.dart';
import 'package:fishspot_app/extensions/string_extension.dart';
import 'package:fishspot_app/models/spot.dart';
import 'package:fishspot_app/providers/settings_provider.dart';
import 'package:fishspot_app/services/api_service.dart';
import 'package:fishspot_app/services/auth_service.dart';
import 'package:fishspot_app/services/image_service.dart';
import 'package:fishspot_app/services/spot_display_service.dart';
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
  final List<String> _tabTitles = ['Espécies', 'Dificuldade', 'Riscos'];

  late TabController _tabController;

  Spot? _spot;
  String _spotId = "";
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabTitles.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  _loadUserSpot() async {
    setState(() {
      _loading = true;
    });

    try {
      if (!await AuthService.isUserAuthenticated(context)) {
        if (mounted) {
          AuthService.clearCredentials(context);
          AuthService.showAuthDialog(context);
        }
        return;
      }

      if (!mounted) return;

      var settings = Provider.of<SettingProvider>(context, listen: false);
      var token = settings.getString(SharedPreferencesConstants.jwtToken) ?? '';

      await AuthService.refreshCredentials(context);

      var resp = await _apiService.getSpot(widget.spotId, token);
      var spot = Spot.fromJson(resp.response);

      setState(() {
        _spotId = widget.spotId;
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
    if (widget.spotId != _spotId) {
      _loadUserSpot();
    }

    if (_loading) {
      return _renderLoadingSpinner();
    }

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
        slivers: _render(),
      ),
    );
  }

  List<Widget> _render() {
    return [
      _renderGrabSliver(),
      _renderHeaderSliver(),
      _renderBodySliver(),
      _renderDivider(), // divisor
      _renderFishes(),
      _renderDivider(), // divisor
      _renderLocation(),
      _renderDivider(), // divisor
      _renderRisk(),
      _renderDivider(), // divisor
      SliverToBoxAdapter(child: SizedBox(height: 25)),
    ];
  }

  _renderGrabSliver() {
    return SliverPersistentHeader(
      pinned: true,
      floating: true,
      delegate: PersistentHeaderDelegate(
        minExtent: 38.0,
        maxExtent: 38.0,
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
            ),
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

  _renderHeaderSliver() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.only(left: 20, right: 20),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Flexible(
              flex: 8,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 5),
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
            ),
            Flexible(
              flex: 1,
              child: IconButton(
                onPressed: widget.onClose,
                icon: Icon(
                  size: 32,
                  Icons.close,
                  color: Theme.of(context).textTheme.headlineLarge?.color,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  _renderBodySliver() {
    if ((_spot?.images ?? []).isEmpty) {
      return _renderEmptyImagesSliver();
    }
    return _renderImagesSliver();
  }

  _renderEmptyImagesSliver() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.fromLTRB(20, 10, 20, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 60),
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
            SizedBox(height: 80),
          ],
        ),
      ),
    );
  }

  _renderImagesSliver() {
    return SliverPadding(
      padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
      sliver: SliverGrid(
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
      ),
    );
  }

  _renderFishes() {
    if (_spot == null || _spot!.fishes.isEmpty) {
      return SliverPadding(
        padding: EdgeInsets.all(16.0),
        sliver: SliverToBoxAdapter(
          child: Center(
            child: Text('Nenhum peixe registrado.'),
          ),
        ),
      );
    }

    return SliverPadding(
      padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            final fish = _spot!.fishes[index];

            return Container(
              margin: EdgeInsets.only(bottom: 10),
              padding: EdgeInsets.fromLTRB(20, 10, 10, 10),
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
                        '${fish.weight} ${SpotDisplayService.getUnitMeasure(fish.unitMeasure)}',
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
          childCount: _spot!.fishes.length,
        ),
      ),
    );
  }

  _renderLocation() {
    var obs = 'Nenhuma observação foi incluida';
    var isNotEmpty =
        _spot != null && _spot!.locationDifficulty.observation.isNotEmpty;

    if (isNotEmpty) {
      obs = _spot!.locationDifficulty.observation;
    }

    return SliverPadding(
      padding: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
      sliver: SliverList.list(
        children: [
          Text(
            'Localização',
            softWrap: true,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 16,
              color: Theme.of(context).textTheme.titleLarge?.color,
            ),
          ),
          SizedBox(height: 10),
          Text(
            obs,
            softWrap: true,
            style: TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 14,
              color: Theme.of(context).textTheme.headlineMedium?.color,
            ),
          ),
          SizedBox(height: 20),
          RichText(
            softWrap: true,
            text: TextSpan(
              text: 'Dificuldade de Chegada:',
              style: TextStyle(
                color: Theme.of(context).textTheme.titleLarge?.color,
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
              children: <TextSpan>[
                TextSpan(text: ' '),
                TextSpan(
                  text: SpotDisplayService.getDifficultyText(
                    _spot?.locationDifficulty.rate,
                  ),
                  style: TextStyle(
                    color: SpotDisplayService.getDifficultyColor(
                      _spot?.locationDifficulty.rate,
                      context,
                    ),
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  _renderRisk() {
    var obs = 'Nenhuma observação foi incluida';
    var isNotEmpty =
        _spot != null && _spot!.locationRisk.observation.isNotEmpty;

    if (isNotEmpty) {
      obs = _spot!.locationRisk.observation;
    }
    return SliverPadding(
      padding: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
      sliver: SliverList.list(
        children: [
          Text(
            'Riscos',
            softWrap: true,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 16,
              color: Theme.of(context).textTheme.titleLarge?.color,
            ),
          ),
          SizedBox(height: 10),
          Text(
            obs,
            softWrap: true,
            style: TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 14,
              color: Theme.of(context).textTheme.headlineMedium?.color,
            ),
          ),
          SizedBox(height: 20),
          RichText(
            softWrap: true,
            text: TextSpan(
              text: 'Nivel de Risco: ',
              style: TextStyle(
                color: Theme.of(context).textTheme.titleLarge?.color,
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
              children: <TextSpan>[
                TextSpan(text: ' '),
                TextSpan(
                  text:
                      SpotDisplayService.getRiskText(_spot?.locationRisk.rate),
                  style: TextStyle(
                    color: SpotDisplayService.getRiskColor(
                      _spot?.locationRisk.rate,
                      context,
                    ),
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  _renderDivider() {
    return SliverToBoxAdapter(
      child: Divider(color: Theme.of(context).iconTheme.color!.withAlpha(250)),
    );
  }

  _renderLoadingSpinner() {
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
          _renderGrabSliver(),
          SliverToBoxAdapter(child: SizedBox(height: 80)),
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
}
