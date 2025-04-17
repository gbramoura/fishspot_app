import 'dart:io';

import 'package:fishspot_app/enums/spot_difficulty_type.dart';
import 'package:fishspot_app/enums/spot_risk_type.dart';
import 'package:fishspot_app/models/spot.dart';
import 'package:fishspot_app/models/spot_fish.dart';
import 'package:fishspot_app/models/spot_location_difficulty.dart';
import 'package:fishspot_app/models/spot_location_risk.dart';
import 'package:fishspot_app/models/user.dart';
import 'package:flutter/material.dart';

class AddSpotRepository extends ChangeNotifier {
  String _title = '';
  String _observation = '';
  DateTime _date = DateTime(0, 0, 0);
  List<num> _coordinates = [];
  List<File> _images = [];
  List<SpotFish> _fishes = [];
  User _user = User(name: '');
  SpotLocationDifficulty _locationDifficulty = SpotLocationDifficulty(
    rate: SpotDifficultyType.Easy,
    observation: '',
  );
  SpotLocationRisk _locationRisk = SpotLocationRisk(
    rate: SpotRiskType.Low,
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

  void setImages(List<File> images) {
    _images.addAll(images);
    notifyListeners();
  }

  void setFishes(List<SpotFish> fishes) {
    _fishes.addAll(fishes);
    notifyListeners();
  }

  void setDescription(String title, String obs, DateTime date) {
    _title = title;
    _observation = obs;
    _date = date;
    notifyListeners();
  }

  List<num> getCoordinates() {
    return _coordinates;
  }

  SpotLocationDifficulty getDifficulty() {
    return _locationDifficulty;
  }

  SpotLocationRisk getRisk() {
    return _locationRisk;
  }

  List<File> getImages() {
    return _images;
  }

  List<SpotFish> getFishes() {
    return _fishes;
  }

  String getTitle() {
    return _title;
  }

  String getObservation() {
    return _observation;
  }

  DateTime getDate() {
    return _date;
  }

  Map<String, dynamic> toPayload() {
    var spot = Spot(
      title: _title,
      observation: _observation,
      date: _date,
      coordinates: _coordinates,
      locationDifficulty: _locationDifficulty,
      locationRisk: _locationRisk,
      images: _images.map((e) => e.path).toList(),
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
      rate: SpotDifficultyType.Easy,
      observation: '',
    );
    _locationRisk = SpotLocationRisk(rate: SpotRiskType.Low, observation: '');
  }
}
