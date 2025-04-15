import 'package:fishspot_app/constants/shared_preferences_constants.dart';
import 'package:fishspot_app/models/spot_location.dart';
import 'package:fishspot_app/pages/commons/loading_page.dart';
import 'package:fishspot_app/repositories/settings_repository.dart';
import 'package:fishspot_app/services/api_service.dart';
import 'package:fishspot_app/services/auth_service.dart';
import 'package:fishspot_app/utils/geolocator_utils.dart';
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

  Position? _position;
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  _loadData() async {
    setState(() {
      _loading = true;
    });

    var settings = Provider.of<SettingRepository>(context, listen: false);
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
          child: Icon(Icons.location_pin, color: Colors.red, size: 40),
        );
      });

      var position = await GeolocatorUtils.getCurrentPosition();

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

  List<SpotLocation> _parseFishingSpots(List<dynamic> jsonList) {
    return jsonList.map((json) => SpotLocation.fromJson(json)).toList();
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return LoadingPage();
    }

    return Scaffold(
      appBar: _renderAppBar(context),
      body: FlutterMap(
        mapController: _mapController,
        options: MapOptions(
          initialCenter:
              LatLng(_position?.latitude ?? 0, _position?.longitude ?? 0),
          initialZoom: 15,
        ),
        children: [
          TileLayer(
            urlTemplate: dotenv.get('MAP_TILE_URL'),
            userAgentPackageName: dotenv.get('MAP_TILE_AGENT_PACKAGE'),
          ),
          MarkerLayer(markers: _markers),
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
        // TODO: Make the search page works
        IconButton(
          onPressed: () {},
          icon: Icon(Icons.search),
          color: Theme.of(context).textTheme.headlineLarge?.color,
          iconSize: 32,
        ),
        SizedBox(width: 10)
      ],
    );
  }
}
