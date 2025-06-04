import 'package:flutter/material.dart';

class RateCard extends StatelessWidget {
  final Widget child;
  final Color color;

  const RateCard({
    super.key,
    required this.child,
    required this.color,
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
              color: color,
              width: 12,
            ),
          ),
          borderRadius: BorderRadius.circular(5),
        ),
        child: child,
      ),
    );
  }
}
