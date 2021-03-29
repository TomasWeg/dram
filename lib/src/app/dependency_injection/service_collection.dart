part of 'service.dart';

/// Used to build services at runtime
class ServiceCollection {

  int _registerdServices = 0;

  int get services => this._registerdServices;

  /// Registers a new singleton service
  void registerSingleton<TModel extends BaseService>(TModel implementation) {
    if(implementation._isLazy) {
      GetIt.I.registerLazySingleton<TModel>(() => implementation, instanceName: implementation._name, dispose: (model) => model.dispose());
      Logger.debug("Registered lazy service '$TModel' with Singleton lifetime.");
    } else {
      if(implementation is RequiredService) {
        GetIt.I.registerSingletonAsync<TModel>(() async {
          await implementation.init();
          GetIt.I.signalReady(implementation);
          return implementation;
        }, dispose: (model) => model.dispose(), instanceName: implementation._name, dependsOn: implementation._dependencies, signalsReady: true);

        Logger.debug("Registered required service '$TModel' with Singleton lifetime.");
      } else {
        if(implementation._dependencies != null) {
          GetIt.I.registerSingletonWithDependencies<TModel>(() => implementation, dependsOn: implementation._dependencies, instanceName: implementation._name, dispose: (model) => model.dispose());
          Logger.debug("Registered service '$TModel' with Singleton lifetime and ${implementation._dependencies!.length} dependencies.");
        } else {
          GetIt.I.registerSingleton<TModel>(implementation, instanceName: implementation._name, dispose: (model) => model.dispose());
          Logger.debug("Registered service '$TModel' with Singleton lifetime.");
        }
      }
    }

    this._registerdServices++;
  }

  void registerFactory<TModel extends BaseService>(TModel Function() factoryFunc) {
    GetIt.I.registerFactory(factoryFunc);
    Logger.debug("Registered service '$TModel' with Factory lifetime.");
    this._registerdServices++;
  }
}