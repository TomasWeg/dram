import 'package:dram/src/app/device/device_information.dart';
import 'package:dram/src/app/error_handler/base_error_handler.dart';
import 'package:flutter/foundation.dart';

class MultipleErrorHandler extends BaseErrorHandler {
  
  late final List<BaseErrorHandler> _handlers;

  MultipleErrorHandler({required List<BaseErrorHandler> handlers}) {
    this._handlers = handlers;
  }

  @override
  void init() {
    this._handlers.forEach((handler) => handler.init());
  }

  @override
  void onError(dynamic error, StackTrace stackTrace, DeviceInformation deviceInformation) {
    this._handlers.forEach((handler) => handler.onError(error, stackTrace, deviceInformation));
  }

  @override
  void onFlutterError(FlutterErrorDetails details, DeviceInformation deviceInformation) {
    this._handlers.forEach((handler) => handler.onFlutterError(details, deviceInformation));
  }

}