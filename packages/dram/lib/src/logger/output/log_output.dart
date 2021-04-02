import 'package:dram/src/logger/base/log_event.dart';

/// Receives an event and writes to a destination.
abstract class LogOutput {

  /// Writes the log event
  void write(LogEvent event);

}