import 'package:flutter/material.dart';

class LoadingPage extends StatelessWidget {
  final String? message;

  const LoadingPage({
    super.key,
    this.message,
  });

  @override
  Widget build(BuildContext context) {
    Text text = Text('');

    if (message != null) {
      text = Text(
        message!,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Theme.of(context).textTheme.headlineLarge?.color,
          fontSize: 14,
          fontWeight: FontWeight.w400,
        ),
      );
    }

    return Scaffold(
      body: Container(
        color: Theme.of(context).colorScheme.surface,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(
                color: Theme.of(context).textTheme.headlineLarge?.color,
              ),
              SizedBox(height: 20),
              Container(child: text)
            ],
          ),
        ),
      ),
    );
  }
}
