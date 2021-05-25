import 'package:drambase/src/query/query.dart';

part 'table.dart';

abstract class Database<TDatabase extends Database<TDatabase>> {

  /// The list of database tables
  late TDatabase _database;

  Database(){
    _database = this as TDatabase;
  }

  /// Selects a table to perform a query
  Query<TModel, TTable> select<TModel, TTable extends DatabaseTable<TModel>>(TTable Function(TDatabase database) tableSelector) {
    var table = tableSelector(_database);
    return Query.on(table);
  }

  Future _insert<TModel>(TModel entry){
    return Future.value();
  }

  Future _insertMany<TModel>(Iterable<TModel> entries) {
    return Future.value();
  }

  Future _delete<TModel>(String id) {
    return Future.value();
  }

  Future<Iterable<TModel>> _runQuery<TModel>() {
    return Future.value();
  }

  Future<Iterable<TModel>> _runRawQuery<TModel>(String sql) {
    return Future.value();
  }

  Future _update<TModel>(TModel entry) {
    return Future.value();
  }

}