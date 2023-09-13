import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class IMCCalculator extends StatefulWidget {
  @override
  _IMCCalculatorState createState() => _IMCCalculatorState();
}

class _IMCCalculatorState extends State<IMCCalculator> {
  TextEditingController weightController = TextEditingController();
  TextEditingController heightController = TextEditingController();
  List<IMCResult> results = [];

  @override
  void initState() {
    super.initState();
    loadIMCList();
  }

  void calculateIMC() {
    double? weight = double.tryParse(weightController.text);
    double height = double.tryParse(heightController.text)! / 100;

    if (weight != null) {
      double imc = weight / (height * height);
      setState(() {
        results.add(IMCResult(weight: weight, height: height, imc: imc)); 
        saveIMCList();
      });

      weightController.clear();
      heightController.clear();
    }
  }

  void saveIMCList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // Converte a lista de objetos IMCResult para uma lista de strings JSON
    List<String> jsonList = results.map((result) => jsonEncode(result.toJson())).toList();
    prefs.setStringList('imcList', jsonList);
  }

  void loadIMCList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? jsonList = prefs.getStringList('imcList');
    if (jsonList != null) {
      // Converte as strings JSON de volta para objetos IMCResult
      setState(() {
        results = jsonList.map((json) => IMCResult.fromJson(jsonDecode(json))).toList();
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
        children: [
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextField(
                  controller: weightController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(labelText: 'Peso (kg)'),
                ),
                TextField(
                  controller: heightController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(labelText: 'Altura (cm)'),
                ),
                SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: calculateIMC,
                  child: Text('Calcular IMC'),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: results.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text('IMC: ${results[index].imc.toStringAsFixed(2)}'),
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

  // Adicione os métodos toJson e fromJson para serialização
  Map<String, dynamic> toJson() {
    return {
      'weight': weight,
      'height': height,
      'imc': imc,
    };
  }

  factory IMCResult.fromJson(Map<String, dynamic> json) {
    return IMCResult(
      weight: json['weight'],
      height: json['height'],
      imc: json['imc'],
    );
  }
}
