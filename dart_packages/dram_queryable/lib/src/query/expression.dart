part of 'queryable_model.dart';

abstract class Expression {
  final String? fieldName;
  const Expression(this.fieldName);
}

class SelectableExpression<TModel, TQueryable extends QueryableModel<TModel>> extends Expression {

  final TQueryable _queryableModel;
  final Database _database;
  
  const SelectableExpression(this._queryableModel, this._database) : super(null);

  Database where(Expression Function(TQueryable queryable) expression) {
    var builtExpression = expression(_queryableModel);
    return _database;
  }

  Database whereM(Iterable<TModel> Function(TQueryable queryable) expressions) {
    return _database;
  }
}