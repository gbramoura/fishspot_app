import 'package:flutter/material.dart';

class CustomTextButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  final TextStyle? style;

  const CustomTextButton({
    super.key,
    required this.label,
    required this.onTap,
    this.style,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: label,
      button: true,
      child: GestureDetector(
        onTap: onTap,
        child: RichText(
          text: TextSpan(
            text: label,
            style: style,
          ),
        ),
      ),
    );
  }
}
