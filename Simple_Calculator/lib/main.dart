import 'package:flutter/material.dart';
import 'package:scientific_calculator_flutter/screens/simple_calculator.dart';

void main() => runApp(Calculator());

class Calculator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Calculator",
      debugShowCheckedModeBanner: false,
      home: SimpleCalculator(),
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
    );
  }
}
