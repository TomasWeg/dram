import 'package:dram/src/logger/base/ansi_color.dart';
import 'package:dram/src/logger/base/log_event.dart';
import 'package:dram/src/logger/base/logger_level.dart';

import 'log_output.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';

class CrashlyticsOutput extends LogOutput {

  @override
  void write(LogEvent event) {
    if(event.level != LogLevel.Error || event.level != LogLevel.Fatal || event.error == null || event.stackTrace == null) {
      return;
    }

    FirebaseCrashlytics.instance.recordError(event.error, event.stackTrace, reason: event.message);
  }

}