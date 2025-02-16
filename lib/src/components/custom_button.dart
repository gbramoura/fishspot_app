import 'package:fishspot_app/src/utils/hex_color_utils.dart';
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
        backgroundColor: HexColor('#00D389'),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: HexColor('#35383A'),
          fontWeight: FontWeight.w500,
          fontSize: 16,
        ),
      ),
    );
  }
}
