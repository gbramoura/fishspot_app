import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class LocationProvider extends ChangeNotifier {
  late bool _isPermissionChecked = false;
  late Position _position;

  Future<Position> getPosition() {
    if (_isPermissionChecked) {
      return Future.value(_position);
    }
    return _tryGetPosition();
  }

  Future<Position> _tryGetPosition() async {
    LocationPermission permission;

    if (!await Geolocator.isLocationServiceEnabled()) {
      // Location services are disabled
      return _setPosition(defaultPosition());
    }

    permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.denied) {
      // Location permissions are denied
      return _setPosition(defaultPosition());
    }

    if (permission == LocationPermission.deniedForever) {
      // Location permissions are permanently denied,
      // we cannot request permissions.
      return _setPosition(defaultPosition());
    }

    return _setPosition(await Geolocator.getCurrentPosition());
  }

  _setPosition(Position position) {
    _position = position;
    _isPermissionChecked = true;
    return _position;
  }

  clear() {
    _isPermissionChecked = false;
  }

  defaultPosition() {
    return Position(
      longitude: 0,
      latitude: 0,
      timestamp: DateTime(0, 0, 0),
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
