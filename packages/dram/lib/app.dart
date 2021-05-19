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
export 'src/app/service/adapter/model_adapter.dart';
export 'src/app/service/source/http_service_source.dart';
export 'src/app/service/source/domain_service_source.dart';
export 'src/app/service/source/mock_service_source.dart';
export 'src/app/service/source/sqflite_service_source.dart';
export 'src/app/service/source/memory_service_source.dart';
export 'src/app/service/source/multi_service_source.dart';
export 'src/app/service/domain_service.dart';
export 'src/app/http/api_response.dart';
export 'src/app/worker/base_worker.dart';

/// Runs an application
Future runApplication<TApplication extends Application>(TApplication application, Widget root) async {
  WidgetsFlutterBinding.ensureInitialized();
  DeviceInformation deviceInformation = await DeviceInformation.getCurrentDeviceInformation();
  // initializeReflectable();
  
  await application.init(main: root, deviceInformation: deviceInformation);
}
