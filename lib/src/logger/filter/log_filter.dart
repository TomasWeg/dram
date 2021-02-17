
import 'package:dram/src/logger/base/log_event.dart';

/// Used to filter the logs that are processed
abstract class LogFilter {

  /// Indicates if an event type should be logged.
  /// Return true to allow logging, otherwise, false.
  bool shouldLog(LogEvent event);
}