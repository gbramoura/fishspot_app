import 'package:flutter/material.dart';

class ProfileInfoCount extends StatelessWidget {
  final num value;
  final String title;

  const ProfileInfoCount({
    super.key,
    required this.value,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value.toString(),
          style: TextStyle(
            color: Theme.of(context).textTheme.headlineLarge?.color,
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
        Text(
          title,
          style: TextStyle(
            color: Theme.of(context).textTheme.headlineLarge?.color,
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
      ],
    );
  }
}
