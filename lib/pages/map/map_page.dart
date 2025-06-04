import 'package:fishspot_app/constants/shared_preferences_constants.dart';
import 'package:fishspot_app/models/spot_location.dart';
import 'package:fishspot_app/pages/commons/loading_page.dart';
import 'package:fishspot_app/pages/map/map_view.dart';
import 'package:fishspot_app/providers/location_provider.dart';
import 'package:fishspot_app/providers/settings_provider.dart';
import 'package:fishspot_app/providers/visible_control_provider.dart';
import 'package:fishspot_app/services/api_service.dart';
import 'package:fishspot_app/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  final ApiService _apiService = ApiService();
  final AuthService _authService = AuthService();

  final List<Marker> _markers = [];
  final MapController _mapController = MapController();
  final _sheet = GlobalKey();
  final _controller = DraggableScrollableController();

  Position? _position;
  bool _loading = false;
  String? _selectedSpotId;

  @override
  void initState() {
    super.initState();
    _loadData();
    _controller.addListener(_onChanged);
  }

  _loadData() async {
    setState(() {
      _loading = true;
    });

    var settings = Provider.of<SettingProvider>(context, listen: false);
    var token = settings.getString(SharedPreferencesConstants.jwtToken) ?? '';
    var locationProvider = Provider.of<LocationProvider>(
      context,
      listen: false,
    );

    try {
      var locationsResponse = await _apiService.getLocations(token);
      var parsedSpot = _parseFishingSpots(locationsResponse.response);
      var markers = parsedSpot.map((element) {
        return Marker(
          width: 40.0,
          height: 40.0,
          point: LatLng(
            element.coordinates[0].toDouble(),
            element.coordinates[1].toDouble(),
          ),
          child: IconButton(
            onPressed: () => _handleMarkerTap(element.id),
            icon: const Icon(
              Icons.location_pin,
              color: Colors.red,
              size: 40,
            ),
          ),
        );
      });

      var position = await locationProvider.getPosition();

      setState(() {
        _markers.clear();
        _markers.addAll(markers);
        _position = position;
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

  _handleMarkerTap(String id) {
    var provider = Provider.of<VisibleControlProvider>(context, listen: false);

    provider.setVisible(false);
    provider.setAppBarVisible(false);

    setState(() {
      _selectedSpotId = id;
    });
  }

  _close() {
    var provider = Provider.of<VisibleControlProvider>(context, listen: false);

    _hide();

    provider.setVisible(true);
    provider.setAppBarVisible(true);

    setState(() {
      _selectedSpotId = null;
    });
  }

  void _onChanged() {
    if (_controller.size <= 0.05) {
      _hide();
    }
  }

  void _hide() => _animateSheet(sheet.minChildSize);

  void _animateSheet(double size) {
    _controller.animateTo(
      size,
      duration: Duration(milliseconds: 50),
      curve: Curves.easeInOut,
    );
  }

  DraggableScrollableSheet get sheet =>
      (_sheet.currentWidget as DraggableScrollableSheet);

  List<SpotLocation> _parseFishingSpots(List<dynamic> jsonList) {
    return jsonList.map((json) => SpotLocation.fromJson(json)).toList();
  }

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<VisibleControlProvider>(context);

    if (_loading) {
      return const LoadingPage();
    }

    return Scaffold(
      appBar: provider.isAppBarVisible() ? _renderAppBar() : null,
      body: Stack(
        children: [
          _renderMap(),
          _renderSheet(),
        ],
      ),
    );
  }

  _renderMap() {
    return FlutterMap(
      mapController: _mapController,
      options: MapOptions(
        initialCenter: LatLng(
          _position?.latitude ?? 0,
          _position?.longitude ?? 0,
        ),
        initialZoom: 15,
      ),
      children: [
        TileLayer(
          urlTemplate: dotenv.get('MAP_TILE_URL'),
          userAgentPackageName: dotenv.get('MAP_TILE_AGENT_PACKAGE'),
        ),
        MarkerLayer(markers: _markers),
      ],
    );
  }

  _renderSheet() {
    if (_selectedSpotId == null) {
      return Container();
    }

    return DraggableScrollableSheet(
      key: _sheet,
      initialChildSize: 0.5,
      maxChildSize: 0.97,
      minChildSize: 0.20,
      expand: true,
      controller: _controller,
      builder: (BuildContext context, ScrollController scrollController) {
        return MapView(
          context: context,
          scrollController: scrollController,
          spotId: _selectedSpotId ?? "",
          onClose: _close,
        );
      },
    );
  }

  _renderAppBar() {
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: Theme.of(context).colorScheme.surface,
      foregroundColor: Theme.of(context).colorScheme.surface,
      surfaceTintColor: Theme.of(context).colorScheme.surface,
      title: Row(
        children: [
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
          onPressed: () {},
          icon: const Icon(Icons.search),
          color: Theme.of(context).textTheme.headlineLarge?.color,
          iconSize: 32,
        ),
        const SizedBox(width: 10)
      ],
    );
  }
}
