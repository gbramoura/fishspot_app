class SpotFish {
  final String name;
  final double weight;
  final String unitMeasure;
  final List<String> lures;

  SpotFish({
    required this.name,
    required this.weight,
    required this.unitMeasure,
    required this.lures,
  });

  factory SpotFish.fromJson(Map<String, dynamic> json) {
    return SpotFish(
      name: json['name'],
      weight: json['weight'].toDouble(),
      unitMeasure: json['unitMeasure'],
      lures: List<String>.from(json['lures']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'weight': weight,
      'unitMeasure': unitMeasure,
      'lures': lures,
    };
  }
}
