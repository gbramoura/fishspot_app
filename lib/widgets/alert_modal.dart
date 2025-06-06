import 'package:fishspot_app/enums/custom_dialog_alert_type.dart';
import 'package:flutter/material.dart';

class AlertModal extends StatelessWidget {
  final Widget button;
  final CustomDialogAlertType type;
  final String title;
  final String message;

  const AlertModal({
    super.key,
    required this.button,
    required this.type,
    required this.title,
    required this.message,
  });

  _image() {
    switch (type) {
      case CustomDialogAlertType.success:
        return AssetImage('assets/icons-success-150.png');
      case CustomDialogAlertType.error:
        return AssetImage('assets/icons-error-150.png');
      case CustomDialogAlertType.warn:
        return AssetImage('assets/icons-warn-100.png');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Theme.of(context).colorScheme.surface,
      child: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              SizedBox(height: 45),
              Image(
                height: 150,
                width: 150,
                image: _image(),
              ),
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(19, 0, 19, 0),
                child: Text(
                  title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Theme.of(context).textTheme.titleLarge?.color,
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(19, 0, 19, 0),
                child: Text(
                  message,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Theme.of(context).textTheme.titleLarge?.color,
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              button,
              SizedBox(
                height: 30,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
