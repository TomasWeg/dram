/// A service source handles communication with data storages. 
/// For example, a ServiceSource can be a memory cache, a sqlite database, a network request to
/// a backend, etc.
abstract class DomainServiceSource<T> {

  /// Finds an entity by id
  Future<T?> find(String id);

  /// Finds many entities based on a condition
  /// [params] the parameters used to scan the data.
  /// [notBefore] will skip values which their modifiedAt is not before at a date
  Future<List<T>> findMany({Map<String, dynamic>? params, DateTime? notBefore});

  /// Push an entity to the service source
  Future push(String key, T entity) => Future.value();

  /// Push many entities to the service source
  Future pushMany(Map<String, T> entities) => Future.value();

  /// Deletes an entity
  Future delete(String key) => Future.value();

}