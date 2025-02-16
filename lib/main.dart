import 'package:fishspot_app/pages/login_page.dart';
import 'package:fishspot_app/theme/dark_theme.dart';
import 'package:fishspot_app/theme/light_theme.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FishSpot',
      debugShowCheckedModeBanner: false,
      theme: lighMode,
      darkTheme: darkMode,
      home: LoginPage(),
    );
  }
}
