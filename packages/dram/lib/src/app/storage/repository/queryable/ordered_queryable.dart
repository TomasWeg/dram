part of 'queryable.dart';

class IOrderedQueryable<T> extends IQueryable<T> {
  final IQueryable<T> parent;
  final String fieldName;

  IOrderedQueryable(this.parent, this.fieldName) {
    parent.copyTo(this);
  }
}

class _IOrderedQueryable<T> extends IOrderedQueryable<T> {
  _IOrderedQueryable(IQueryable<T> parent, String fieldName) : super(parent, fieldName);

  _IOrderedQueryable<T> thenBy(String fieldName) {
    this.parent._appendOrder(fieldName, OrderDirection.Ascending);
    return this;
  }

  _IOrderedQueryable<T> thenByDescending(String fieldName) {
    this.parent._appendOrder(fieldName, OrderDirection.Descending);
    return this;
  }
}