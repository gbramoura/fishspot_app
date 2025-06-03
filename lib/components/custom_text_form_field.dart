import 'package:fishspot_app/services/color_converter_service.dart';
import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool obscureText;
  final Icon? icon;
  final Widget? actionIcon;
  final TextInputType? textInputType;
  final String? Function(String?)? validator;
  final bool expands;
  final int? maxLines;
  final int? maxLength;
  final bool readonly;
  final Function()? onTap;

  const CustomTextFormField({
    super.key,
    required this.controller,
    required this.hintText,
    this.obscureText = false,
    this.icon,
    this.actionIcon,
    this.textInputType,
    this.validator,
    this.expands = false,
    this.maxLines = 1,
    this.onTap,
    this.maxLength,
    this.readonly = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      maxLength: maxLength,
      validator: validator,
      cursorColor: ColorConverterService.hexToColor('#35383A'),
      controller: controller,
      obscureText: obscureText,
      style: TextStyle(
        color: ColorConverterService.hexToColor('#35383A'),
        fontSize: 14,
      ),
      readOnly: readonly,
      onTap: onTap,
      keyboardType: textInputType,
      expands: expands,
      maxLines: maxLines,
      textAlignVertical: TextAlignVertical.top,
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
        errorBorder: Theme.of(context).inputDecorationTheme.errorBorder,
        focusedErrorBorder:
            Theme.of(context).inputDecorationTheme.focusedErrorBorder,
        errorStyle: Theme.of(context).inputDecorationTheme.errorStyle,
        fillColor: ColorConverterService.hexToColor('#FFFFFF'),
        hintStyle: TextStyle(
          color: ColorConverterService.hexToColor('#9B959F'),
        ),
      ),
    );
  }
}
