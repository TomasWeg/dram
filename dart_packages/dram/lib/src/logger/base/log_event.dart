import 'logger_level.dart';

/// Represents something that is needed to be logged
class LogEvent {

  LogLevel? _level;
  String? _message;
  Map<String, dynamic>? _data;
  dynamic _error;
  StackTrace? _stackTrace;

  LogLevel? get level => _level;
  String? get message => _message;
  Map<String, dynamic>? get data => _data;
  dynamic get error => _error;
  StackTrace? get stackTrace => _stackTrace;

  LogEvent(LogLevel level, {String? message, Map<String, dynamic>? data, dynamic error, StackTrace? stackTrace}) {
    _level = level;
    _message = message;
    _data = data;
    _error = error;
    _stackTrace = stackTrace;
  } 
}