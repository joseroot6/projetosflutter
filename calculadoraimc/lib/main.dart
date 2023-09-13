import 'package:flutter/material.dart';

import 'imc_calculator.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calculadora de IMC',
      home: IMCCalculator(),
    );
  }
}

