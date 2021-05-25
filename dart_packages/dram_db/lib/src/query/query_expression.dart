part of 'query.dart';

class QueryExpression<TDartType> extends Expression<TDartType> {
  
  QueryExpression({required String fieldName, required CompareOperator operator, required TDartType value}) : super(fieldName: fieldName, operator: operator, value: value);
  
  @override
  Expression<TDartType> copyWith({CompareOperator? operator, TDartType? value}) {
    throw UnimplementedError();
  }
  
}