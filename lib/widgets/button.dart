import 'package:fishspot_app/constants/colors_constants.dart';
import 'package:flutter/material.dart';

class Button extends StatefulWidget {
  final String label;
  final Icon? icon;
  final Size? fixedSize;
  final void Function()? onPressed;
  final bool loading;
  final Color? backgroundColor;
  final Color? textColor;

  const Button({
    super.key,
    required this.label,
    required this.onPressed,
    this.fixedSize,
    this.icon,
    this.loading = false,
    this.backgroundColor,
    this.textColor,
  });

  @override
  State<Button> createState() => _ButtonState();
}

class _ButtonState extends State<Button> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      child: _child(),
      onPressed: widget.loading ? null : widget.onPressed,
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.only(left: 16, right: 16),
        fixedSize: widget.fixedSize,
        backgroundColor: widget.backgroundColor ??
            Theme.of(context).buttonTheme.colorScheme?.primary,
        overlayColor: Theme.of(context).buttonTheme.colorScheme?.onPrimary,
        disabledBackgroundColor: ColorsConstants.gray100,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
      ),
    );
  }

  _child() {
    if (widget.loading) {
      return CircularProgressIndicator(
        color: Theme.of(context).textTheme.labelMedium?.color,
      );
    }

    if (widget.label.isEmpty) {
      return widget.icon;
    }

    return Text(
      widget.label,
      style: TextStyle(
        fontSize: Theme.of(context).textTheme.labelMedium?.fontSize,
        fontWeight: Theme.of(context).textTheme.labelMedium?.fontWeight,
        color:
            widget.textColor ?? Theme.of(context).textTheme.labelMedium?.color,
      ),
    );
  }
}
