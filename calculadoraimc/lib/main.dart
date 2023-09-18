import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'model/imc_model.dart';

void main() async {
  await Hive.initFlutter();
  await Hive.openBox<IMCModel>('imcBox');
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: IMCCalculatorScreen(),
    );
  }
}

class IMCCalculatorScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('IMC Calculator')),
      body: IMCList(),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => AddIMCScreen()),
        ),
        child: Icon(Icons.add),
      ),
    );
  }
}

class IMCList extends StatelessWidget {
  const IMCList({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: Hive.box<IMCModel>('imcBox').listenable(),
      builder: (context, Box<IMCModel> box, _) {
        return ListView.builder(
          itemCount: box.length,
          itemBuilder: (context, index) {
            final imc = box.getAt(index);
            return ListTile(
              title: Text('${imc?.name} - IMC: ${imc?.calculateIMC().toStringAsFixed(2)}'),
              trailing: IconButton(
                icon: Icon(Icons.delete),
                onPressed: () {
                  box.deleteAt(index);
                },
              ),
            );
          },
        );
      },
    );
  }
}

class AddIMCScreen extends StatelessWidget {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController heightController = TextEditingController();
  final TextEditingController weightController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Adicionar IMC')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: 'Nome'),
            ),
            TextField(
              controller: heightController,
              decoration: InputDecoration(labelText: 'Altura (m)'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: weightController,
              decoration: InputDecoration(labelText: 'Peso (kg)'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                final name = nameController.text;
                final height = double.tryParse(heightController.text) ?? 0.0;
                final weight = double.tryParse(weightController.text) ?? 0.0;

                if (name.isNotEmpty && height > 0 && weight > 0) {
                  final imcModel = IMCModel(name, height, weight);
                  Hive.box<IMCModel>('imcBox').add(imcModel);
                  Navigator.pop(context);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Preencha todos os campos corretamente.')),
                  );
                }
              },
              child: Text('Adicionar'),
            ),
          ],
        ),
      ),
    );
  }
}
