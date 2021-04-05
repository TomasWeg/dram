part of 'queryable.dart';

abstract class ISortedQueryable<T> extends IQueryable<T> {

  final IQueryable<T> _parent;

  ISortedQueryable(this._parent) : super._empty() {
    _parent.copyTo(this);
  }

  ISortedQueryable<T> thenBy(String fieldName) {
    return this;
  }

}