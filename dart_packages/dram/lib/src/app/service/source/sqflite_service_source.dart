import 'package:dram/logger.dart';
import 'package:dram/src/app/dependency_injection/service_provider.dart';
import 'package:dram/src/app/module/sqlite_module.dart';
import 'package:dram/src/app/service/adapter/model_adapter.dart';
import 'package:dram/src/app/service/adapter/model_adapter_provider.dart';
import 'package:dram/src/app/service/source/domain_service_source.dart';
import 'package:sqflite/sqflite.dart';

class SqliteServiceSource<T> extends DomainServiceSource<T> {

  late SqliteModule _sqlite;
  String? _tableName;

  SqliteServiceSource({String? tableName}) {
    var sqliteModel = ServiceProvider.instance.getService<SqliteModule>();
    assert(sqliteModel != null, "SqliteModule is not added, which is required to use SqliteServiceSource.");

    _sqlite = sqliteModel!;
    _tableName = tableName;
  }

  @override
  Future<T?> find(String id) async {
    ModelAdapter<T> adapter = ModelAdapterProvider().adapterFor<T, SqliteServiceSource>(defaultIfNotFound: true);
    String tableName = _tableName ?? adapter.name;
    List<Map<String, Object?>> result = await _sqlite.database.query(tableName, 
      where: "id = ?",
      whereArgs: [id],
    );

    if(result.isEmpty) {
      return null;
    }

    return adapter.fromProvider(result[0]);
  }

  @override
  Future<List<T>> findMany({Map<String, dynamic>? params, DateTime? notBefore}) async {
    ModelAdapter<T> adapter = ModelAdapterProvider().adapterFor<T, SqliteServiceSource>(defaultIfNotFound: true);
    String tableName = _tableName ?? adapter.name;

    StringBuffer? keyBuffer;
    if(params != null) {
      keyBuffer = StringBuffer();
      for(int i = 0; i < params.length; i++) {
        if(i < params.length-1) {
          keyBuffer.write("${params.keys.elementAt(i)} = ?");
          continue;
        }

        keyBuffer.write(' & ');
      }
    }

    List<Map<String, Object?>> result = await _sqlite.database.query(tableName, 
      where: keyBuffer == null ? null : keyBuffer.toString(),
      whereArgs: keyBuffer == null ? null : params!.values.toList()
    );

    if(result.isEmpty) {
      return List<T>.empty();
    }

    return result.map((e) => adapter.fromProvider(e)).toList();
  }

  @override
  Future push(String key, T entity) async {
    ModelAdapter<T> adapter = ModelAdapterProvider().adapterFor<T, SqliteServiceSource>(defaultIfNotFound: true);
    String tableName = _tableName ?? adapter.name;
    Map<String, dynamic> entry = adapter.toProvider(entity);
    if(!entry.containsKey("id")) {
      entry["id"] = key;
    }

    await _sqlite.database.insert(tableName, entry.cast<String, Object?>(), conflictAlgorithm: ConflictAlgorithm.replace);
    Logger.trace("Pushed one entity of type $T with key $key to SqfliteServiceSource.");
  }

  @override
  Future pushMany(Map<String, T> entries) async {
    ModelAdapter<T> adapter = ModelAdapterProvider().adapterFor<T, SqliteServiceSource>(defaultIfNotFound: true);
    String tableName = _tableName ?? adapter.name;

    var result = await _sqlite.database.transaction<List<Object?>>((txn) {

      var batch = txn.batch();

      for(var entry in entries.entries) {
        String entryKey = entry.key;
        Map<String, Object?> entryFormat = (adapter.toProvider(entry.value) as Map<String, dynamic>).cast<String, Object?>();

        if(!entryFormat.containsKey("id")) {
          entryFormat["id"] = entryKey;
        }

        batch.insert(tableName, entryFormat, conflictAlgorithm: ConflictAlgorithm.replace);
      }

      return batch.commit();
    });

    Logger.trace("Result of pushing ${entries.length} entities of type $T to SqliteServiceSource:", data: {
      "results": result.map((e) => e.toString())
    });
  }

  @override
  Future delete(String key) async {
    ModelAdapter<T> adapter = ModelAdapterProvider().adapterFor<T, SqliteServiceSource>(defaultIfNotFound: true);
    String tableName = _tableName ?? adapter.name;

    int result = await _sqlite.database.delete(tableName, where: "id = ?", whereArgs: [key]);
    if(result > 0) {
      Logger.trace("An entity of type $T with key $key was deleted.");
    } else {
      Logger.trace("An error ocurred and an entity of type $T with key $key could not be deleted.");
    }
  }

}