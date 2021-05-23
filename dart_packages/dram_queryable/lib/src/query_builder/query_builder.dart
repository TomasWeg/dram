import 'package:dram_queryable/dram_queryable.dart';

part 'query_property.dart';
part 'query_model.dart';

class QueryBuilder<Model, T extends QueryModel<Model>> {
  void where(Function(T model) func) {
    
  }
}