import 'package:fishspot_app/enums/spot_difficulty_type.dart';

class SpotLocationDifficulty {
  final SpotDifficultyType rate;
  final String observation;

  SpotLocationDifficulty({
    required this.rate,
    required this.observation,
  });

  factory SpotLocationDifficulty.fromJson(Map<String, dynamic> json) {
    return SpotLocationDifficulty(
      rate: SpotDifficultyType.values.firstWhere((e) => e.name == json['rate']),
      observation: json['observation'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'rate': rate.name,
      'observation': observation,
    };
  }
}
