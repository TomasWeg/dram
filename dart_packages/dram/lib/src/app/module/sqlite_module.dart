import 'package:dram/module.dart';
import 'package:sqflite/sqflite.dart';

class SqliteModule extends Module {

  final String _databaseName;
  late Database _database;

  Database get database => _database;

  SqliteModule({String? databaseName}) : this._databaseName = databaseName ?? "app";

  @override
  Future initialize() async {
    _database = await openDatabase("$_databaseName.db");
  }
  
}