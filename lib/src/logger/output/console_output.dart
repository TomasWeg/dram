import 'dart:convert';
import 'dart:developer' as developer;

import 'package:dram/src/logger/base/ansi_color.dart';
import 'package:dram/src/logger/base/log_event.dart';
import 'package:dram/src/logger/base/logger_level.dart';

import 'log_output.dart';


class ConsoleLogOutput extends LogOutput {

  bool _usePrint;

  ConsoleLogOutput({bool usePrint}) {
    _usePrint = usePrint;
  }

  static final Map<LogLevel, AnsiColor> _levelColors = {
    LogLevel.Debug: AnsiColor.none(),
    LogLevel.Info: AnsiColor(10),
    LogLevel.Warning: AnsiColor(208),
    LogLevel.Error: AnsiColor(009),
    LogLevel.Fatal: AnsiColor(160)
  };
  static const String _divider = '─────────────────────────────────────────────────────────';
  static const String _logName = 'LOG';
  static final JsonEncoder _encoder = JsonEncoder.withIndent('     ');
  static final AnsiColor _jsonColor = AnsiColor(168);

  @override
  void write(LogEvent event) {
    var logLevelName = event.level.getName();
    var currentTime = DateTime.now();

    var date = "${currentTime.day.toString().padLeft(2, '0')}/${currentTime.month.toString().padLeft(2, '0')}/${currentTime.year.toString().padLeft(2, '0')}";
    var message = '[$date] [$logLevelName] ${event.message}${event.error != null ? '. ' : ''}';
    message = _levelColors[event.level](message);
    var shouldDivide = event.error != null || event.data != null;

    var lines = <String>[];

    if(shouldDivide) {
      lines.add('$_divider');
    }

    if(event.error != null) {
      message += _levelColors[LogLevel.Error](event.error.toString());
    }

    lines.add(message);

    if(event.data != null) {
      lines.add(_jsonColor('DATA:'));
      lines.add(_jsonColor('${_encoder.convert(event.data)}'));
    }

    if(event.error != null){
      if(event.stackTrace != null) {
        lines.add(_levelColors[LogLevel.Warning](event.stackTrace.toString()));
      }
    }

    if(shouldDivide) {
      lines.add(_divider);
    }

    _log(lines);
  }

  void _log(List<String> lines) {
    if(_usePrint) {
      lines.forEach(print);
    } else {
      lines.forEach((line) => developer.log(line, name: _logName));
    }
  }
}