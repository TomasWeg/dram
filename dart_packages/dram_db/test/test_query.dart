import 'package:drambase/src/query/query.dart';
import 'package:test/scaffolding.dart';

import 'database.g.dart';

late AppDatabase _db;

void main() {
  setUp(() {
    _db = AppDatabase();
  });

  group('AppDatabase query', () {
    
    test('Simple query', () {

      // Evaluation and execution: WHERE age >= 20

      var query = _db
        .select((database) => database.users)
        .where((table) => table.age.isGreaterThanOrEqualsTo(20))
        .orderBy((table) => table.age)
        .paginate(1, 30);

      var sql = toSql(query);
      print('SQL: $sql');
    });

    test('Simple AND query', () {

      // Evaluation and execution: WHERE age >= 20 AND points < 200 AND lastName = 'Bohil'
      var query = _db
        .select((database) => database.users)
        .where((table) => 
          table.age.isGreaterThanOrEqualsTo(20)
          .and(table.points.isLessThan(200))
          .and(table.lastName.isEqualsTo('Bohil')));

      var sql = toSql(query);
      print('SQL: $sql');
    });

    test('Simple OR query', () {
      // Evaluation and evaluation: WHERE age = 20 OR name != 'Tomas'
      
      var query = _db
        .select((database) => database.users)
        .where((table) => table.age.isEqualsTo(20).or(table.name.isNotEqualsTo('Tomas')));

      debugPrint(query);
      var sql = toSql(query);
      print('SQL: $sql');
    });
    
    test('Complex AND with OR query #1', () {
      // Evaluation: WHERE age = 20 AND name != 'Tomas' OR points >= 255.50
      // Execution plan: WHERE age = 20 AND (name != 'Tomas' OR points >= 255.50)
      
      var query = _db
        .select((database) => database.users)
        .where((table) => 
          table.age.isEqualsTo(20)
          .and(table.name.isNotEqualsTo('Tomas').or(table.points.isGreaterThanOrEqualsTo(255.50))));
      var sql = toSql(query);
      print('SQL: $sql');
    });

    test('Complex AND with OR query #2', () {
      // Evaluation: WHERE age = 20 AND name != 'Tomas' OR points >= 255.50 OR lastName = 'Monserrat'
      // Execution plan: WHERE age = 20 AND (name != 'Tomas' OR points >= 255.50 OR lastName = 'Monserrat')
      
      var query = _db
        .select((database) => database.users)
        .where((table) => 
          table.age.isEqualsTo(20)
          .and(table.name.isNotEqualsTo('Tomas')
            .or(table.points.isGreaterThanOrEqualsTo(255.50))
            .or(table.lastName.isEqualsTo('Monserrat'))));
      var sql = toSql(query);
      print('SQL: $sql');
    });

    test('Complex AND with OR query with sublevels', () {
      // Evaluation: WHERE name = 'Tomas' OR age > 18 AND points < 200
      // Execution plan: WHERE name = 'Tomas' OR (age > 18 AND points < 200 AND phoneNumber.prefix = '+54')
      
      var query = _db
        .select((database) => database.users)
        .where((table) => 
          table.name
          .isEqualsTo('Tomas')
          .or(table.age
            .isGreaterThan(18)
            .and(table.points.isLessThan(200))
            .and(table.phoneNumber.prefix.isEqualsTo('+54')))
        );

      var sql = toSql(query);
      print('SQL: $sql');
    });
  });
}