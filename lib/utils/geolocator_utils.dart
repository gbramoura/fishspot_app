import 'package:geolocator/geolocator.dart';

class GeolocatorUtils {
  static Future<Position> getCurrentPosition() async {
    LocationPermission permission;

    if (!await Geolocator.isLocationServiceEnabled()) {
      // Location services are disabled
      return getDefaultPosition();
    }

    permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.denied) {
      // Location permissions are denied
      return getDefaultPosition();
    }

    if (permission == LocationPermission.deniedForever) {
      // Location permissions are permanently denied,
      // we cannot request permissions.
      return getDefaultPosition();
    }

    return await Geolocator.getCurrentPosition();
  }

  static Position getDefaultPosition() {
    return Position(
      longitude: 0,
      latitude: 0,
      timestamp: DateTime(0),
      accuracy: 0,
      altitude: 0,
      altitudeAccuracy: 0,
      heading: 0,
      headingAccuracy: 0,
      speed: 0,
      speedAccuracy: 0,
    );
  }
}
