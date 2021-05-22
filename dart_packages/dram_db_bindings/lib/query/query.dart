part 'operator.dart';
part 'statement.dart';
part 'where.dart';
part 'filter_query.dart';

class Query<T> {

  Type? _type;
  BaseWhere? _currentWhere;
  Query<T>? _parent;
  bool _isSub = false;

  Type get type {
    if(_type == null) {
      throw new Exception("Missing type.");
    }

    return _type!;
  }

  Query._(this._type);
  Query._empty();

  void copyTo(Query<T> other) {
    other._type = _type;
    other._parent = _parent;
    other._currentWhere = _currentWhere;
    other._isSub = _isSub;
  }

}