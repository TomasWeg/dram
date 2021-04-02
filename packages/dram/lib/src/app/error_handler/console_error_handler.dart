import 'package:dram/logger.dart';
import 'package:dram/src/app/device/device_information.dart';
import 'package:dram/src/app/error_handler/base_error_handler.dart';
import 'package:flutter/foundation.dart';

class ConsoleErrorHandler extends BaseErrorHandler {
  @override
  void init() {}

  @override
  void onError(dynamic error, StackTrace stackTrace, DeviceInformation deviceInformation) {
    Logger.fatal("An unhandled error occurred.", error: error, stackTrace: stackTrace, data: deviceInformation.toJson());
  }

  @override
  void onFlutterError(FlutterErrorDetails details, DeviceInformation deviceInformation) {
    Logger.fatal("An unhandled Flutter error occurred: ${TextTreeRenderer().render(details.toDiagnosticsNode())}", error: details.exception, stackTrace: details.stack, data: deviceInformation.toJson());
  }

}