import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Car Price Prediction',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController yearController = TextEditingController();
  final TextEditingController mileageController = TextEditingController();
  final TextEditingController engineSizeController = TextEditingController();
  final TextEditingController makeController = TextEditingController();
  final TextEditingController conditionController = TextEditingController();
  final TextEditingController fuelController = TextEditingController();
  final TextEditingController transmissionController = TextEditingController();
  final TextEditingController buildController = TextEditingController();

  String prediction = '';
  bool isLoading = false;

  Future<void> predictPrice() async {
    setState(() {
      isLoading = true;
    });

    final response = await http.post(
      Uri.parse('http://your_api_url/predict'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'year_of_manufacture': int.parse(yearController.text),
        'mileage': double.parse(mileageController.text),
        'engine_size': double.parse(engineSizeController.text),
        'make': makeController.text,
        'condition': conditionController.text,
        'fuel': fuelController.text,
        'transmission': transmissionController.text,
        'build': buildController.text,
      }),
    );

    if (response.statusCode == 200) {
      setState(() {
        prediction = jsonDecode(response.body)['predicted_price'].toString();
        isLoading = false;
      });
    } else {
      setState(() {
        prediction = 'Error: Unable to get prediction.';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Car Price Prediction'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: yearController,
              decoration: InputDecoration(labelText: 'Year of Manufacture'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: mileageController,
              decoration: InputDecoration(labelText: 'Mileage'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: engineSizeController,
              decoration: InputDecoration(labelText: 'Engine Size'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: makeController,
              decoration: InputDecoration(labelText: 'Make'),
            ),
            TextField(
              controller: conditionController,
              decoration: InputDecoration(labelText: 'Condition'),
            ),
            TextField(
              controller: fuelController,
              decoration: InputDecoration(labelText: 'Fuel'),
            ),
            TextField(
              controller: transmissionController,
              decoration: InputDecoration(labelText: 'Transmission'),
            ),
            TextField(
              controller: buildController,
              decoration: InputDecoration(labelText: 'Build'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: isLoading ? null : predictPrice,
              child: isLoading ? CircularProgressIndicator() : Text('Predict'),
            ),
            SizedBox(height: 20),
            Text(
              prediction.isEmpty ? 'Enter details to get prediction' : 'Predicted Price: $prediction',
              style: TextStyle(fontSize: 20),
            ),
          ],
        ),
      ),
    );
  }
}
