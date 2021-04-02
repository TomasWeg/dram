import 'package:dram/src/logger/base/log_event.dart';
import 'package:dram/src/logger/base/logger_level.dart';
import 'package:flutter/foundation.dart';

import 'log_filter.dart';

/// The default filter checks if the app is in production to only allow 
/// Error and Fatal log levels, otherwise, all levels are allowed.
class DefaultFilter extends LogFilter {

  @override
  bool shouldLog(LogEvent event) {
    return kDebugMode ? true : (event.level == LogLevel.Fatal || event.level == LogLevel.Error);
  }
}