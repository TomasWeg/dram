import 'package:dram/app.dart';
import 'package:flutter/material.dart';

import 'app/app.dart';

Future<void> main() async {
  await runApplication<App>(App(), AppEntry());
}

class AppEntry extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(),
    );
  }
}