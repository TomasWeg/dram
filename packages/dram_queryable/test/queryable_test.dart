import 'package:dram_queryable/dram_queryable.dart';
import 'package:test/test.dart';

void main() {

  group('IQueryable helps building generic queries that can be interpreted by any compiler.', () {

    test('Simple AND query', () {
      var query = IQueryable.on<Example>()
        .where('age').isGreaterThan(20)
        .where('birthDate').not().isBetween(DateTime.now().subtract(Duration(days: 365 * 6)), DateTime.now())
        .where('points').isLessThan(200);

      // This will produce: age > 20 && (birthDate > [firstDate] && birthDate < [secondDate]) && points < 20;
      QueryParser.parse(query).debugPrint();
    });

    test('Simple AND with OR query', () {
      var query = IQueryable.on<Example>()
        .where('age').isGreaterThanOrEqualsTo(18)
        .or((sub) => sub.where('points').isGreaterThan(60))
        .where('name').isEqualsTo('John');

      // This will produce: (age >= 20 || points > 60) && name == 'John'
      // Automatically inserts the OR operator between the property and the previous one, making both non required.
      
      QueryParser.parse(query).debugPrint();
    });

    test('Complex AND with OR query', () {
      var query = IQueryable.on<Example>()
        .where('age').isGreaterThanOrEqualsTo(18)
        .or((query) => query
          .where('points').isGreaterThanOrEqualsTo(1000)
          .where('age').isGreaterThan(18)
          .or((subQuery) => subQuery
            .where('birhtDate').isEqualsTo(DateTime.now())
          )
        );

      QueryParser.parse(query).debugPrint();
      
    });

    test('Simple sub query', () {
      var query = IQueryable.on<Example>()
        .where('age').isGreaterThanOrEqualsTo(18)
        .or((query) => query
          .where('points').isGreaterThan(60)
          .or((sub) => sub.where('name').isEqualsTo('Tomas'))
        );

      // This should output the same as "Simple AND with OR query"
      QueryParser.parse(query).debugPrint();
    });

  });

}

class Example {
  final String name;
  final int age;
  final int points;
  final DateTime birthDate;
  final DateTime lastLogin;

  Example(this.name, this.age, this.points, this.birthDate, this.lastLogin);

  void test() {
    print(age >= 20 || points > 60 && name == 'John');
  }
}
