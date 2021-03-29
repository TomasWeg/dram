import 'package:dram/app.dart';
import 'package:dram/logger.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'config_service.dart';
import 'db_service.dart';

class App extends Application {

  @override
  Future afterAppInitialization() {
    throw UnimplementedError();
  }

  @override
  Future beforeAppInitialization() async {
    await initializeDateFormatting("es");
  }

  @override
  void registerServices(ServiceCollection services) {
    services.registerSingleton<ConfigService>(ConfigService());
    services.registerFactory<DbService>(() => DbService());
  }

  @override
  Logger get logger => Logger(
    filter: DefaultFilter(),
    minimumLevel: LogLevel.Trace,
    output: ConsoleLogOutput()
  );

  @override
  BaseErrorHandler get errorHandler => ConsoleErrorHandler();

}