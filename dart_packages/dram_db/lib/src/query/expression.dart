part of 'query.dart';

/// Represents a boolean expression
/// [TDartType] is the Dart native type used in the expression
abstract class Expression {

  final String _fieldName;

  const Expression({required String fieldName}) : _fieldName = fieldName;
}

enum CompareOperator {
  equal, notEqual, greaterThan, greaterThanOrEqualsTo, lessThan, lessThanOrEqualsTo, includes, excludes
}