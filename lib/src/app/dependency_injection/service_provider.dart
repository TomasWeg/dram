import 'package:dram/src/exception/service_not_registered.dart';
import 'package:get_it/get_it.dart';

/// Represents a way to access dependencies
class ServiceProvider {

  static final ServiceProvider instance = ServiceProvider._();
  ServiceProvider._();

  /// Try to get a service.
  /// If the service is not registered, null is returned.
  TModel? getService<TModel extends Object>({String? name}) {
    if(!GetIt.I.isRegistered<TModel>(instanceName: name)) {
      return null;
    }

    return GetIt.I.get<TModel>(instanceName: name);
  }

  /// Try to get a service.
  /// If the service is not registered, a [ServiceNotRegisteredException] is thrown.
  TModel getRequiredService<TModel extends Object>({String? name}) {
    if(!GetIt.I.isRegistered<TModel>(instanceName: name)) {
      throw new ServiceNotRegisteredException(serviceType: "$TModel");
    }

    return GetIt.I.get<TModel>(instanceName: name);
  }
}