
/// Represents the level of a log message
enum LogLevel {
  Trace,
  Debug,
  Info,
  Warning,
  Error,
  Fatal
}

extension LogLevelExtension on LogLevel? {

  static final Map<LogLevel, String> _names = {
    LogLevel.Trace: 'TRACE',
    LogLevel.Debug: 'DEBUG',
    LogLevel.Error: 'ERROR',
    LogLevel.Fatal: 'FATAL',
    LogLevel.Warning: 'WARNING',
    LogLevel.Info: 'INFO'
  };

  String getName() {
    return _names[this]!;
  }
}