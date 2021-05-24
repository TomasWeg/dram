import '../query/query.dart';

abstract class DatabaseTableField<TDartType> extends Queryable {
  final String fieldName;

  const DatabaseTableField(this.fieldName);
}

abstract class NumericTableField<TNum extends num> extends DatabaseTableField<TNum> {
  const NumericTableField(String fieldName) : super(fieldName);
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
}

class DateTimeTableField extends DatabaseTableField<DateTime> {
  const DateTimeTableField(String fieldName) : super(fieldName);
}