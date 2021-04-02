import 'package:dram/src/app/device/device_information.dart';
import 'package:dram/src/app/error_handler/base_error_handler.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';

class CrashlyticsErrorHandler extends BaseErrorHandler {
  @override
  void onError(dynamic error, StackTrace stackTrace, DeviceInformation deviceInformation) {
    FirebaseCrashlytics.instance.recordError(error, stackTrace);
  }

  @override
  void onFlutterError(FlutterErrorDetails details, DeviceInformation deviceInformation) {
    FirebaseCrashlytics.instance.recordFlutterError(details);
  }

  @override
  void init() {}

}