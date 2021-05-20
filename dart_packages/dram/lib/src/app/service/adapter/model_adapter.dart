

/// An adapter is a factory that converts data to/from a provider.
/*abstract class ModelAdapter<TModel> {
  const ModelAdapter();

  /// The name of the collection. Defaults to [TModel] pluralized.
  /// This will be used, for example, as sqlite table name, moor collections, hive boxes, to json, etc.
  String get collectionName => "${TModel.toString().toLowerCase()}s";

  /// Converts the data to the provider.
  /// In most use cases, the return data will be a [Map<String, dynamic>]
  dynamic toProvider(TModel model);

  /// Converts the data from the provider.
  /// In most use cases, [data] will be a [Map<String, dynamic>]
  TModel fromProvider(dynamic data);
}*/

/// Model adapters maps functions to variable functions.
class ModelAdapter<TModel> {
  final dynamic Function(TModel model) toProvider;
  final TModel Function(dynamic data) fromProvider;
  final String name;

  ModelAdapter({required this.toProvider, required this.fromProvider, String? name}) : name = name ?? "${TModel.toString().toLowerCase()}s";
}

/// Model adapter builder helps organizing model adapters from different services
abstract class ModelAdapterBuilder<TModel> {

  /// The list of adapters for the specified model.
  /// The key must be a [ServiceSource] type.
  Map<Type, ModelAdapter<TModel>> get adapters;

}