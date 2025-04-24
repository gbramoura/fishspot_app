import 'package:fishspot_app/constants/shared_preferences_constants.dart';
import 'package:fishspot_app/models/spot_location.dart';
import 'package:fishspot_app/pages/commons/loading_page.dart';
import 'package:fishspot_app/pages/map/map_view.dart';
import 'package:fishspot_app/repositories/location_repository.dart';
import 'package:fishspot_app/repositories/settings_repository.dart';
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

    var settings = Provider.of<SettingRepository>(context, listen: false);
    var locationRepo = Provider.of<LocationRepository>(context, listen: false);
    var token = settings.getString(SharedPreferencesConstants.jwtToken) ?? '';

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

      var position = await locationRepo.getPosition();

      setState(() {
        _markers.clear();
        _markers.addAll(markers);
        _position = position;
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

  _handleMarkerTap(String id) {
    // TODO: when open hides the bottom navigation
    setState(() {
      _selectedSpotId = id;
    });
  }

  _close() {
    // TODO: when closes show the bottom navigation again
    _hide();
    setState(() {
      _selectedSpotId = null;
    });
  }

  void _onChanged() {
    if (_controller.size <= 0.05) {
      _hide();
    }
    // TODO: if reach the top, hide the app bar
  }

  void _hide() => _animateSheet(sheet.minChildSize);

  void _animateSheet(double size) {
    _controller.animateTo(
      size,
      duration: const Duration(milliseconds: 50),
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
    if (_loading) {
      return const LoadingPage();
    }

    return Scaffold(
      appBar: _renderAppBar(context),
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
      maxChildSize: 1,
      minChildSize: 0.25,
      expand: true,
      snap: true,
      snapSizes: [0.30, 0.5],
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

  _renderAppBar(dynamic context) {
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: Colors.transparent,
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
