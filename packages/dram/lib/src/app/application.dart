import 'dart:async';
import 'dart:isolate';

import 'package:dram/app.dart';
import 'package:dram/logger.dart';
import 'package:dram/src/app/dependency_injection/service.dart';
import 'package:dram/src/app/device/device_information.dart';
import 'package:dram/src/app/device/universal_platform/universal_platform.dart';
import 'package:dram/src/app/error_handler/base_error_handler.dart';
import 'package:dram/src/app/service/adapter/model_adapter_provider.dart';
import 'package:dram/src/app/service/domain_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:get_it/get_it.dart';

import 'module/module.dart';
import 'service/adapter/model_adapter.dart';

/// Represents a base application
abstract class Application {

  late Widget _main;
  late DeviceInformation _deviceInformation;

  /// Returns the logger of the application.
  /// If you use a third party logger system, you can set this to null.
  Logger get logger;

  /// Returns the current error handler of the application.
  BaseErrorHandler get errorHandler;

  /// The list of model that are mappeds to their corresponding adapter
  Map<Type, ModelAdapterBuilder> get modelAdapters;

  /// The modules of the application
  List<Module> get modules;

  /// Initializes the application
  Future init({required Widget main, required DeviceInformation deviceInformation}) async {

    // Setup main widget
    this._main = main;
    this._deviceInformation = deviceInformation;
    
    Logger.debug("Starting application on '${deviceInformation.toString()}' device.");

    // Exceutes before app initialization
    try { 
      Logger.trace("Calling beforeAppInitialization...");
      await beforeAppInitialization(); 
    } catch(_) {}

    // Register dependencies
    Logger.trace("Registering services...");

    ServiceCollection serviceCollection = ServiceCollection();
    registerServices(serviceCollection);
    await _loadModules(serviceCollection);
    await _loadDomainServices(serviceCollection);
    Logger.debug("Registered ${serviceCollection.services} services.");

    // Wait until required services are loaded
    Logger.trace("Initializing required services...");
    await GetIt.I.allReady();
    Logger.trace("Required services initialized.");

    // Run Flutter application
    Logger.trace("Running Flutter application...");
    await runZonedGuarded<Future<void>>(() async {

      // Add error handlers
      FlutterError.onError = (flutterErrorDetails) => errorHandler.onFlutterError(flutterErrorDetails, deviceInformation);
      Isolate.current.addErrorListener(RawReceivePort((pair) async {
        final List<dynamic> errorAndStack = pair;
        errorHandler.onError(errorAndStack.first, errorAndStack.last, deviceInformation);
      }).sendPort);

      // Run Flutter app
      runApp(this._main);

      // Late initialization of modules
      Logger.trace("Calling late initialization of modules...");
      _lateModulesInit();

      // Execute after app initialization
      try { 
        Logger.trace("Calling afterAppInitialization...");
        afterAppInitialization(); 
      } catch(_) {}

    }, (err, stack) {
      errorHandler.onError(err, stack, deviceInformation);
    });
  }

  /// Called before the app start ups and dependencies are registered
  Future beforeAppInitialization();

  /// Called after the app started up and dependencies were registered
  Future afterAppInitialization();

  /// Registers all the services to use in the application
  void registerServices(ServiceCollection services);

  List<DomainService> registerDomainServices(Platform platform) => [];

  Future _loadDomainServices(ServiceCollection services) async {
    Logger.debug("Loading domain services...");
    var domainServices = registerDomainServices(UniversalPlatform.getCurrentPlatform());
    for(DomainService domainService in domainServices) {
      services.registerSingleton(domainService);
    }

    await Future.wait(domainServices.map((e) => e.init()));
  }

  Future _loadModules(ServiceCollection services) async {
    Logger.debug("Loading modules...");
    DefaultModelAdapterProvider(modelAdapters);
    for(Module module in modules) {
      services.registerSingleton(module);
    }

    await Future.wait(modules.map((e) => e.initialize()));
  }

  Future _lateModulesInit() async {
    await Future.wait(modules.map((e) => e.lateInitialization()));
  }

}