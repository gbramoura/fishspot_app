import 'package:fishspot_app/widgets/button.dart';
import 'package:fishspot_app/constants/colors_constants.dart';
import 'package:fishspot_app/pages/commons/loading_page.dart';
import 'package:fishspot_app/pages/spot/spot_description_page.dart';
import 'package:fishspot_app/providers/location_provider.dart';
import 'package:fishspot_app/providers/spot_data_provider.dart';
import 'package:fishspot_app/services/navigation_service.dart';
import 'package:fishspot_app/widgets/map_copyright.dart';
import 'package:fishspot_app/widgets/map_tile_layer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';

class SpotLocationPage extends StatefulWidget {
  const SpotLocationPage({super.key});

  @override
  State<SpotLocationPage> createState() => _SpotLocationPageState();
}

class _SpotLocationPageState extends State<SpotLocationPage> {
  final MapController _mapController = MapController();
  final NavigationService _navigationService = NavigationService();

  LatLng? _latLng;
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

    var spotProvider = Provider.of<SpotDataProvider>(context, listen: false);
    var locationRepo = Provider.of<LocationProvider>(context, listen: false);
    var coordinates = spotProvider.getCoordinates();

    if (coordinates.isNotEmpty) {
      setState(() {
        _loading = false;
        _latLng = LatLng(
          coordinates[0].toDouble(),
          coordinates[1].toDouble(),
        );
      });
    }

    var position = await locationRepo.getPosition();
    setState(() {
      _loading = false;
      _latLng = LatLng(position.latitude, position.longitude);
    });
  }

  _handleMapChange(MapCamera camera, bool hasGesture) {
    setState(() {
      _latLng = camera.center;
    });
  }

  _handleConfirmButton() {
    var route = MaterialPageRoute(builder: (context) => SpotDescriptionPage());
    var spotProvider = Provider.of<SpotDataProvider>(context, listen: false);

    if (_latLng == null) {
      return;
    }

    spotProvider.setCoordinates(
      _latLng?.latitude ?? 0,
      _latLng?.longitude ?? 0,
    );
    _navigationService.push(context, route);
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return LoadingPage();
    }

    return Scaffold(
      appBar: _renderAppBar(context),
      body: Stack(
        children: [
          Positioned.fill(
            child: Column(
              children: [
                Expanded(child: _renderMap()),
                SizedBox(height: 145),
              ],
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: _renderConfirmGeo(context),
          ),
        ],
      ),
    );
  }

  _renderMap() {
    return FlutterMap(
      mapController: _mapController,
      options: MapOptions(
        initialZoom: 15,
        initialCenter: LatLng(
          _latLng?.latitude ?? 0,
          _latLng?.longitude ?? 0,
        ),
        onPositionChanged: _handleMapChange,
      ),
      children: [
        MapTileLayer(),
        MarkerLayer(
          markers: [
            Marker(
              point: _latLng ?? LatLng(0, 0),
              width: 40,
              height: 40,
              child: Icon(
                Icons.location_on,
                color: Colors.redAccent,
                size: 40,
              ),
            ),
          ],
        ),
        MapCopyright(),
      ],
    );
  }

  _renderConfirmGeo(dynamic context) {
    return Container(
      height: 145,
      width: double.infinity,
      color: Theme.of(context).colorScheme.surface,
      child: Column(
        children: [
          SizedBox(height: 30),
          Button(
            label: "Confirmar Localização",
            onPressed: _handleConfirmButton,
            fixedSize: Size(286, 48),
          ),
          SizedBox(height: 5),
          Text('${_latLng?.latitude}, ${_latLng?.longitude}')
        ],
      ),
    );
  }

  _renderAppBar(dynamic context) {
    return AppBar(
      shadowColor: ColorsConstants.gray350,
      leading: IconButton(
        icon: Icon(
          Icons.close_rounded,
          color: Theme.of(context).textTheme.headlineLarge?.color,
          size: 32,
        ),
        onPressed: () {
          Provider.of<SpotDataProvider>(context, listen: false).clear();
          _navigationService.pop(context);
        },
      ),
      titleSpacing: 0,
      title: Row(
        children: [
          Text(
            'Local de Pesca',
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
