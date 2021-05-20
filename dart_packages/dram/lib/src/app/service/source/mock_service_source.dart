import 'package:dram/logger.dart';
import 'package:dram/src/app/service/source/domain_service_source.dart';

class MockServiceSource<T> extends DomainServiceSource<T> {

  late Map<String, T> _entries;

  MockServiceSource({required Map<String, T> entries}) {
    _entries = entries;
  }

  @override
  Future<T?> find(String id) {
    dynamic value = _entries[id];
    if(value == null) {
      return Future.value(null);
    }

    return Future.value(value as T);
  }

  @override
  Future<List<T>> findMany({Map<String, dynamic>? params, DateTime? notBefore}) {
    return Future.value(_entries.values.toList());
  }

  @override
  Future push(String key, T entity) {
    return Future.microtask(() {
      _entries[key] = entity;
      Logger.trace("Pushed one entity of type $T with key $key to MemoryServiceSource.");
    });
  }

  @override
  Future pushMany(Map<String, T> entities) {
    return Future.microtask(() {
      _entries.addAll(entities);
      Logger.trace("Pushed ${entities.length} entities of type $T to MemoryServiceSource.");
    });
  }

  @override
  Future delete(String key) {
    return Future.microtask(() {
      _entries.remove(key);
      Logger.trace("Deleted entity with key $key");
    });
  }
}