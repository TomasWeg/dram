import 'package:dram/src/app/dependency_injection/service.dart';

/// A module represents a hook that can be added to an application
abstract class Module extends RequiredService {

  /// Initializes the module at application startup
  Future initialize() async {}

  /// Initializes the module after the application startup
  Future lateInitialization() async {}

}