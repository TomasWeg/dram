import 'package:dram_queryable/src/model/where.dart';

extension OperatorExtension on Operator {
  static const Map<Operator, String> _values = {
    Operator.greaterThan: '>',
    Operator.greaterThanOrEqualsTo: '>=',
    Operator.lessThan: '<',
    Operator.lessThanOrEqualsTo: '<=',
    Operator.between: '<>',
    Operator.contains: '⊃',
    Operator.equal: '=',
    Operator.startsWith: 'a%',
    Operator.endsWith: '%a'
  };

  String getOperator() {
    return _values[this]!;
  }
}