part of 'query.dart';

/// Represents a boolean expression
/// [TDartType] is the Dart native type used in the expression
class Expression<TDartType> {

  final String _fieldName;
  final CompareOperator _operator;
  final TDartType _value;

  const Expression({required String fieldName, required CompareOperator operator, required TDartType value}) : _fieldName = fieldName, _operator = operator, _value = value;

  Expression<TDartType> copyWith({CompareOperator? operator, TDartType? value}) {
    return Expression<TDartType>(
      fieldName: _fieldName,
      operator: operator ?? _operator,
      value: value ?? _value
    );
  }
}

enum CompareOperator {
  equal, greaterThan, greaterThanOrEqualsTo, lessThan, lessThanOrEqualsTo, includes
}