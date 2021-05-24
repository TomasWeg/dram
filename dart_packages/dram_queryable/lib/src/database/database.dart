import 'package:dram_queryable/dram_queryable.dart';

abstract class Database<TDatabaseModel extends DatabaseModel> {
  final TDatabaseModel _databaseModel;

  const Database(this._databaseModel);
}

abstract class DatabaseModel {

}