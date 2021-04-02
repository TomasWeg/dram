import 'package:dram/app.dart';

extension CompareOperatorExtensions on Operator {
  static const Map<Operator, String> _operators = {
    Operator.equal: "==",
    Operator.greaterThan: ">",
    Operator.greaterThanOrEqualTo: ">=",
    Operator.lessThan: "<",
    Operator.lessThanOrEqualTo: "<=",
    Operator.between: "<>",
    Operator.contains: "⊃"
  };

  String getOperator() {
    return _operators[this]!;
  }
}