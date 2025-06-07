import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:url_launcher/url_launcher.dart';

class MapCopyright extends StatelessWidget {
  const MapCopyright({super.key});

  _onTap() {
    var uri = Uri.parse(
      dotenv.get('MAP_TILE_COPYRIGHT'),
    );
    launchUrl(uri);
  }

  @override
  Widget build(BuildContext context) {
    return RichAttributionWidget(
      alignment: AttributionAlignment.bottomRight,
      attributions: [
        TextSourceAttribution(
          'OpenStreetMap',
          onTap: _onTap,
        ),
      ],
    );
  }
}
