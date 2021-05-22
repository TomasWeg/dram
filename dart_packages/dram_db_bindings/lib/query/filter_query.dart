part of 'query.dart';

abstract class FilteredQuery<T> extends Query<T> {
  final Query<T> _parent;
  FilteredQuery(this._parent) : super._empty() {
    _parent.copyTo(this);
  }
}