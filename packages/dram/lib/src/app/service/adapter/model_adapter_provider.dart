import 'package:dram/logger.dart';
import 'package:dram/src/app/service/adapter/model_adapter.dart';
import 'package:dram/src/exception/adapter_not_found.dart';

/// Points a [ServiceSource] to the [Model]' [Adapter]. 
abstract class ModelAdapterProvider {

  static ModelAdapterProvider? _defaultInstance;

  // static ModelAdapterProvider _defaultInstance;
  final Map<Type, _ModelAdapterService> _adapters;
 
  ModelAdapterProvider._(Map<Type, _ModelAdapterService> adapters) : _adapters = adapters {
    Logger.trace("Creating a model adapter provider with ${adapters.length} adapters...");
    _defaultInstance = this;
  }

  factory ModelAdapterProvider() {
    assert(_defaultInstance != null, "defaultInstance has not been initialized.");
    return _defaultInstance!;
  }

  /// Returns the [TModel] model [Adapter] for the specified [TService], if any.
  ModelAdapter<TModel> adapterFor<TModel, TService>({bool defaultIfNotFound = false}) {
    var modelAdapterService = _adapters[TModel];
    if(modelAdapterService == null) {
      throw new AdapterNotFoundException(TModel);
    }

    var adapterService = modelAdapterService.serviceModelAdapter[TService];
    if(adapterService == null) {
      if(defaultIfNotFound) {
        return modelAdapterService.serviceModelAdapter.values.first as ModelAdapter<TModel>;
      } else {
        throw new AdapterNotFoundException(TModel, TService);
      }
    }

    return adapterService as ModelAdapter<TModel>;
  }
}

class DefaultModelAdapterProvider extends ModelAdapterProvider {
  DefaultModelAdapterProvider(Map<Type, ModelAdapterBuilder> adapters) : super._(adapters.map((modelType, adapterBuilder) => 
    MapEntry<Type, _ModelAdapterService>(modelType, _ModelAdapterService(modelType, adapterBuilder.adapters))
  ));
}

class _ModelAdapterService {
  final Type model;

  /// A map which uses as key the ServiceSource type and as value the ModelAdapter
  final Map<Type, ModelAdapter> serviceModelAdapter;

  _ModelAdapterService(this.model, this.serviceModelAdapter);
}