part of 'database.dart';

/// Represents a [Drambase] table.
abstract class DatabaseTable<TModel> {
  final String tableName;
  final Database _database;

  DatabaseTable(this.tableName, this._database);

  Map<String, Object> toTable(TModel model);
  TModel fromTable(Map<String, Object> map);

  Future<TModel> findOne(String id) async {
    var result = await _database._runQuery();
    return result.first;
  }

  Future insert(TModel model) {
    return _database._insert<TModel>(model);
  }

  Future insertMany(Iterable<TModel> entries) {
    return _database._insertMany<TModel>(entries);
  }

  Future delete(String id) {
    return _database._delete<TModel>(id);
  }

  Future update(TModel entry) {
    return _database._update<TModel>(entry);
  }

  Future<Iterable<TModel>> runQuery(String sql) {
    return _database._runRawQuery(sql);
  }
}