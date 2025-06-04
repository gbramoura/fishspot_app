import 'package:fishspot_app/enums/unit_measure_type.dart';
import 'package:fishspot_app/extensions/string_extension.dart';
import 'package:fishspot_app/services/spot_display_service.dart';
import 'package:flutter/material.dart';

class FishCard extends StatelessWidget {
  final String name;
  final num weight;
  final UnitMeasureType unitMeasure;
  final List<String> lures;

  const FishCard({
    super.key,
    required this.name,
    required this.weight,
    required this.unitMeasure,
    required this.lures,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).colorScheme.surfaceContainer,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(6),
      ),
      child: Container(
        padding: EdgeInsets.fromLTRB(12, 10, 12, 10),
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
              color: Theme.of(context).colorScheme.primary,
              width: 12,
            ),
          ),
          borderRadius: BorderRadius.circular(5),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  name,
                  style: TextStyle(
                    color: Theme.of(context).textTheme.headlineLarge?.color,
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
                SizedBox(width: 5),
                Text(
                  '●',
                  style: TextStyle(
                    color: Theme.of(context).textTheme.headlineLarge?.color,
                    fontWeight: FontWeight.w600,
                    fontSize: 10,
                  ),
                ),
                SizedBox(width: 5),
                Text(
                  '$weight ${SpotDisplayService.getUnitMeasure(unitMeasure)}',
                  style: TextStyle(
                    color: Theme.of(context).textTheme.headlineLarge?.color,
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                )
              ],
            ),
            Text(
              lures.join(', ').toTitleCase,
              softWrap: true,
              style: TextStyle(
                color: Theme.of(context).textTheme.headlineLarge?.color,
                fontWeight: FontWeight.w400,
                fontSize: 12,
              ),
            )
          ],
        ),
      ),
    );
  }
}
