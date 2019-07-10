import 'package:flutter/material.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';

const request =
    "http://www.json-generator.com/api/json/get/bVvNDkBbVK?indent=2";
Color color = Color(0xFFF74E4F);
void main() {
  runApp(MaterialApp(
    home: Home(),
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
        hintColor: Colors.green, primaryColor: color, cursorColor: color),
  ));
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Future<Map> geData() async {
    http.Response response = await http.get(request);
    return json.decode(response.body);
  }

  double dolar;
  double euro;

  final solescontroller = TextEditingController();
  final dolarcontroller = TextEditingController();
  final eurocontroller = TextEditingController();

  void _soles(String text) {
    double soles = double.parse(text);
    dolarcontroller.text = (soles / dolar).toStringAsFixed(2);
    eurocontroller.text = (soles / euro).toStringAsFixed(2);
  }

  void _dolar(String text) {
    double dolar = double.parse(text);
    solescontroller.text = (dolar * this.dolar).toStringAsFixed(2);
    eurocontroller.text = (dolar * this.dolar / euro).toStringAsFixed(2);
  }

  void _euro(String text) {
    double euro = double.parse(text);
    solescontroller.text = (euro * this.euro).toStringAsFixed(2);
    dolarcontroller.text = (euro * this.euro / dolar).toStringAsFixed(2);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Currency Converter"),
        centerTitle: true,
      ),
      body: FutureBuilder<Map>(
          future: geData(),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
              case ConnectionState.waiting:
                return Center(
                  child: Text("Loading data...",
                      style: TextStyle(color: color, fontSize: 25.0),
                      textAlign: TextAlign.center),
                );
              default:
                if (snapshot.hasError) {
                  return Center(
                    child: Text("Error loading data",
                        style: TextStyle(color: Colors.green, fontSize: 25.0),
                        textAlign: TextAlign.center),
                  );
                } else {
                  dolar = snapshot.data["results"]["currencies"]["USD"]["buy"];
                  euro = snapshot.data["results"]["currencies"]["EUR"]["buy"];
                  return SingleChildScrollView(
                    padding: EdgeInsets.all(10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Icon(Icons.monetization_on, size: 150.0, color: color),
                        buildTextField(
                            "Soles", "PEN: ", solescontroller, _soles),
                        Divider(),
                        buildTextField(
                            "Dolares", "USD: ", dolarcontroller, _dolar),
                        Divider(),
                        buildTextField("Euros", "EUR: ", eurocontroller, _euro),
                      ],
                    ),
                  );
                }
            }
          }),
    );
  }
}

Widget buildTextField(String label, String prefix,
    TextEditingController control, Function funcion) {
  return TextField(
    controller: control,
    decoration: InputDecoration(
      fillColor: color,
      labelText: label,
      labelStyle: TextStyle(color: color),
      border: OutlineInputBorder(),
      prefixText: prefix,
    ),
    style: TextStyle(color: color, fontSize: 25.0),
    onChanged: funcion,
    keyboardType: TextInputType.number,
    textInputAction: TextInputAction.done,
  );
}
