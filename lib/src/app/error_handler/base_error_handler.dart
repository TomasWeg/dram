import 'package:dram/src/app/device/device_information.dart';
import 'package:flutter/cupertino.dart';

/// Handles error that occurrs in the application zone
abstract class BaseErrorHandler {

  /// Called when the error handler is initialized
  void init();

  /// Fired when an error occurs
  /// [error] The error information.
  /// [stackTrace] The current stack trace.
  /// [deviceInformation] The information about the current running device.
  void onError(dynamic error, StackTrace stackTrace, DeviceInformation deviceInformation);

  /// Fired when an error of the Flutter framework occurs
  /// [details] The details about the error.
  /// [deviceInformation] The information about the current running device.
  void onFlutterError(FlutterErrorDetails details, DeviceInformation deviceInformation);
}