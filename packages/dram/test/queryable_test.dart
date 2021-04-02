import 'package:dram/app.dart';
import 'package:dram/src/app/storage/repository/queryable/syntact_analysis.dart';
import 'package:test/test.dart';

void main() {
  test("Queryable is used to create provider queries", () {
    // var query = IQueryable.on<Player>()
    // .where("name").isEqualsTo("Tomás")
    // .where("age").isGreaterThanOrEqualsTo(18)
    // .or("age").isEqualsTo(20)
    // .where("points").isGreaterThanOrEqualsTo(20)
    // .orderBy("name").thenByDescending("age")
    // .single();

    var query = IQueryable.on<Player>()
    .where("points").isEqualsTo(20)
    .whereC((where) => where
      .where("age").isGreaterThanOrEqualsTo(18)
      .or("name").isEqualsTo("Tomas")
      .and("birthDate").isBetween(DateTime.now().subtract(Duration(days: 60)), DateTime.now().add(Duration(days: 60)))
      .whereC((sub) => sub.where("birthDate").isNotEqualsTo(DateTime.now()))
    )
    .limit(20);

    IQueryableSyntacticAnalyzer.instance.analyze(query);
  });
}

class Player {
  final String name;
  final int age;
  final double points;
  final DateTime birthDate;

  Player(this.name, this.age, this.points, this.birthDate);
}