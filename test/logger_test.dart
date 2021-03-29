import 'dart:io';

import 'package:dram/src/logger/base/log_event.dart';
import 'package:dram/src/logger/base/logger_level.dart';
import 'package:dram/src/logger/output/console_output.dart';

void main() {
  var output = ConsoleLogOutput(logWriter: ConsoleLogWriter.Stdout);
  output.write(LogEvent(LogLevel.Error, 
    message: 'Unhandled error',
    error: SocketException('Failed to look up host.'),
    stackTrace: StackTrace.current
  ));

  output.write(LogEvent(LogLevel.Info, 
    message: 'Incoming data.',
    data: {
      'name': 'Fernando',
      'age': 27,
      'addres': {
        'city': 'Maciá'
      }
    }
  ));

  output.write(LogEvent(LogLevel.Debug, 
    message: 'Debug message',
  ));

  output.write(LogEvent(LogLevel.Warning, 
    message: 'A warning',
  ));

  output.write(LogEvent(LogLevel.Fatal, 
    message: 'FATAL ERROR',
  ));
}