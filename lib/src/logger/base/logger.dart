
import 'package:dram/src/logger/base/log_event.dart';
import 'package:dram/src/logger/filter/log_filter.dart';
import 'package:dram/src/logger/output/log_output.dart';

import 'logger_level.dart';

/// Class used to log messages to console, files, and more loggers
class Logger {

  static Logger _instance;
  Logger._(this._level, this._logFilter, this._logOutput);

  /// Creates a new Logger
  factory Logger({LogFilter filter, LogOutput output, LogLevel minimumLevel = LogLevel.Debug}) {
    if(_instance == null) {
      _instance = Logger._(minimumLevel, filter, output);
    }

    return _instance;
  }

  LogLevel _level;
  LogOutput _logOutput;
  LogFilter _logFilter;

  /// The minimum level to process
  LogLevel get minimumLevel => _level;

  /// Logs an [LogLevel.Info] message
  void info(String message, {dynamic error, StackTrace stackTrace, Map<String, dynamic> data}) {
    _log(LogLevel.Info, message, data, error, stackTrace);
  }

  /// Logs an [LogLevel.Debug] message
  void debug(String message, {dynamic error, StackTrace stackTrace, Map<String, dynamic> data}) {
    _log(LogLevel.Debug, message, data, error, stackTrace);
  }

  /// Logs an [LogLevel.Warning] message
  void warning(String message, {dynamic error, StackTrace stackTrace, Map<String, dynamic> data}) {
    _log(LogLevel.Warning, message, data, error, stackTrace);
  }

  /// Logs an [LogLevel.Fatal] message
  void fatal(String message, {dynamic error, StackTrace stackTrace, Map<String, dynamic> data}) {
    _log(LogLevel.Fatal, message, data, error, stackTrace);
  }

  /// Logs an [LogLevel.Error] message
  void error(String message, {dynamic error, StackTrace stackTrace, Map<String, dynamic> data}) {
    _log(LogLevel.Error, message, data, error, stackTrace);
  }

  void _log(LogLevel level, String message, Map<String, dynamic> data, dynamic error, StackTrace stackTrace) {
    LogEvent event = LogEvent(level, message: message, data: data, error: error, stackTrace: stackTrace);
    if(_logFilter.shouldLog(event)) {
      try {
        _logOutput.write(event);
      } catch(err) {
        throw err;
      }
    }
  }
}