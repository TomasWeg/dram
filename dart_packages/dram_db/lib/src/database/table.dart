import 'package:meta/meta.dart';

/// Represents a [Drambase] table.
abstract class DatabaseTable<TModel> {
  @protected
  final String tableName;

  DatabaseTable(this.tableName);
}