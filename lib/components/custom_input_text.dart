import 'package:fishspot_app/utils/hex_color_utils.dart';
import 'package:flutter/material.dart';

class CustomInputText extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool obscureText;
  final Icon? icon;

  const CustomInputText({
    super.key,
    required this.controller,
    required this.hintText,
    required this.obscureText,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      style: TextStyle(fontSize: 14),
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        suffixIcon: icon,
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Theme.of(context).buttonTheme.colorScheme?.primary ??
                HexColor('#00D389'),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: HexColor('#E2E2E2'),
          ),
        ),
        hintText: hintText,
        filled: true,
        fillColor: HexColor('#FFFFFF'),
        hintStyle: TextStyle(
          color: HexColor('#9B959F'),
        ),
      ),
    );
  }
}
