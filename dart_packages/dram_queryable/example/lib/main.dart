import 'package:example/user.g.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());


  var database = MyDatabase();
  var model = database.select((model) => model.users);
  model.where((queryable) => queryable.name.isEqualsTo("tomas"));
  model.whereM((queryable) => [
    queryable.name.isEqualsTo("test"),
  ]);

}


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: Scaffold(),
    );
  }
}