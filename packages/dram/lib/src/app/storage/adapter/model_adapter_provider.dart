import 'package:dram/logger.dart';
import 'package:dram/src/app/storage/adapter/model_adapter.dart';
import 'package:dram/src/exception/adapter_not_found.dart';

/// Points a [Provider] to the [Model]' [Adapter]. 
abstract class ModelAdapterProvider {

  static ModelAdapterProvider? _defaultInstance;

  // static ModelAdapterProvider _defaultInstance;
  final Map<Type, ModelAdapter> _adapters;
 
  ModelAdapterProvider._(Map<Type, ModelAdapter> adapters) : _adapters = adapters {
    Logger.trace("Creating a model adapter provider with ${adapters.length} adapters...");
    _defaultInstance = this;
  }

  factory ModelAdapterProvider() {
    assert(_defaultInstance != null, "defaultInstance has not been initialized.");
    return _defaultInstance!;
  }

  /// Returns the [T] model [Adapter], if any.
  ModelAdapter<T> adapterFor<T>() {
    var adapter = _adapters[T];
    if(adapter == null) {
      throw new AdapterNotFoundException(T);
    }

    return adapter as ModelAdapter<T>;
  }
}

class DefaultModelAdapterProvider extends ModelAdapterProvider {
  DefaultModelAdapterProvider(Map<Type, ModelAdapter> adapters) : super._(adapters);
}