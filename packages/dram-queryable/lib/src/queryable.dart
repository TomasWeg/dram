import 'package:dram_queryable/src/exception/invalid_query.dart';
import 'package:dram_queryable/src/model/where.dart';

part 'filtered_queryable.dart';

abstract class IQueryable<T> {

  Type? _type;
  List<BaseWhere>? _where;
  BaseWhere? _currentWhere;

  /// The queryable model type
  Type get type {
    if(_type == null) {
      throw InvalidQueryException('Query is incomplete and missing of a type.');
    }

    return _type!;
  }

  IQueryable._(this._type);
  IQueryable._empty();

  static IQueryable<T> on<T>() {
    return _IQueryableImpl._(T);
  }

  IPropertyFilteredQueryable<T> where(String fieldName) {
    return _IPropertyFilteredQueryableImpl(this, fieldName);
  }

  void copyTo(IQueryable<T> other) {
    other._type = _type;
  }

}

class _IQueryableImpl<T> extends IQueryable<T> {
  _IQueryableImpl._(Type type) : super._(type);
}