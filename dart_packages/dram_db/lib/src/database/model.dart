import 'package:drambase/src/query/query.dart';

/// Represents a database model which is included in a table
/// but does not have its own. 
abstract class DatabaseModel<TDartType> extends Queryable {
  final String modelName;
  const DatabaseModel(this.modelName);

  Map<String, Object> toTable(TDartType model);
  TDartType fromTable(Map<String, Object> map);
}