import '../query/query.dart';

abstract class DatabaseTableField<TDartType> extends Queryable {
  final String fieldName;

  const DatabaseTableField(this.fieldName);

  BooleanExpression<TDartType> isEqualsTo(TDartType other) {
    return BooleanExpression(fieldName: fieldName, operator: CompareOperator.equal, value: other);
  }

  BooleanExpression<TDartType> isNotEqualsTo(TDartType other) {
    return BooleanExpression(fieldName: fieldName, operator: CompareOperator.notEqual, value: other);
  } 
}

abstract class NumericTableField<TNum extends num> extends DatabaseTableField<TNum> {
  const NumericTableField(String fieldName) : super(fieldName);

  BooleanExpression<TNum> isGreaterThan(TNum other) {
    return BooleanExpression(fieldName: fieldName, operator: CompareOperator.greaterThan, value: other);
  }

  BooleanExpression<TNum> isGreaterThanOrEqualsTo(TNum other) {
    return BooleanExpression(fieldName: fieldName, operator: CompareOperator.greaterThanOrEqualsTo, value: other);
  }

  BooleanExpression<TNum> isLessThan(TNum other) {
    return BooleanExpression(fieldName: fieldName, operator: CompareOperator.lessThan, value: other);
  }

  BooleanExpression<TNum> isLessThanOrEqualsTo(TNum other) {
    return BooleanExpression(fieldName: fieldName, operator: CompareOperator.lessThanOrEqualsTo, value: other);
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

  BooleanExpression<T> includes(T item) {
    return BooleanExpression(fieldName: fieldName, operator: CompareOperator.includes, value: item);
  }

  BooleanExpression<T> excludes(T item) {
    return BooleanExpression(fieldName: fieldName, operator: CompareOperator.excludes, value: item);
  }
}

class DateTimeTableField extends DatabaseTableField<DateTime> {
  const DateTimeTableField(String fieldName) : super(fieldName);

  BooleanExpression<int> isAfter(DateTime other) {
    return BooleanExpression(fieldName: fieldName, operator: CompareOperator.greaterThan, value: other.millisecondsSinceEpoch);
  }

  BooleanExpression<int> isBefore(DateTime other) {
    return BooleanExpression(fieldName: fieldName, operator: CompareOperator.lessThan, value: other.millisecondsSinceEpoch);
  }
}