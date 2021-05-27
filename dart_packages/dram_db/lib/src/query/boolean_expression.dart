part of 'query.dart';

class BooleanExpression<TDartType> extends Expression {
  
  final CompareOperator _operator;
  final TDartType _value;
  final bool _required;
  final List<BooleanExpression> _children;
  final BooleanExpression? _parent;

  BooleanExpression({required String fieldName, required CompareOperator operator, required TDartType value, Iterable<BooleanExpression>? children, bool required = true, BooleanExpression? parent}) 
    : _required = required, 
      _children = children != null ? List.from(children) : [], 
      _operator = operator, 
      _parent = parent,
      _value = value, 
      super(fieldName: fieldName);
  
  BooleanExpression<TDartType> copyWith({CompareOperator? operator, TDartType? value, bool? isRequired, BooleanExpression? parent, List<BooleanExpression>? children}) {
    return BooleanExpression(fieldName: _fieldName!, operator: operator ?? _operator, value: value ?? _value, required: isRequired ?? _required, parent: parent ?? _parent, children: children ?? _children);
  }

  /// Concats an AND expression
  AndExpression and<DartType>(Expression expression) {
    if(expression is BooleanExpression) {
      _children.add(expression.copyWith(parent: this));
    }
    return AndExpression(this, expression);
  }

  OrExpression or<DartType>(Expression expression) {
    if(expression is BooleanExpression) {
      _children.add(expression.copyWith(isRequired: false, parent: this));
    }
    return OrExpression(this, expression);
  }
}