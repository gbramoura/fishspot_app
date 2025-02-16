import 'package:flutter/material.dart';

class CustomTextButton extends StatelessWidget {
  final String label;
  final void Function() onPressed;

  const CustomTextButton({
    super.key,
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelMedium,
      ),
    );
  }
}
