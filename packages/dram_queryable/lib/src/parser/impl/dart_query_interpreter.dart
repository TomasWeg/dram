import 'package:dram_queryable/src/parser/base_query_interpreter.dart';
import 'package:dram_queryable/src/queryable.dart';

class DartQueryInterpreter extends BaseQueryInterpreter<Iterable> {
  @override
  Iterable<T> executeOn<T>(QueryDetails queryDetails, {Iterable? source}) {
    // TODO: implement executeOn
    throw UnimplementedError();
  }

}