import 'package:fishspot_app/enums/spot_risk_type.dart';
import 'package:fishspot_app/services/spot_display_service.dart';
import 'package:fishspot_app/widgets/rate_card.dart';
import 'package:flutter/material.dart';

class RiskCard extends StatelessWidget {
  final SpotRiskType rate;
  final String observation;

  const RiskCard({
    super.key,
    required this.rate,
    required this.observation,
  });

  @override
  Widget build(BuildContext context) {
    var color = SpotDisplayService.getRiskColor(rate, context) ??
        Theme.of(context).colorScheme.surfaceContainer;

    return RateCard(
      color: color,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            observation,
            softWrap: true,
            style: TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 14,
              color: Theme.of(context).textTheme.headlineLarge?.color,
            ),
          ),
          SizedBox(height: 20),
          RichText(
            softWrap: true,
            text: TextSpan(
              text: 'Nivel de Risco:',
              style: TextStyle(
                color: Theme.of(context).textTheme.headlineLarge?.color,
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
              children: <TextSpan>[
                TextSpan(text: ' '),
                TextSpan(
                  text: SpotDisplayService.getRiskText(rate),
                  style: TextStyle(
                    color: color,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
