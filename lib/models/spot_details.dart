class SpotDetails {
  final int registries;
  final int fishes;
  final int lures;

  SpotDetails({
    required this.registries,
    required this.fishes,
    required this.lures,
  });

  factory SpotDetails.fromJson(Map<String, dynamic> json) {
    return SpotDetails(
      registries: json['registries'],
      fishes: json['fishes'],
      lures: json['lures'],
    );
  }
}
