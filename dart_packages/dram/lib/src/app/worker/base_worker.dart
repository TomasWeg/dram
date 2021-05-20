import 'dart:async';

import 'package:dram/logger.dart';
import 'package:dram/src/app/service/domain_service.dart';
import 'package:flutter/foundation.dart';

/// A worker represents a background process which periodically reloads a [DomainService]
abstract class BaseWorker<TModel> {

  final Duration executeAfter;
  late DomainService<TModel> _service;

  late Timer _timer;

  BaseWorker({required this.executeAfter});

  /// Fetches the data.
  /// Returns a map that contains as key the id of the entity and
  /// as value the model itself.
  Future<Map<String, TModel>> fetch(); 

  void init(DomainService<TModel> service) {
    _timer = Timer(this.executeAfter, _callback);
    _service = service;
  }

  Future _callback() async {
    var result = await fetch();
    await _service.source.pushMany(result);
    Logger.info("BaseWorker for DomainService ${this._service.runtimeType} fetched ${result.length} entries at ${DateTime.now()}");
  }

  @mustCallSuper
  void dispose() {
    _timer.cancel();
  }

}