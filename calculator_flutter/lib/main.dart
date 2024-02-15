import 'package:flutter/material.dart';
import 'calculator.dart';
import 'maths_library.dart';
import 'practice_math.dart';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cool Calculator APP',
      debugShowCheckedModeBanner: false, 
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/', 
      routes: {
        '/': (context) => const Calculator(),
        '/maths_library': (context) => const MathsLibrary(),
        '/practice_math': (context) => const PracticeMath(), 
      },
    );
  }
}
