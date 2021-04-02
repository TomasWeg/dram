part of 'queryable.dart';

abstract class IFilteredQueryable<T> extends IQueryable<T> {
  final IQueryable<T> parent;
  final String fieldName;
  final bool isRequired;

  IFilteredQueryable(this.parent, this.fieldName, this.isRequired);

  IWhereQueryable<T> isBetween(dynamic value1, dynamic value2);
  IWhereQueryable<T> isEqualsTo(dynamic value);
  IWhereQueryable<T> isNotEqualsTo(dynamic value);
  IWhereQueryable<T> isGreaterThan(dynamic value);
  IWhereQueryable<T> isGreaterThanOrEqualsTo(dynamic value);
  IWhereQueryable<T> isLessThan(dynamic value);
  IWhereQueryable<T> isLessThanOrEqualsTo(dynamic value);
  IWhereQueryable<T> contains(dynamic value);
}

abstract class IComplexFilteredQueyable<T> extends IQueryable<T> {
  final IQueryable<T> parent;

  IComplexFilteredQueyable(this.parent);

  /// Starts a filter on a field name
  IFilteredQueryable<T> where(String fieldName);
  IFilteredQueryable<T> or(String fieldName);
  IFilteredQueryable<T> and(String fieldName);
}

class _IFilteredQueryable<T> extends IFilteredQueryable<T> {
  _IFilteredQueryable(IQueryable<T> parent, String fieldName, {bool isRequired = true}) : super(parent, fieldName, isRequired);

  IWhereQueryable<T> isBetween(dynamic value1, dynamic value2) {
    Where where = Where(this.fieldName, value: [value1, value2], compareOperator: Operator.between, isRequired: isRequired);
    this.parent._appendWhere(where);
    return _WhereQueryableImpl(parent);
  }

  IWhereQueryable<T> isEqualsTo(dynamic value) {
    Where where = Where(this.fieldName, value: value, compareOperator: Operator.equal, isRequired: isRequired);
    this.parent._appendWhere(where);
    return _WhereQueryableImpl(parent);
  }

  IWhereQueryable<T> isNotEqualsTo(dynamic value) {
    Where where = Where(this.fieldName, value: value, compareOperator: Operator.equal, isRequired: isRequired);
    this.parent._appendWhere(Not(where));
    return _WhereQueryableImpl(parent);
  }

  IWhereQueryable<T> isGreaterThan(dynamic value) {
    this.parent._appendWhere(Where(fieldName, compareOperator: Operator.greaterThan, value: value, isRequired: isRequired));
    return _WhereQueryableImpl(parent);
  }

  IWhereQueryable<T> isGreaterThanOrEqualsTo(dynamic value) {
    this.parent._appendWhere(Where(fieldName, compareOperator: Operator.greaterThanOrEqualTo, value: value, isRequired: isRequired));
    return _WhereQueryableImpl(parent);
  }

  IWhereQueryable<T> isLessThan(dynamic value) {
    this.parent._appendWhere(Where(fieldName, compareOperator: Operator.lessThan, value: value, isRequired: isRequired));
    return _WhereQueryableImpl(parent);
  }

  IWhereQueryable<T> isLessThanOrEqualsTo(dynamic value) {
    this.parent._appendWhere(Where(fieldName, compareOperator: Operator.lessThanOrEqualTo, value: value, isRequired: isRequired));
    return _WhereQueryableImpl(parent);
  }

  IWhereQueryable<T> contains(dynamic value) {
    this.parent._appendWhere(Where(fieldName, compareOperator: Operator.contains, value: value, isRequired: isRequired));
    return _WhereQueryableImpl(parent);
  }
}

class _IComplexFilteredQueryable<T> extends IComplexFilteredQueyable<T> {
  _IComplexFilteredQueryable(IQueryable<T> parent) : super(parent);

  @override
  IFilteredQueryable<T> where(String fieldName) {
    return _IFilteredQueryable(parent, fieldName, isRequired: true);
  }

  @override
  IFilteredQueryable<T> and(String fieldName) {
    return _IFilteredQueryable(parent, fieldName, isRequired: true);
  }

  @override
  IFilteredQueryable<T> or(String fieldName) {
    return _IFilteredQueryable(parent, fieldName, isRequired: false);
  }

}