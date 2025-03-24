class SpotLocationDifficulty {
  final String rate;
  final String observation;

  SpotLocationDifficulty({
    required this.rate,
    required this.observation,
  });

  factory SpotLocationDifficulty.fromJson(Map<String, dynamic> json) {
    return SpotLocationDifficulty(
      rate: json['rate'],
      observation: json['observation'],
    );
  }
}
