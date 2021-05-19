import 'package:dram/app.dart';
import 'package:dram/module.dart';
import 'package:dram/src/app/dependency_injection/service_provider.dart';
import 'package:dram/src/app/service/source/domain_service_source.dart';
import 'package:flutter/foundation.dart';

/// A domain service is the main handler between UI and data storage and HTTP requests.
/// [TModel] is the entity type to be handled
abstract class DomainService<TModel> extends RequiredService {

  HttpModule? _http;
  DomainServiceSource<TModel>? _source;

  /// Reference to the HTTP module, if added
  HttpModule get http => _http == null ? throw new Exception("Module HttpModule is not added.") : _http!;

  /// The domain service source 
  DomainServiceSource<TModel> get source => _source!;

  /// Returns the base worker, if any, for this domain service
  BaseWorker? get worker => null;

  DomainService({required DomainServiceSource<TModel> serviceSource}) {
    _http = ServiceProvider.instance.getService<HttpModule>();
    _source = serviceSource;
  }

  /// Called when the domain service is initialized
  @mustCallSuper
  Future init() {
    if(worker != null) {
      worker!.init(this);
    }

    return Future.value();
  }

}