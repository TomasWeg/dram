part of 'query.dart';

class BooleanExpression<TDartType> extends Expression {
  
  final CompareOperator _operator;
  final TDartType _value;

  BooleanExpression({required String fieldName, required CompareOperator operator, required TDartType value}) : _operator = operator, _value = value, super(fieldName: fieldName);
  
  BooleanExpression<TDartType> copyWith({CompareOperator? operator, TDartType? value}) {
    return BooleanExpression(fieldName: _fieldName, operator: operator ?? _operator, value: value ?? _value);
  }
  
}