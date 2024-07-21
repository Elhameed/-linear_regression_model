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
  final _formKey = GlobalKey<FormState>();
  final _yearController = TextEditingController();
  final _conditionController = TextEditingController();
  final _mileageController = TextEditingController();
  final _engineSizeController = TextEditingController();
  final _fuelController = TextEditingController();
  final _transmissionController = TextEditingController();
  final _makeController = TextEditingController();
  final _buildController = TextEditingController();

  String _predictedPrice = '';

  Future<void> _predictPrice() async {
    if (_formKey.currentState!.validate()) {
      final response = await http.post(
        Uri.parse('https://car-price-model.onrender.com/predict'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'Year_of_manufacture': int.parse(_yearController.text),
          'Condition': _conditionController.text,
          'Mileage': int.parse(_mileageController.text),
          'Engine_Size': int.parse(_engineSizeController.text),
          'Fuel': _fuelController.text,
          'Transmission': _transmissionController.text,
          'Make': _makeController.text,
          'Build': _buildController.text,
        }),
      );

      if (response.statusCode == 200) {
        setState(() {
          _predictedPrice = jsonDecode(response.body)['predicted_price'].toString();
        });
      } else {
        setState(() {
          _predictedPrice = 'Error: Unable to fetch prediction';
        });
      }
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
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              TextFormField(
                controller: _yearController,
                decoration: InputDecoration(labelText: 'Year of Manufacture'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the year of manufacture';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _conditionController,
                decoration: InputDecoration(labelText: 'Condition'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the condition';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _mileageController,
                decoration: InputDecoration(labelText: 'Mileage'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the mileage';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _engineSizeController,
                decoration: InputDecoration(labelText: 'Engine Size'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the engine size';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _fuelController,
                decoration: InputDecoration(labelText: 'Fuel'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the fuel type';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _transmissionController,
                decoration: InputDecoration(labelText: 'Transmission'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the transmission type';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _makeController,
                decoration: InputDecoration(labelText: 'Make'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the make';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _buildController,
                decoration: InputDecoration(labelText: 'Build'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the build type';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _predictPrice,
                child: Text('Predict'),
              ),
              SizedBox(height: 20),
              Text(
                'Predicted Price: $_predictedPrice',
                style: TextStyle(fontSize: 20),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
