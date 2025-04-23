import 'package:fishspot_app/models/spot_fish.dart';
import 'package:fishspot_app/models/spot_location_difficulty.dart';
import 'package:fishspot_app/models/spot_location_risk.dart';
import 'package:fishspot_app/models/user.dart';

class Spot {
  final String title;
  final String observation;
  final DateTime date;
  final List<num> coordinates;
  final SpotLocationDifficulty locationDifficulty;
  final SpotLocationRisk locationRisk;
  final List<String> images;
  final List<SpotFish> fishes;
  final User user;

  Spot({
    required this.title,
    required this.observation,
    required this.date,
    required this.coordinates,
    required this.locationDifficulty,
    required this.locationRisk,
    required this.images,
    required this.fishes,
    required this.user,
  });

  factory Spot.fromJson(Map<String, dynamic> json) {
    return Spot(
      title: json['title'],
      observation: json['observation'],
      date: DateTime.parse(json['date']),
      coordinates: List<num>.from(json['coordinates']),
      locationDifficulty: SpotLocationDifficulty.fromJson(
        json['locationDifficulty'],
      ),
      locationRisk: SpotLocationRisk.fromJson(json['locationRisk']),
      images: List<String>.from(json['images']),
      fishes: (json['fishes'] as List)
          .map((fish) => SpotFish.fromJson(fish))
          .toList(),
      user: User.fromJson(json['user']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'observation': observation,
      'date': date.toIso8601String(),
      'coordinates': coordinates,
      'locationDifficulty': locationDifficulty.toJson(),
      'locationRisk': locationRisk.toJson(),
      'images': images,
      'fishes': fishes.map((fish) => fish.toJson()).toList(),
      'user': user.toJson(),
    };
  }
}
