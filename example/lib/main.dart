import 'package:flutter/material.dart';
import 'package:tu_identidad/tu_identidad.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: RaisedButton(
            onPressed: () async => await TuIdentidad.ine("", TuIdentidad.INE),
            child: Text('Launch Doc'),
          ),
        ),
      ),
    );
  }
}
