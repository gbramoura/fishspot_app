import 'package:fishspot_app/enums/unit_measure_type.dart';
import 'package:uuid/uuid.dart';

class SpotFish {
  final Uuid id;
  final String name;
  final num weight;
  final UnitMeasureType unitMeasure;
  final List<String> lures;

  SpotFish({
    required this.name,
    required this.weight,
    required this.unitMeasure,
    required this.lures,
    required this.id,
  });

  factory SpotFish.fromJson(Map<String, dynamic> json) {
    return SpotFish(
      id: Uuid(),
      name: json['name'],
      weight: json['weight'].toDouble(),
      unitMeasure: UnitMeasureType.values.firstWhere(
        (e) => e.name == json['unitMeasure'],
      ),
      lures: List<String>.from(json['lures']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'weight': weight,
      'unitMeasure': unitMeasure.name,
      'lures': lures,
    };
  }
}
