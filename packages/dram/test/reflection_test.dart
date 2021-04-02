import 'package:test/test.dart';

void main() {
  test("Reflection test", () {
    // initializeReflectable();
    // var builder = QueryBuilder<Example>.create().where((element) => element.age == 20);
    // var query = builder.build();
    // var interpreter = QueryInterpreter<Example>(query: query);
    // interpreter.interpret();
  }); 
}

class Example {
  final String text;
  final int age;

  Example(this.text, this.age);
}