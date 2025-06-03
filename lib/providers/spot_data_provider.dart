import 'package:fishspot_app/enums/spot_difficulty_type.dart';
import 'package:fishspot_app/enums/spot_risk_type.dart';
import 'package:fishspot_app/models/spot.dart';
import 'package:fishspot_app/models/spot_fish.dart';
import 'package:fishspot_app/models/spot_image.dart';
import 'package:fishspot_app/models/spot_location_difficulty.dart';
import 'package:fishspot_app/models/spot_location_risk.dart';
import 'package:fishspot_app/models/user.dart';
import 'package:flutter/material.dart';

class SpotDataProvider extends ChangeNotifier {
  String _title = '';
  String _observation = '';
  DateTime _date = DateTime(0, 0, 0);
  List<num> _coordinates = [];
  List<SpotImage> _images = [];
  List<SpotFish> _fishes = [];
  User _user = User(name: '');
  SpotLocationDifficulty _locationDifficulty = SpotLocationDifficulty(
    rate: SpotDifficultyType.easy,
    observation: '',
  );
  SpotLocationRisk _locationRisk = SpotLocationRisk(
    rate: SpotRiskType.low,
    observation: '',
  );

  void setCoordinates(double lat, double lng) {
    _coordinates.addAll([lat, lng]);
    notifyListeners();
  }

  void setDifficulty(SpotDifficultyType rate, String obs) {
    _locationDifficulty = SpotLocationDifficulty(rate: rate, observation: obs);
    notifyListeners();
  }

  void setRisk(SpotRiskType rate, String obs) {
    _locationRisk = SpotLocationRisk(rate: rate, observation: obs);
    notifyListeners();
  }

  void setImages(List<SpotImage> images) {
    _images = images;
    notifyListeners();
  }

  void setFishes(List<SpotFish> fishes) {
    _fishes = fishes;
    notifyListeners();
  }

  void setDescription(String title, String obs, DateTime date) {
    _title = title;
    _observation = obs;
    _date = date;
    notifyListeners();
  }

  void addImages(List<SpotImage> images) {
    _images.addAll(images);
    notifyListeners();
  }

  void addFishes(List<SpotFish> fishes) {
    _fishes.addAll(fishes);
    notifyListeners();
  }

  List<num> getCoordinates() => _coordinates;

  SpotLocationDifficulty getDifficulty() => _locationDifficulty;

  SpotLocationRisk getRisk() => _locationRisk;

  List<SpotImage> getImages() => _images;

  List<SpotFish> getFishes() => _fishes;

  String getTitle() => _title;

  String getObservation() => _observation;

  DateTime getDate() => _date;

  Map<String, dynamic> toPayload() {
    var spot = Spot(
      title: _title,
      observation: _observation,
      date: _date,
      coordinates: _coordinates,
      locationDifficulty: _locationDifficulty,
      locationRisk: _locationRisk,
      images: [],
      fishes: _fishes,
      user: _user,
    );

    return spot.toJson();
  }

  void clear() {
    _title = '';
    _observation = '';
    _date = DateTime(0, 0, 0);
    _coordinates = [];
    _images = [];
    _fishes = [];
    _user = User(name: '');
    _locationDifficulty = SpotLocationDifficulty(
      rate: SpotDifficultyType.easy,
      observation: '',
    );
    _locationRisk = SpotLocationRisk(rate: SpotRiskType.low, observation: '');
  }
}
