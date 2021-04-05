import 'package:dram/src/app/storage/adapter/model_adapter_provider.dart';
import 'package:dram_queryable/dram_queryable.dart';
import 'package:sqflite/sqflite.dart';

class SqlQueryInterpreter extends BaseQueryInterpreter<Database> {
  @override
  Iterable<T> executeOn<T>(QueryDetails queryDetails, {Database? source}) {
    assert(source != null, 'Source must not be null on SqlQueryInterpreter.');

    var adapterProvider = ModelAdapterProvider();
    var modelAdapter = adapterProvider.adapterFor<T>();

    return <T>[];
  }

}