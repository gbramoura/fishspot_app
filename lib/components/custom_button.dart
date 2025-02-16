import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String label;
  final Size? fixedSize;
  final void Function() onPressed;

  const CustomButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.fixedSize,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        fixedSize: fixedSize,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        backgroundColor: Theme.of(context).buttonTheme.colorScheme?.primary,
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelMedium,
      ),
    );
  }
}
