part of 'query_builder.dart';

abstract class BaseProperty {
  final String _fieldName;
  final List<BaseProperty>? _children;
  BaseProperty(this._fieldName, this._children);
  BaseProperty.empty() : _fieldName = '', _children = null;
}

abstract class BaseQueryProperty<DartType> extends BaseProperty {
  BaseQueryProperty(String fieldName) : super(fieldName, null);

  BaseWhere isEqualsTo(DartType other) {
    return Where(_fieldName, compareOperator: Operator.equal, isRequired: true, value: other);
  }

  BaseWhere isNotEqualsTo(DartType other) {
    return Not(Where(_fieldName, compareOperator: Operator.equal, isRequired: true, value: other));
  }
}

abstract class NumQueryProperty<NumType extends num> extends BaseQueryProperty<NumType> {
  NumQueryProperty(String fieldName) : super(fieldName);

  void isGreaterThan(NumType other) {
    Where(_fieldName, compareOperator: Operator.greaterThan, isRequired: true, value: other);
  }

  BaseWhere isGreaterThanOrEqualsTo(NumType other) {
    return Where(_fieldName, compareOperator: Operator.greaterThanOrEqualsTo, isRequired: true, value: other);
  }

  BaseWhere isLessThan(NumType other) {
    return Where(_fieldName, compareOperator: Operator.lessThan, isRequired: true, value: other);
  }

  BaseWhere isLessThanOrEqualsTo(NumType other) {
    return Where(_fieldName, compareOperator: Operator.lessThanOrEqualsTo, isRequired: true, value: other);
  }
}

class IntQueryProperty extends NumQueryProperty<int> {
  IntQueryProperty(String fieldName) : super(fieldName);
}

class DoubleQueryProperty extends NumQueryProperty<double> {
  DoubleQueryProperty(String fieldName) : super(fieldName);
}

class StringQueryProperty extends BaseQueryProperty<String> {
  StringQueryProperty(String fieldName) : super(fieldName);
}

class BoolQueryProperty extends BaseQueryProperty<bool> {
  BoolQueryProperty(String fieldName) : super(fieldName);
}

class ListQueryProperty<T> extends BaseQueryProperty<List<T>> {
  ListQueryProperty(String fieldName) : super(fieldName);

  BaseWhere contains(T item) {
    return Where(_fieldName, compareOperator: Operator.contains, isRequired: true, value: item);
  }
}