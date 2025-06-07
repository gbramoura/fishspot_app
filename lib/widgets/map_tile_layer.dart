import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_map/flutter_map.dart';

class MapTileLayer extends StatelessWidget {
  const MapTileLayer({super.key});

  @override
  Widget build(BuildContext context) {
    return TileLayer(
      urlTemplate: dotenv.get('MAP_TILE_URL'),
      userAgentPackageName: dotenv.get('MAP_TILE_AGENT_PACKAGE'),
    );
  }
}
