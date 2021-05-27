import 'package:drambase/src/query/query.dart';

abstract class BinaryExpression extends Expression {
  final Expression left, right;

  String get sqlName;

  const BinaryExpression(this.left, this.right) : super(fieldName: null);

  AndExpression and<DartType>(BooleanExpression<DartType> expression) {
    return AndExpression(this, expression);
  }

  OrExpression or<DartType>(BooleanExpression<DartType> expression) {
    return OrExpression(this, expression);
  }
}

class AndExpression extends BinaryExpression {
  const AndExpression(Expression left, Expression right) : super(left, right);

  @override
  String get sqlName => ' AND ';
}

class OrExpression extends BinaryExpression {
  const OrExpression(Expression left, Expression right) : super(left, right);

  @override
  String get sqlName => ' OR ';
}