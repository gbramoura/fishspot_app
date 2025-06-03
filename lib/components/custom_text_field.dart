import 'package:fishspot_app/services/color_converter_service.dart';
import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool obscureText;
  final Icon? icon;
  final Widget? actionIcon;
  final TextInputType? textInputType;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.hintText,
    this.obscureText = false,
    this.icon,
    this.actionIcon,
    this.textInputType,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      cursorColor: ColorConverterService.hexToColor('#35383A'),
      style: TextStyle(
        color: ColorConverterService.hexToColor('#35383A'),
        fontSize: 14,
      ),
      keyboardType: textInputType,
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        prefixIcon: icon,
        suffixIcon: actionIcon,
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Theme.of(context).buttonTheme.colorScheme?.primary ??
                ColorConverterService.hexToColor('#00D389'),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: ColorConverterService.hexToColor('#E2E2E2'),
          ),
        ),
        hintText: hintText,
        filled: true,
        fillColor: ColorConverterService.hexToColor('#FFFFFF'),
        hintStyle: TextStyle(
          color: ColorConverterService.hexToColor('#9B959F'),
        ),
      ),
    );
  }
}
