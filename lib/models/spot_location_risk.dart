import 'package:fishspot_app/enums/spot_risk_type.dart';

class SpotLocationRisk {
  final SpotRiskType rate;
  final String observation;

  SpotLocationRisk({
    required this.rate,
    required this.observation,
  });

  factory SpotLocationRisk.fromJson(Map<String, dynamic> json) {
    return SpotLocationRisk(
      rate: SpotRiskType.values.firstWhere(
        (e) => e.name.toLowerCase() == json['rate'].toString().toLowerCase(),
      ),
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
