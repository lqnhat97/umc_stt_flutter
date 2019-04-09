import 'package:flutter/material.dart';
import 'package:flutter_app/Home/Home.dart';
import 'package:flutter_app/Login/Login.dart';
void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Login(),
    );
  }
}
