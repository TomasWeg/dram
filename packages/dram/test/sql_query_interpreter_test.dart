import 'package:dram/app.dart';
import 'package:dram/logger.dart';
import 'package:dram/src/app/storage/adapter/model_adapter_provider.dart';
import 'package:dram/src/app/storage/queryable/sql_query_interpreter.dart';
import 'package:dram_queryable/dram_queryable.dart';
import 'package:test/test.dart';

void main() {
  setUp(() {
    Logger();
  });

  test("SqlQueryInterpreter parses a query to a valid SQL statement.", () {
    // Mock a QueryDetails
    var query = IQueryable.on<Example>().where("name").contains("a")
    .or((sub) => sub.where("age").isGreaterThanOrEqualsTo(18).where("points").isBetween(10, 100));
    
    var queryDetails = QueryParser.parse(query);
    var interpreter = SqlQueryInterpreter();
    DefaultModelAdapterProvider({
      Example: ExampleAdapter()
    });
    var sql = interpreter.generateSql<Example>(queryDetails);
    print("GENERATED SQL: ${sql.first}");
    print("VALUES: ${sql.second}");
  });
}

class Example {
  final String name;
  final int age;
  final double points;

  const Example(this.name, this.age, this.points);
}

class ExampleAdapter extends ModelAdapter<Example> {
  @override
  String get collectionName => "example";

  @override
  Example fromProvider(data) {
    throw UnimplementedError();
  }

  @override
  toProvider(Example model) {
    throw UnimplementedError();
  }

}