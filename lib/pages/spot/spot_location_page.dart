import 'package:fishspot_app/components/custom_button.dart';
import 'package:fishspot_app/constants/colors_constants.dart';
import 'package:fishspot_app/pages/commons/loading_page.dart';
import 'package:fishspot_app/pages/spot/spot_description_page.dart';
import 'package:fishspot_app/repositories/location_repository.dart';
import 'package:fishspot_app/repositories/spot_repository.dart';
import 'package:fishspot_app/services/navigation_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
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

    var addSpot = Provider.of<SpotRepository>(context, listen: false);
    var locationRepo = Provider.of<LocationRepository>(context, listen: false);
    var coordinates = addSpot.getCoordinates();

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
    var addSpot = Provider.of<SpotRepository>(context, listen: false);

    if (_latLng == null) {
      return;
    }

    addSpot.setCoordinates(_latLng?.latitude ?? 0, _latLng?.longitude ?? 0);
    NavigationService.push(context, route);
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
                Flexible(
                  child: _renderMap(),
                  flex: 6,
                ),
                Flexible(
                  flex: 1,
                  child: Container(color: Colors.transparent),
                )
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
        TileLayer(
          urlTemplate: dotenv.get('MAP_TILE_URL'),
          userAgentPackageName: dotenv.get('MAP_TILE_AGENT_PACKAGE'),
        ),
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
      ],
    );
  }

  _renderConfirmGeo(dynamic context) {
    return Container(
      height: 145,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(25),
        ),
      ),
      child: Column(
        children: [
          SizedBox(height: 30),
          CustomButton(
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
          Provider.of<SpotRepository>(context, listen: false).clear();
          NavigationService.pop(context);
        },
      ),
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
