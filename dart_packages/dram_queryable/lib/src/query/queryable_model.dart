
import 'package:dram_queryable/dram_queryable.dart';

part 'debug_print.dart';
part 'expression.dart';
part 'interpreter.dart';
part 'where.dart';

abstract class Queryable extends Expression {
  final String modelName;

  const Queryable(this.modelName) : super(modelName);
}

abstract class QueryableModel<TModel> extends Queryable {
  final List<Expression> _expressions = [];
  bool _nextRequired;

  QueryableModel(String name) : _nextRequired = true, super(name);
}

abstract class QueryableProperty<DartType, TModel, TQueryable extends QueryableModel<TModel>> extends Queryable {
  final TQueryable queryableModel;

  const QueryableProperty(String fieldName, this.queryableModel) : super(fieldName);

  Where<TModel, TQueryable> isEqualsTo(DartType other) {
    var where = Where<TModel, TQueryable>(modelName, value: other, operator: CompareOperator.equal, queryableModel: queryableModel, isRequired: queryableModel._nextRequired);
    queryableModel._expressions.add(where);
    return where;
  }

  Where<TModel, TQueryable> isNotEqualsTo(DartType other) {
    var where = Not<TModel, TQueryable>(Where(modelName, value: other, operator: CompareOperator.equal, queryableModel: queryableModel, isRequired: queryableModel._nextRequired));
    queryableModel._expressions.add(where);
    return where;
  }
}

abstract class NumQueryableProperty<NumericType extends num, TModel, TQueryable extends QueryableModel<TModel>> extends QueryableProperty<NumericType, TModel, TQueryable> {
  const NumQueryableProperty(String fieldName, TQueryable queryableModel) : super(fieldName, queryableModel);

  Where<TModel, TQueryable> isGreaterThan(NumericType other) {
    var where = Where<TModel, TQueryable>(modelName, value: other, operator: CompareOperator.greaterThan, queryableModel: queryableModel, isRequired: queryableModel._nextRequired);
    queryableModel._expressions.add(where);
    return where;
  }

  Where<TModel, TQueryable> isGreaterThanOrEqualsTo(NumericType other) {
    var where = Where<TModel, TQueryable>(modelName, value: other, operator: CompareOperator.greaterThanOrEquals, queryableModel: queryableModel, isRequired: queryableModel._nextRequired);
    queryableModel._expressions.add(where);
    return where;
  }
  
  Where<TModel, TQueryable> isLessThan(NumericType other) {
    var where = Where<TModel, TQueryable>(modelName, value: other, operator: CompareOperator.lessThan, queryableModel: queryableModel, isRequired: queryableModel._nextRequired);
    queryableModel._expressions.add(where);
    return where;
  }
  
  Where<TModel, TQueryable> isLessThanOrEqualsTo(NumericType other) {
    var where = Where<TModel, TQueryable>(modelName, value: other, operator: CompareOperator.lessThanOrEquals, queryableModel: queryableModel, isRequired: queryableModel._nextRequired);
    queryableModel._expressions.add(where);
    return where;
  }
}

class IntQueryableProperty<TModel, TQueryable extends QueryableModel<TModel>> extends NumQueryableProperty<int, TModel, TQueryable> {
  const IntQueryableProperty(String fieldName, TQueryable queryableModel) : super(fieldName, queryableModel);
}

class DoubleQueryableProperty<TModel, TQueryable extends QueryableModel<TModel>>  extends NumQueryableProperty<double, TModel, TQueryable> {
  const DoubleQueryableProperty(String fieldName, TQueryable queryableModel) : super(fieldName, queryableModel);
}

class BoolQueryableProperty<TModel, TQueryable extends QueryableModel<TModel>> extends QueryableProperty<bool, TModel, TQueryable> {
  const BoolQueryableProperty(String fieldName, TQueryable queryableModel) : super(fieldName, queryableModel);
}

class StringQueryableProperty<TModel, TQueryable extends QueryableModel<TModel>> extends QueryableProperty<String, TModel, TQueryable> {
  const StringQueryableProperty(String fieldName, TQueryable queryableModel) : super(fieldName, queryableModel);
}

class ListQueryableProperty<T, TModel, TQueryable extends QueryableModel<TModel>> extends QueryableProperty<List<T>, TModel, TQueryable> {
  const ListQueryableProperty(String fieldName, TQueryable queryableModel) : super(fieldName, queryableModel);

  Where<TModel, TQueryable> includes(T item) {
    var where = Where<TModel, TQueryable>(modelName, value: item, operator: CompareOperator.includes, queryableModel: queryableModel, isRequired: queryableModel._nextRequired);
    queryableModel._expressions.add(where);
    return where;
  }

  Where<TModel, TQueryable> excludes(T item) {
    var where = Not<TModel, TQueryable>(Where(modelName, value: item, operator: CompareOperator.greaterThan, queryableModel: queryableModel, isRequired: queryableModel._nextRequired));
    queryableModel._expressions.add(where);
    return where;
  }
}