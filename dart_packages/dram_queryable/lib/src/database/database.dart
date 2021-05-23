import 'package:dram_queryable/dram_queryable.dart';

abstract class Database<TDatabaseModel extends DatabaseModel> {
  final TDatabaseModel _databaseModel;

  const Database(this._databaseModel);

  SelectableExpression<TModel, TQueryable> select<TModel, TQueryable extends QueryableModel<TModel>>(TQueryable Function(TDatabaseModel model) selector) {
    var model = selector(_databaseModel);
    return SelectableExpression<TModel, TQueryable>(model, this);
  }
}

abstract class DatabaseModel {

}