import 'package:flutter/material.dart';

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

class IMCCalculator extends StatefulWidget {
  @override
  _IMCCalculatorState createState() => _IMCCalculatorState();
}

class _IMCCalculatorState extends State<IMCCalculator> {
  TextEditingController weightController = TextEditingController();
  TextEditingController heightController = TextEditingController();
  List<IMCResult> results = [];

  void calculateIMC() {
    double? weight = double.tryParse(weightController.text);
    double? height = double.tryParse(heightController.text);

    if (weight != null && height != null) {
      double imc = weight / (height * height);
      setState(() {
        results.add(IMCResult(weight: weight, height: height, imc: imc));
        weightController.clear();
        heightController.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Calculadora de IMC'),
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: weightController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Peso (kg)'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: heightController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Altura (m)'),
            ),
          ),
          ElevatedButton(
            onPressed: calculateIMC,
            child: const Text('Calcular IMC'),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: results.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text('Peso: ${results[index].weight} kg, Altura: ${results[index].height} m'),
                  subtitle: Text('IMC: ${results[index].imc.toStringAsFixed(2)}'),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class IMCResult {
  final double weight;
  final double height;
  final double imc;

  IMCResult({required this.weight, required this.height, required this.imc});
}

