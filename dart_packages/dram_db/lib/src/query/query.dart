
import 'dart:collection';
import 'dart:convert';
import 'dart:io' as io;

import 'package:drambase/src/database/database.dart';
import 'package:drambase/src/database/field.dart';
import 'package:drambase/src/query/binary_expression.dart';

part 'debug_print.dart';
part 'expression.dart';
part 'parser.dart';
part 'boolean_expression.dart';
part 'queryable.dart';
part 'repair.dart';
part 'sort/sort_expression.dart';
part 'sort/sort_direction.dart';
part 'pagination/limit.dart';
part 'pagination/skip.dart';

class Query<TModel, TTable extends DatabaseTable<TModel>> {

  late Expression _where;
  Limit? _limit;
  Skip? _skip;
  final Map<DatabaseTableField, SortDirection> _sort;
  final TTable _table;

  Query._(this._table) : _sort = HashMap<DatabaseTableField, SortDirection>(equals: (a, b) => a.fieldName == b.fieldName);

  static Query<TModel, TTable> on<TModel, TTable extends DatabaseTable<TModel>>(TTable table) {
    return Query._(table);   
  }

  /// Applies a condition to a data source query
  Query<TModel, TTable> where<TDartType>(Expression Function(TTable table) expression) {
    _checkLimit();
    var result = expression(_table);
    _where = result;
    return this;
  }

  /// Sorts the entries in an ascending order
  Query<TModel, TTable> orderBy(DatabaseTableField Function(TTable table) expression) {
    _checkLimit();
    var result = expression(_table);
    if(_sort.entries.any((element) => element.key.fieldName == result.fieldName)) {
      throw Exception('Field ${result.fieldName} already added to sort.');
    }

    _sort[result] = SortDirection.ascending;
    return this;
  }

  /// Sorts the entries in a descending order
  Query<TModel, TTable> orderByDescending(DatabaseTableField Function(TTable table) expression) {
    _checkLimit();
    var result = expression(_table);
    if(_sort.entries.any((element) => element.key.fieldName == result.fieldName)) {
      throw Exception('Field ${result.fieldName} already added to sort.');
    }

    _sort[result] = SortDirection.descending;
    return this;
  }

  /// Limits the results of the query
  Query<TModel, TTable> limit(int count) {
    _limit = Limit(count);
    return this;
  }

  /// Skips entries from the result set
  Query<TModel, TTable> skip(int count) {
    _skip = Skip(count);
    return this;
  }

  /// Paginates the result set
  Query<TModel, TTable> paginate(int page, int pageSize) {
    _skip = Skip((page - 1) * pageSize);
    _limit = Limit(pageSize);
    return this;
  }

  void _checkLimit() {
    if(_limit != null || _skip != null) {
      throw ArgumentError('Could not sort or filter entries after limiting or skipping the result set.');
    }
  }

}