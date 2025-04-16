import 'package:fishspot_app/constants/colors_constants.dart';
import 'package:flutter/material.dart';

class CustomButton extends StatefulWidget {
  final String label;
  final Size? fixedSize;
  final void Function()? onPressed;
  final bool loading;

  const CustomButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.fixedSize,
    this.loading = false,
  });

  @override
  State<CustomButton> createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: widget.loading ? null : widget.onPressed,
      style: ElevatedButton.styleFrom(
        fixedSize: widget.fixedSize,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        backgroundColor: Theme.of(context).buttonTheme.colorScheme?.primary,
        overlayColor: Theme.of(context).buttonTheme.colorScheme?.onPrimary,
        disabledBackgroundColor: ColorsConstants.gray100,
      ),
      child: _renderButtonChild(),
    );
  }

  _renderButtonChild() {
    if (widget.loading) {
      return CircularProgressIndicator(
        color: Theme.of(context).textTheme.labelMedium?.color,
      );
    }

    return Text(
      widget.label,
      style: Theme.of(context).textTheme.labelMedium,
    );
  }
}
