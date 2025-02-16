import 'package:fishspot_app/src/utils/hex_color_utils.dart';
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
        style: TextStyle(
          color: HexColor('#00D389'),
          fontWeight: FontWeight.w400,
          fontSize: 14,
        ),
      ),
    );
  }
}
