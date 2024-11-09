import 'package:flutter/material.dart';
import 'package:hot_n_cold/home_page.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Hot N Cold',
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}
