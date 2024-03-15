import 'package:flutter/material.dart';
import 'package:hidden_gems_sg/screens/base_ui.dart';
import 'package:hidden_gems_sg/screens/home_ui.dart';
import 'package:hidden_gems_sg/theme/theme_constants.dart';
import 'package:hidden_gems_sg/screens/splash_ui.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: appTheme,
      initialRoute: '/',
      home: BaseScreen(),
    );
  }
}



