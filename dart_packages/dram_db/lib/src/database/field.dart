import '../query/query.dart';

abstract class DatabaseTableField<TDartType> extends Queryable {
  final String fieldName;

  const DatabaseTableField(this.fieldName);

  Expression<TDartType> isEqualsTo(TDartType other) {
    return QueryExpression(fieldName: fieldName, operator: CompareOperator.equal, value: other);
  }

  Expression<TDartType> isNotEqualsTo(TDartType other) {
    return QueryExpression(fieldName: fieldName, operator: CompareOperator.notEqual, value: other);
  } 
}

abstract class NumericTableField<TNum extends num> extends DatabaseTableField<TNum> {
  const NumericTableField(String fieldName) : super(fieldName);

  Expression<TNum> isGreaterThan(TNum other) {
    return QueryExpression(fieldName: fieldName, operator: CompareOperator.greaterThan, value: other);
  }

  Expression<TNum> isGreaterThanOrEqualsTo(TNum other) {
    return QueryExpression(fieldName: fieldName, operator: CompareOperator.greaterThanOrEqualsTo, value: other);
  }

  Expression<TNum> isLessThan(TNum other) {
    return QueryExpression(fieldName: fieldName, operator: CompareOperator.lessThan, value: other);
  }

  Expression<TNum> isLessThanOrEqualsTo(TNum other) {
    return QueryExpression(fieldName: fieldName, operator: CompareOperator.lessThanOrEqualsTo, value: other);
  }
}

class IntTableField extends NumericTableField<int> {
  const IntTableField(String fieldName) : super(fieldName);
}

class DoubleTableField extends NumericTableField<double> {
  const DoubleTableField(String fieldName) : super(fieldName);
}

class StringTableField extends DatabaseTableField<String> {
  const StringTableField(String fieldName) : super(fieldName);
}

class BoolTableField extends DatabaseTableField<bool> {
  const BoolTableField(String fieldName) : super(fieldName);
}

class ListTableField<T> extends DatabaseTableField<List<T>> {
  const ListTableField(String fieldName) : super(fieldName);

  Expression<T> includes(T item) {
    return QueryExpression(fieldName: fieldName, operator: CompareOperator.includes, value: item);
  }

  Expression<T> excludes(T item) {
    return QueryExpression(fieldName: fieldName, operator: CompareOperator.excludes, value: item);
  }
}

class DateTimeTableField extends DatabaseTableField<DateTime> {
  const DateTimeTableField(String fieldName) : super(fieldName);

  Expression<int> isAfter(DateTime other) {
    return QueryExpression(fieldName: fieldName, operator: CompareOperator.greaterThan, value: other.millisecondsSinceEpoch);
  }

  Expression<int> isBefore(DateTime other) {
    return QueryExpression(fieldName: fieldName, operator: CompareOperator.lessThan, value: other.millisecondsSinceEpoch);
  }
}