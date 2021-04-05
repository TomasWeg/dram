part of 'queryable.dart';

abstract class IFilteredQueryable<T> extends IQueryable<T> {
  
  final IQueryable<T> _parent;

  IFilteredQueryable(this._parent) : super._empty() {
    _parent.copyTo(this);
  }
}

abstract class IPropertyFilteredQueryable<T> extends IFilteredQueryable<T> {

  bool _isNot = false; 
  IPropertyFilteredQueryable(IQueryable<T> parent, {String? fieldName}) : super(parent);

  IPropertyFilteredQueryable<T> not();
  IQueryable<T> isBetween(dynamic value1, dynamic value2);
  IQueryable<T> isEqualsTo(dynamic value);
  IQueryable<T> isNotEqualsTo(dynamic value);
  IQueryable<T> isGreaterThan(dynamic value);
  IQueryable<T> isGreaterThanOrEqualsTo(dynamic value);
  IQueryable<T> isLessThan(dynamic value);
  IQueryable<T> isLessThanOrEqualsTo(dynamic value);
  IQueryable<T> startsWith(dynamic value);
  IQueryable<T> endsWith(dynamic value);
  IQueryable<T> contains(dynamic value);
}

class _IPropertyFilteredQueryableImpl<T> extends IPropertyFilteredQueryable<T> {
  _IPropertyFilteredQueryableImpl(IQueryable<T> parent, {String? fieldName}) : super(parent, fieldName: fieldName);

  @override
  IQueryable<T> contains(dynamic value) {
    _parent._appendWhere(compareOperator: Operator.contains, isRequired: true, value: value, not: _isNot);
    return _parent;
  }

  @override
  IQueryable<T> endsWith(value) {
    _parent._appendWhere(compareOperator: Operator.endsWith, isRequired: true, value: value, not: _isNot);
    return _parent;
  }

  @override
  IQueryable<T> isBetween(value1, value2) {
    _parent._appendWhere(compareOperator: Operator.between, isRequired: true, value: [value1, value2], not: _isNot);
    return _parent;
  }

  @override
  IQueryable<T> isEqualsTo(value) {
    _parent._appendWhere(compareOperator: Operator.equal, isRequired: true, value: value, not: _isNot);
    return _parent;
  }

  @override
  IQueryable<T> isGreaterThan(value) {
    _parent._appendWhere(compareOperator: Operator.greaterThan, isRequired: true, value: value, not: _isNot);
    return _parent;
  }

  @override
  IQueryable<T> isGreaterThanOrEqualsTo(value) {
    _parent._appendWhere(compareOperator: Operator.greaterThanOrEqualsTo, isRequired: true, value: value, not: _isNot);
    return _parent;
  }

  @override
  IQueryable<T> isLessThan(value) {
    _parent._appendWhere(compareOperator: Operator.lessThan, isRequired: true, value: value, not: _isNot);
    return _parent;
  }

  @override
  IQueryable<T> isLessThanOrEqualsTo(value) {
    _parent._appendWhere(compareOperator: Operator.lessThanOrEqualsTo, isRequired: true, value: value, not: _isNot);
    return _parent;
  }

  @override
  IQueryable<T> isNotEqualsTo(value) {
    _parent._appendWhere(compareOperator: Operator.equal, isRequired: true, value: value, not: _isNot);
    return _parent;
  }

  @override
  IQueryable<T> startsWith(value) {
    _parent._appendWhere(compareOperator: Operator.startsWith, isRequired: true, value: value, not: _isNot);
    return _parent;
  }

  @override
  IPropertyFilteredQueryable<T> not() {
    _isNot = true;
    return this;
  }

}