part of 'queryable.dart';

abstract class IFilteredQueryable<T> extends IQueryable<T> {
  
  final IQueryable<T> _parent;

  IFilteredQueryable(this._parent) : super._empty() {
    _parent.copyTo(this);
  }
}

abstract class IPropertyFilteredQueryable<T> extends IFilteredQueryable<T> {

  final String _fieldName;
  IPropertyFilteredQueryable(IQueryable<T> parent, this._fieldName) : super(parent);

  IPropertyFilteredQueryable<T> isBetween(dynamic value1, dynamic value2);
  IPropertyFilteredQueryable<T> isEqualsTo(dynamic value);
  IPropertyFilteredQueryable<T> isNotEqualsTo(dynamic value);
  IPropertyFilteredQueryable<T> isGreaterThan(dynamic value);
  IPropertyFilteredQueryable<T> isGreaterThanOrEqualsTo(dynamic value);
  IPropertyFilteredQueryable<T> isLessThan(dynamic value);
  IPropertyFilteredQueryable<T> isLessThanOrEqualsTo(dynamic value);
  IPropertyFilteredQueryable<T> startsWith(dynamic value);
  IPropertyFilteredQueryable<T> endsWith(dynamic value);
  IPropertyFilteredQueryable<T> contains(dynamic value);
}

class _IPropertyFilteredQueryableImpl<T> extends IPropertyFilteredQueryable<T> {
  _IPropertyFilteredQueryableImpl(IQueryable<T> parent, String fieldName) : super(parent, fieldName);


  @override
  IPropertyFilteredQueryable<T> contains(value) {
    // TODO: implement contains
    throw UnimplementedError();
  }

  @override
  IPropertyFilteredQueryable<T> endsWith(value) {
    // TODO: implement endsWith
    throw UnimplementedError();
  }

  @override
  IPropertyFilteredQueryable<T> isBetween(value1, value2) {
    // TODO: implement isBetween
    throw UnimplementedError();
  }

  @override
  IPropertyFilteredQueryable<T> isEqualsTo(value) {
    // TODO: implement isEqualsTo
    throw UnimplementedError();
  }

  @override
  IPropertyFilteredQueryable<T> isGreaterThan(value) {
    // TODO: implement isGreaterThan
    throw UnimplementedError();
  }

  @override
  IPropertyFilteredQueryable<T> isGreaterThanOrEqualsTo(value) {
    // TODO: implement isGreaterThanOrEqualsTo
    throw UnimplementedError();
  }

  @override
  IPropertyFilteredQueryable<T> isLessThan(value) {
    // TODO: implement isLessThan
    throw UnimplementedError();
  }

  @override
  IPropertyFilteredQueryable<T> isLessThanOrEqualsTo(value) {
    // TODO: implement isLessThanOrEqualsTo
    throw UnimplementedError();
  }

  @override
  IPropertyFilteredQueryable<T> isNotEqualsTo(value) {
    // TODO: implement isNotEqualsTo
    throw UnimplementedError();
  }

  @override
  IPropertyFilteredQueryable<T> startsWith(value) {
    // TODO: implement startsWith
    throw UnimplementedError();
  }

}