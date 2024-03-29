import 'package:cross_math_puzzle/pages/game_page/game_page_view.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material App',
      theme: ThemeData(
        scrollbarTheme: const ScrollbarThemeData(
          thickness: MaterialStatePropertyAll(0),
        ),
      ),
      debugShowCheckedModeBanner: false,
      home: const GamePage(),
    );
  }
}
