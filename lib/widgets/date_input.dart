import 'package:fishspot_app/widgets/text_input.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateInput extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final String? Function(String?)? validator;

  const DateInput({
    super.key,
    required this.controller,
    this.validator,
    required this.label,
  });

  @override
  State<DateInput> createState() => _DateInputState();
}

class _DateInputState extends State<DateInput> {
  _handleDatePicker() async {
    DateTime? date = await showDatePicker(
      builder: (context, child) {
        return _theme(context, child);
      },
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (date != null) {
      setState(() {
        widget.controller.text = DateFormat("dd/MM/yyyy").format(date);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextInput(
      controller: widget.controller,
      validator: widget.validator,
      readonly: true,
      label: widget.label,
      textInputType: TextInputType.datetime,
      icon: Icons.date_range,
      onTap: _handleDatePicker,
    );
  }

  Theme _theme(BuildContext context, Widget? child) {
    var onPrimary = Theme.of(context).textTheme.labelMedium?.color;
    var onSurface = Theme.of(context).textTheme.headlineLarge?.color;

    return Theme(
      data: Theme.of(context).copyWith(
        colorScheme: ColorScheme.light(
          primary: Theme.of(context).colorScheme.primary,
          onPrimary: onPrimary ?? Colors.black,
          onSurface: onSurface ?? Colors.black,
        ),
      ),
      child: child!,
    );
  }
}
