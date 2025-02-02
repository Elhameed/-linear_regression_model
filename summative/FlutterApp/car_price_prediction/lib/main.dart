import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Car Price Predictor',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: CarPricePredictor(),
    );
  }
}

class CarPricePredictor extends StatefulWidget {
  @override
  _CarPricePredictorState createState() => _CarPricePredictorState();
}

class _CarPricePredictorState extends State<CarPricePredictor> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _yearController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  String _condition = 'Nigerian Used';
  double _mileage = 50000;
  double _engineSize = 2000;
  String _fuel = 'Petrol';
  String _transmission = 'Automatic';
  String _make = 'Toyota';
  String _build = 'SUV';
  String _predictedPrice = '';

  // Make logos and build images mapping
  final Map<String, String> _makeLogos = {
    'Toyota': 'assets/toyota_logo.png',
    'Honda': 'assets/honda_logo.png',
    'Lexus': 'assets/lexus_logo.png',
    'Mercedes-Benz': 'assets/mercedes_logo.png',
    'BMW': 'assets/bmw_logo.png',
  };

  final Map<String, String> _buildImages = {
    'SUV': 'assets/suv_image.png',
    'Sedan': 'assets/sedan_image.png',
    'Coupe': 'assets/coupe_image.png',
  };

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedDate)
      setState(() {
        _selectedDate = picked;
        _yearController.text = DateFormat('yyyy').format(picked);
      });
  }

  Future<void> _predictPrice() async {
    if (_formKey.currentState!.validate()) {
      final response = await http.post(
        Uri.parse('https://car-price-model.onrender.com/predict'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'Year_of_manufacture': int.parse(_yearController.text),
          'Condition': _condition,
          'Mileage': _mileage.toInt(),
          'Engine_Size': _engineSize.toInt(),
          'Fuel': _fuel,
          'Transmission': _transmission,
          'Make': _make,
          'Build': _build,
        }),
      );

      if (response.statusCode == 200) {
        setState(() {
          _predictedPrice = jsonDecode(response.body)['predicted_price'].toString();
        });
      } else {
        setState(() {
          _predictedPrice = 'Error: Unable to get prediction';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Car Price Predictor'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              Text('Car Details', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              SizedBox(height: 10),
              // Year of Manufacture (Date Picker and Text Input)
              ListTile(
                title: TextFormField(
                  controller: _yearController,
                  decoration: InputDecoration(labelText: "Year of Manufacture"),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter year of manufacture';
                    }
                    return null;
                  },
                ),
                trailing: IconButton(
                  icon: Icon(Icons.calendar_today),
                  onPressed: () => _selectDate(context),
                ),
              ),
              SizedBox(height: 10),
              // Condition Dropdown
              DropdownButtonFormField<String>(
                value: _condition,
                onChanged: (String? newValue) {
                  setState(() {
                    _condition = newValue!;
                  });
                },
                items: <String>['Nigerian Used', 'Foreign Used']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                decoration: InputDecoration(labelText: 'Condition'),
              ),
              SizedBox(height: 10),
              // Mileage Range Slider
              ListTile(
                title: Text('Mileage: ${_mileage.toInt()} km'),
                subtitle: Slider(
                  value: _mileage,
                  min: 0,
                  max: 500000,
                  divisions: 100,
                  label: _mileage.round().toString(),
                  onChanged: (double value) {
                    setState(() {
                      _mileage = value;
                    });
                  },
                ),
              ),
              SizedBox(height: 10),
              // Engine Size Range Slider
              ListTile(
                title: Text('Engine Size: ${_engineSize.toInt()} cc'),
                subtitle: Slider(
                  value: _engineSize,
                  min: 500,
                  max: 5000,
                  divisions: 100,
                  label: _engineSize.round().toString(),
                  onChanged: (double value) {
                    setState(() {
                      _engineSize = value;
                    });
                  },
                ),
              ),
              SizedBox(height: 20),
              Text('Additional Details', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              SizedBox(height: 10),
              // Fuel Dropdown
              DropdownButtonFormField<String>(
                value: _fuel,
                onChanged: (String? newValue) {
                  setState(() {
                    _fuel = newValue!;
                  });
                },
                items: <String>['Petrol', 'Diesel', 'Hybrid', 'Electric']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                decoration: InputDecoration(labelText: 'Fuel'),
              ),
              SizedBox(height: 10),
              // Transmission Dropdown
              DropdownButtonFormField<String>(
                value: _transmission,
                onChanged: (String? newValue) {
                  setState(() {
                    _transmission = newValue!;
                  });
                },
                items: <String>['Automatic', 'Manual']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                decoration: InputDecoration(labelText: 'Transmission'),
              ),
              SizedBox(height: 10),
              // Make Dropdown with Logos
              DropdownButtonFormField<String>(
                value: _make,
                onChanged: (String? newValue) {
                  setState(() {
                    _make = newValue!;
                  });
                },
                items: _makeLogos.keys.map<DropdownMenuItem<String>>((String key) {
                  return DropdownMenuItem<String>(
                    value: key,
                    child: Row(
                      children: [
                        Image.asset(
                          _makeLogos[key]!,
                          width: 36,
                          height: 36,
                        ),
                        SizedBox(width: 8),
                        Text(key),
                      ],
                    ),
                  );
                }).toList(),
                decoration: InputDecoration(labelText: 'Make'),
              ),
              SizedBox(height: 10),
              // Build Dropdown with Images
              DropdownButtonFormField<String>(
                value: _build,
                onChanged: (String? newValue) {
                  setState(() {
                    _build = newValue!;
                  });
                },
                items: _buildImages.keys.map<DropdownMenuItem<String>>((String key) {
                  return DropdownMenuItem<String>(
                    value: key,
                    child: Row(
                      children: [
                        Image.asset(
                          _buildImages[key]!,
                          width: 46,
                          height: 46,
                        ),
                        SizedBox(width: 8),
                        Text(key),
                      ],
                    ),
                  );
                }).toList(),
                decoration: InputDecoration(labelText: 'Build'),
              ),
              SizedBox(height: 20),
              // Predict Button
              ElevatedButton(
                onPressed: _predictPrice,
                child: Text('Predict'),
              ),
              SizedBox(height: 20),
              // Predicted Price Display
              Text(
                _predictedPrice.isNotEmpty ? 'Predicted Price: $_predictedPrice' : '',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
