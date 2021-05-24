part of 'queryable_model.dart';

void debugPrint(List<Expression> expressions) {
  for(var expression in expressions) {
    if(expression is Where) {
      print('Where on model: ${expression._queryableModel.runtimeType}');
      print('\tField: ${expression.fieldName}');
      print('\tCompareOperator: ${expression is Not ? expression.getLexicalName() : ''}${expression._compareOperator.value()}');
      print('\tValue: ${expression._value}');
      print('\tRequired: ${expression._required}');
    }
  }
}