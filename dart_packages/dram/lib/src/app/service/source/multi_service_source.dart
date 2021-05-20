import 'dart:async';

import 'package:dram/src/app/service/source/domain_service_source.dart';

/// This service source contains multiple [ServiceSource] which
/// are executed in order they were added until data is retrieved.
class MultiServiceSource<T> extends DomainServiceSource<T> {

  final List<DomainServiceSource<T>> sources;
  final Duration timeout;

  /// Builds a [MultiServiceSource].
  /// [sources] are the service sources to append.
  /// [timeout] is the timeout until ignore the current request and pass to the next.
  MultiServiceSource({required List<DomainServiceSource<T>> sources, Duration? timeout})
   : this.sources = List.unmodifiable(sources), this.timeout = timeout ?? const Duration(seconds: 2);

  @override
  Future<T?> find(String id) async {
    for(int i = 0; i < sources.length; i++) {
      var source = sources[i];
      try {
        T? result = await source.find(id).timeout(this.timeout);
        if(i > 0 && result != null) {
          // Get previous source and push entry
          try {
            var previous = sources[i-1];
            previous.push(id, result);
          } catch(_) {}

        }

        return result;
      } on TimeoutException catch(_) {
        continue;
      }
    }

    return null;
  }

  @override
  Future<List<T>> findMany({Map<String, dynamic>? params, DateTime? notBefore}) async {
    for(var source in sources) {
      try {
        return await source.findMany(params: params, notBefore: notBefore).timeout(this.timeout);
      } on TimeoutException catch(_) {
        continue;
      }
    }

    return List<T>.empty();
  }

  @override
  Future delete(String key) => Future.wait(sources.map((e) => e.delete(key)));

  @override
  Future push(String key, T entity) => Future.wait(sources.map((e) => e.push(key, entity)));

  @override
  Future pushMany(Map<String, T> entities) => Future.wait(sources.map((e) => e.pushMany(entities)));

}