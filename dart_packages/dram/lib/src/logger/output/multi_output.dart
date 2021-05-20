

import 'package:dram/src/logger/base/log_event.dart';

import 'log_output.dart';

/// A [LogOutput] that writes a [LogEvent] to multiple [LogOutput]s 
class MultiLogOutput extends LogOutput {
  
  late List<LogOutput> _outputs;

  MultiLogOutput(List<LogOutput> outputs) {
    _outputs = outputs;
  }
  
  @override
  void write(LogEvent event) {
    for(var output in _outputs){
      output.write(event);
    }
  }
}