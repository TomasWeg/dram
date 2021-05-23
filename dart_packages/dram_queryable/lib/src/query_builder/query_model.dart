part of 'query_builder.dart';

abstract class QueryModel<T> extends BaseProperty {
  final List<BaseProperty> properties;

  QueryModel(List<BaseProperty> properties) : properties = List.unmodifiable(properties), super.empty();
}

class ModelProperty extends BaseProperty {
  ModelProperty(String name, List<BaseProperty> children) : super(name, children);
}