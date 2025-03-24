class SpotLocationRisk {
  final String rate;
  final String observation;

  SpotLocationRisk({
    required this.rate,
    required this.observation,
  });

  factory SpotLocationRisk.fromJson(Map<String, dynamic> json) {
    return SpotLocationRisk(
      rate: json['rate'],
      observation: json['observation'],
    );
  }
}
