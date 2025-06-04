import 'package:fishspot_app/services/color_converter_service.dart';
import 'package:flutter/material.dart';

class TextInput extends StatefulWidget {
  final TextEditingController controller;
  final TextInputType? textInputType;
  final String label;
  final IconData? icon;
  final bool obscureTextAction;
  final bool obscureText;
  final bool expands;
  final bool readonly;
  final int? maxLines;
  final int? maxLength;
  final String? Function(String?)? validator;
  final void Function()? onTap;

  const TextInput({
    super.key,
    required this.controller,
    required this.label,
    this.obscureText = false,
    this.icon,
    this.textInputType,
    this.validator,
    this.expands = false,
    this.maxLines = 1,
    this.onTap,
    this.maxLength,
    this.readonly = false,
    this.obscureTextAction = false,
  });

  @override
  State<TextInput> createState() => _TextInputState();
}

class _TextInputState extends State<TextInput> {
  final _cursorColor = ColorConverterService.hexToColor('#35383A');
  final _textColor = ColorConverterService.hexToColor('#35383A');
  final _focusedBorderColor = ColorConverterService.hexToColor('#00D389');
  final _enabledBorderColor = ColorConverterService.hexToColor('#E2E2E2');
  final _fillColor = ColorConverterService.hexToColor('#FFFFFF');
  final _hintColor = ColorConverterService.hexToColor('#9B959F');

  bool _isObscureTextVisible = true;

  void _handleObscureText() {
    setState(() {
      _isObscureTextVisible = !_isObscureTextVisible;
    });
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      maxLength: widget.maxLength,
      validator: widget.validator,
      cursorColor: _cursorColor,
      controller: widget.controller,
      obscureText: widget.obscureText ? _isObscureTextVisible : false,
      style: TextStyle(
        color: _textColor,
        fontSize: 14,
      ),
      readOnly: widget.readonly,
      onTap: widget.onTap,
      keyboardType: widget.textInputType,
      expands: widget.expands,
      maxLines: widget.maxLines,
      textAlignVertical: TextAlignVertical.top,
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        prefixIcon: _prefixIcon(),
        suffixIcon: _suffixIcon(),
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
        hintText: widget.label,
        filled: true,
        errorBorder: Theme.of(context).inputDecorationTheme.errorBorder,
        focusedErrorBorder:
            Theme.of(context).inputDecorationTheme.focusedErrorBorder,
        errorStyle: Theme.of(context).inputDecorationTheme.errorStyle,
        hintStyle: TextStyle(color: _hintColor),
        fillColor: _fillColor,
      ),
    );
  }

  Widget? _prefixIcon() {
    if (widget.icon != null) {
      return Icon(
        widget.icon,
        color: Theme.of(context).iconTheme.color,
      );
    }

    return null;
  }

  Widget? _suffixIcon() {
    if (widget.obscureTextAction) {
      return IconButton(
        onPressed: _handleObscureText,
        icon: Icon(
          _isObscureTextVisible ? Icons.visibility : Icons.visibility_off,
          color: Theme.of(context).iconTheme.color,
        ),
      );
    }

    return null;
  }
}
