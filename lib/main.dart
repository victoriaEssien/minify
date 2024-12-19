import 'package:flutter/material.dart';
import 'src/screens/home_screen.dart';

void main() {
  runApp(const CodeMinifierApp());
}

class CodeMinifierApp extends StatelessWidget {
  const CodeMinifierApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Code Minifier',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomeScreen(),
    );
  }
}
