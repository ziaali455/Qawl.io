import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import './homepage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Qawl',
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.dark,
      darkTheme: FlexThemeData.dark(
        scheme: FlexScheme.hippieBlue,
        darkIsTrueBlack: true,
      ),
      home: HomePage(),
    );
  }
}
