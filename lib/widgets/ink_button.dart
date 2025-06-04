import 'package:flutter/material.dart';

class InkButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  final TextStyle? style;

  const InkButton({
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
      child: InkWell(
        onTap: onTap,
        child: Ink(
          padding: EdgeInsets.all(2),
          child: Text(label, style: style),
        ),
      ),
    );
  }
}
