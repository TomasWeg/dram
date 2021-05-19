import 'package:dram/app.dart';
import 'package:dram/logger.dart';
import 'package:dram/module.dart';
import 'package:example/business/movies_service.dart';
import 'package:flutter/foundation.dart';

import 'business/movie.dart';

class App extends Application {
  @override
  Future afterAppInitialization() {
    throw UnimplementedError();
  }

  @override
  Future beforeAppInitialization() {
    throw UnimplementedError();
  }

  @override
  BaseErrorHandler get errorHandler => ConsoleErrorHandler();

  @override
  Logger get logger => Logger();

  @override
  Map<Type, ModelAdapterBuilder> get modelAdapters => {
    Movie: MovieAdapters()
  };

  @override
  List<Module> get modules => [
    SqliteModule(
      databaseName: "umovie"
    ),
    HttpModule(
      endpoint: "localhost:5565"
    ),
    StorageModule()
  ];

  @override
  void registerServices(ServiceCollection services) {
  }

  @override
  List<DomainService> registerDomainServices(Platform platform) {
    if(kDebugMode) {
      return [MockMoviesService()];
    } else {
      return [MoviesService()];
    }
  }

}