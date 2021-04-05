import '../../dram_queryable.dart';

abstract class BaseQueryInterpreter<TSource> {

  /// Executes a query on an [Iterable] and returns a result
  Iterable<T> executeOn<T>(QueryDetails queryDetails, {TSource? source});
}