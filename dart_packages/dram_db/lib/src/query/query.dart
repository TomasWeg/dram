
import 'dart:convert';

import 'package:drambase/src/database/database.dart';

part 'debug_print.dart';
part 'expression.dart';
part 'parser.dart';
part 'boolean_expression.dart';
part 'queryable.dart';
part 'repair.dart';

class Query<TModel, TTable extends DatabaseTable<TModel>> {

  final List<Expression> _where = [];
  final TTable _table;

  Query._(this._table);

  static Query<TModel, TTable> on<TModel, TTable extends DatabaseTable<TModel>>(TTable table) {
    return Query._(table);   
  }

  /// Applies a condition to a data source query
  Query<TModel, TTable> where<TDartType>(Expression Function(TTable table) expression) {
    var result = expression(_table);
    _where.add(result);
    return this;
  }

  /// Aplies many AND conditions to a data source query
  Query<TModel, TTable> whereC(Iterable<Expression> Function(TTable table) expressions) {
    var result = expressions(_table);
    _where.addAll(result);
    return this;
  }

}