/// An adapter is a factory that converts data to/from a provider.
abstract class ModelAdapter<TModel> {
  const ModelAdapter();

  /// Converts the data to the provider.
  /// In most use cases, the return data will be a [Map<String, dynamic>]
  dynamic toProvider(TModel model);

  /// Converts the data from the provider.
  /// In most use cases, [data] will be a [Map<String, dynamic>]
  TModel fromProvider(dynamic data);
}