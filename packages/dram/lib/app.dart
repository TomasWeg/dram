library app;

import 'package:dram/src/app/application.dart';
import 'package:dram/src/app/device/device_information.dart';
import 'package:flutter/cupertino.dart';

export "src/app/application.dart";
export 'src/app/dependency_injection/service.dart';
export 'src/app/dependency_injection/service_provider.dart';
export 'src/app/error_handler/base_error_handler.dart';
export 'src/app/error_handler/console_error_handler.dart';
export 'src/app/error_handler/crashlytics_error_handler.dart';
export 'src/app/error_handler/multiple_error_handler.dart';
export 'src/app/device/platform.dart';
export 'src/app/device/device_information.dart';
export 'src/app/storage/adapter/model_adapter.dart';
export 'src/app/storage/provider/provider.dart';

/// Runs an application
Future runApplication<TApplication extends Application>(TApplication application, Widget root) async {
  WidgetsFlutterBinding.ensureInitialized();
  DeviceInformation deviceInformation = await DeviceInformation.getCurrentDeviceInformation();
  // initializeReflectable();
  
  await application.init(main: root, deviceInformation: deviceInformation);
}
