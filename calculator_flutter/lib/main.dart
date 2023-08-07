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
      debugShowCheckedModeBanner: false, // Set this to false to remove the debug banner
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/', // Set the initial route to the Calculator screen
      routes: {
        '/': (context) => const Calculator(), // Route for the Calculator screen
        '/maths_library': (context) => const MathsLibrary(),
        '/practice_math': (context) => const PracticeMath(), // Route for the Maths Library screen
      },
    );
  }
}
