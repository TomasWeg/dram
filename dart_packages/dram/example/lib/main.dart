import 'package:dram/app.dart';
import 'package:example/app.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  await runApplication(App(), MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dram Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold()
    );
  }
}