/// Represents a [Drambase] table.
abstract class DatabaseTable<TModel> {
  final String tableName;

  DatabaseTable(this.tableName);
}