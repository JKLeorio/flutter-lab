import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:weather_forecast/page.dart';

import 'package:weather_forecast/models.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    try {
      getReport();
    }
    catch(e) {
      Fluttertoast.showToast(msg: e.toString());
    }
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(body: WeatherHomePage()),
    );
  }
}
