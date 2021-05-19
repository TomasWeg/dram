import 'package:dram/logger.dart';
import 'package:dram/src/app/service/source/domain_service_source.dart';

typedef MemorySourceInterpreterFunc<T> = Iterable<T> Function(Map<String, T> entries, Map<String, dynamic>? parameters, DateTime? notBefore);

class MemoryServiceSource<T> extends DomainServiceSource<T> {

  late Map<String, T> _entries;
  late MemorySourceInterpreter<T> _interpreter;
  late DateTime _expiration;

  MemoryServiceSource({required MemorySourceInterpreter<T> interpreter, Duration? ttl}) {
    _entries = {};
    _interpreter = interpreter;
    _expiration = DateTime.now().add(ttl ?? const Duration(minutes: 10));
  }

  @override
  Future<T?> find(String id) {
    if(_checkExpiration()) {
      return Future.value(null);
    }

    dynamic value = _entries[id];
    if(value == null) {
      return Future.value(null);
    }

    return Future.value(value as T);
  }

  @override
  Future<List<T>> findMany({Map<String, dynamic>? params, DateTime? notBefore}) {
    if(_checkExpiration()) {
      return Future.value([]);
    }

    var result = this._interpreter._callback(_entries, params, notBefore);
    return Future.value(result.toList());
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

  bool _checkExpiration() {
    Duration diff = _expiration.difference(DateTime.now());
    bool expired = diff.inSeconds < 10;
    if(expired) {
      _entries.clear();
      Logger.trace("MemoryServiceSource cache expired.");
    }

    return expired;
  }

}

class MemorySourceInterpreter<T> {
  
  final MemorySourceInterpreterFunc<T> _callback;
  final Type _type;
  MemorySourceInterpreter._(this._callback, this._type);

  static MemorySourceInterpreter<T> forType<T>(MemorySourceInterpreterFunc<T> callback) {
    return MemorySourceInterpreter._(callback, T);
  }
}