import 'package:fishspot_app/constants/colors_constants.dart';
import 'package:fishspot_app/services/color_converter_service.dart';
import 'package:flutter/material.dart';

class SelectInput extends StatelessWidget {
  final List<String> values;
  final String hintText;
  final Icon? icon;
  final void Function(String? value)? onChange;

  SelectInput({
    super.key,
    required this.values,
    required this.hintText,
    this.onChange,
    this.icon,
  });

  final _textcolor = ColorConverterService.hexToColor('#35383A');
  final _focusedBorderColor = ColorConverterService.hexToColor('#00D389');
  final _enabledBorderColor = ColorConverterService.hexToColor('#E2E2E2');
  final _hintColor = ColorConverterService.hexToColor('#9B959F');

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: values.first,
      icon: Icon(
        Icons.arrow_drop_down,
        color: Theme.of(context).iconTheme.color,
      ),
      elevation: 16,
      style: TextStyle(
        color: _textcolor,
        fontSize: 14,
      ),
      onChanged: onChange,
      dropdownColor: ColorsConstants.white,
      decoration: InputDecoration(
        prefixIcon: icon,
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Theme.of(context).buttonTheme.colorScheme?.primary ??
                _focusedBorderColor,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: _enabledBorderColor,
          ),
        ),
        hintText: hintText,
        filled: true,
        errorBorder: Theme.of(context).inputDecorationTheme.errorBorder,
        focusedErrorBorder:
            Theme.of(context).inputDecorationTheme.focusedErrorBorder,
        errorStyle: Theme.of(context).inputDecorationTheme.errorStyle,
        fillColor: ColorsConstants.white,
        hintStyle: TextStyle(
          color: _hintColor,
        ),
      ),
      items: values.map<DropdownMenuItem<String>>(
        (String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        },
      ).toList(),
    );
  }
}
