import 'package:fishspot_app/constants/colors_constants.dart';
import 'package:fishspot_app/utils/hex_color_utils.dart';
import 'package:flutter/material.dart';

class CustomDropdownButton extends StatelessWidget {
  final List<String> values;
  final void Function(String? value)? onChange;
  final String hintText;
  final Icon? icon;

  const CustomDropdownButton({
    super.key,
    required this.values,
    required this.hintText,
    this.onChange,
    this.icon,
  });

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
        color: HexColor('#35383A'),
        fontSize: 14,
      ),
      onChanged: onChange,
      dropdownColor: ColorsConstants.white50,
      decoration: InputDecoration(
        prefixIcon: icon,
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Theme.of(context).buttonTheme.colorScheme?.primary ??
                HexColor('#00D389'),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: HexColor('#E2E2E2')),
        ),
        hintText: hintText,
        filled: true,
        errorBorder: Theme.of(context).inputDecorationTheme.errorBorder,
        focusedErrorBorder:
            Theme.of(context).inputDecorationTheme.focusedErrorBorder,
        errorStyle: Theme.of(context).inputDecorationTheme.errorStyle,
        fillColor: ColorsConstants.white50,
        hintStyle: TextStyle(
          color: HexColor('#9B959F'),
        ),
      ),
      items: values.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }
}
