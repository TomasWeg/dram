part of 'queryable_model.dart';

class Where<TModel, TQueryable extends QueryableModel<TModel>> extends Expression {
  final dynamic _value;
  final CompareOperator _compareOperator;
  final bool _required;
  final TQueryable _queryableModel;

  const Where(String fieldName, {dynamic value, CompareOperator operator = CompareOperator.equal, bool isRequired = true, required TQueryable queryableModel}) 
    : _value = value, _compareOperator = operator, _required = isRequired, _queryableModel = queryableModel, super(fieldName);

  Where<TModel, TQueryable> copyWith({dynamic value, CompareOperator? compareOperator, bool? isRequired}) {
    return Where(fieldName!, 
      isRequired: isRequired ?? _required,
      operator: compareOperator ?? _compareOperator,
      value: value ?? _value,
      queryableModel: _queryableModel
    );
  }

  TQueryable and() {
    _queryableModel._nextRequired = true;
    return _queryableModel;
  }

  TQueryable or() {
    _queryableModel._nextRequired = false;
    return _queryableModel;
  }

}

class Not<TModel, TQueryable extends QueryableModel<TModel>> extends Where<TModel, TQueryable> {
  final Where<TModel, TQueryable> child;

  Not(this.child) : super(child.fieldName!, operator: child._compareOperator, isRequired: child._required, value: child._value, queryableModel: child._queryableModel);

  String getLexicalName() {
    if(child._compareOperator == CompareOperator.equal) {
      return '!';
    } else {
      return 'NOT';
    }
  }
}

enum CompareOperator {
  equal, greaterThan, greaterThanOrEquals, lessThan, lessThanOrEquals, includes
}

extension CompareOperatorExtensions on CompareOperator {
  static const Map<CompareOperator, String> _keys = {
    CompareOperator.equal: '=',
    CompareOperator.greaterThan: '>',
    CompareOperator.greaterThanOrEquals: '>=',
    CompareOperator.lessThanOrEquals: '<=',
    CompareOperator.lessThan: '<',
    CompareOperator.includes: 'IN',
  };

  String value() => _keys[this]!;
}