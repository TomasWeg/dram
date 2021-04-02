import 'dart:convert';
import 'dart:io';

import 'package:dram/logger.dart';

class FileOutput extends LogOutput {

  final File file;
  final Encoding encoding;
  IOSink? _sink;

  FileOutput({required this.file, this.encoding = utf8}) {
    this._sink = file.openWrite(
      mode: FileMode.writeOnlyAppend,
      encoding: encoding
    );
  }

  @override
  void write(LogEvent event) {
    String encoded = json.encode({
      "level": event.level,
      "message": event.message,
      "error": event.error,
      "stackTrace": event.stackTrace
    });

    this._sink?.writeln(encoded);
  }

}