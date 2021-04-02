import 'package:dram/app.dart';

import 'config_service.dart';

class DbService extends Service {
  DbService() : super(dependencies: [ConfigService]);
}