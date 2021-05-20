import 'package:dram/logger.dart';
import 'package:get_it/get_it.dart';

part 'service_collection.dart';

/// Class that each service is registered on dependency injection
/// must derive from.
abstract class BaseService {

  late List<Type>? _dependencies;
  late String? _name;
  late bool _isLazy;

  /// Default constructor
  /// [dependencies] Contains a list of types this service depends on.
  /// [name] An optional name for the service.
  /// [isLazy] Indicates if the service is lazy loaded. Defaults to false.
  BaseService({List<Type>? dependencies, String? name, bool isLazy = false}) {
    this._dependencies = dependencies;
    this._name = name;
    this._isLazy = isLazy;
  }

  /// Called when the service is initialized
  Future init();

  /// Called when the service is disposed
  void dispose();
}

/// Represents a normal service which is not needed by the application to work
/// so its initialization is delayed until first call.
abstract class Service extends BaseService {

  /// Default constructor
  /// [dependencies] Contains a list of types this service depends on.
  /// [name] An optional name for the service.
  Service({List<Type>? dependencies, String? name, bool isLazy = false}) : super(dependencies: dependencies, isLazy: isLazy, name: name);

  @override
  void dispose() {}

  @override
  Future init() async {}
}

/// Represents a service which is required to work and it is initialized
/// at application startup
abstract class RequiredService extends BaseService {

  /// Default constructor
  /// [dependencies] Contains a list of types this service depends on.
  /// [name] An optional name for the service.
  RequiredService({List<Type>? dependencies, String? name}) : super(dependencies: dependencies, isLazy: false, name: name);

  @override
  void dispose() {}

  @override
  Future init() async {}
}