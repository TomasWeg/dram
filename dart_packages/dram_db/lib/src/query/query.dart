import 'package:drambase/src/database/database.dart';

part 'expression.dart';
part 'queryable.dart';
part 'query_expression.dart';

class Query<TModel, TTable extends DatabaseTable<TModel>> {

  final List<Expression> _where = [];
  final TTable _table;
  // final Database _db;

  Query._(this._table);

  static Query<TModel, TTable> on<TModel, TTable extends DatabaseTable<TModel>>(TTable table) {
    return Query._(table);   
  }

  Query where<TDartType>(Expression<TDartType> Function(TTable table) expression) {
    var result = expression(_table);
    _where.add(result);
    return this;
  }

}