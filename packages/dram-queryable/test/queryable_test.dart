import 'package:dram_queryable/dram_queryable.dart';
import 'package:test/test.dart';

void main() {

  test('IQueryable helps building generic queries that can be interpreted by any compiler.', () {
    IQueryable.on<Example>()
      .where('age').where(fieldName)
  });

}

class Example {
  final String name;
  final int age;
  final int points;
  final DateTime birthDate;
  final DateTime lastLogin;

  Example(this.name, this.age, this.points, this.birthDate, this.lastLogin);
}
