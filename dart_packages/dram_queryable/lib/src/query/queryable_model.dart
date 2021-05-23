abstract class Queryable {
  final String modelName;

  const Queryable(this.modelName);
}

abstract class QueryableModel<TModel> extends Queryable {
  const QueryableModel(String name) : super(name);
}

abstract class QueryableProperty<DartType> extends Queryable {
  const QueryableProperty(String fieldName) : super(fieldName);

  void isEqualsTo(DartType other) {

  }

  void isNotEqualsTo(DartType other) {

  }

  void and() {

  }

  void or() {
    
  }
}

abstract class NumQueryableProperty<NumericType extends num> extends QueryableProperty<NumericType> {
  const NumQueryableProperty(String fieldName) : super(fieldName);

  void isGreaterThan(NumericType other) {

  }

  void isGreaterThanOrEqualsTo(NumericType other) {

  }
  
  void isLessThan(NumericType other) {

  }
  
  void isLessThanOrEqualsTo(NumericType other) {

  }
}

class IntQueryableProperty extends NumQueryableProperty<int> {
  const IntQueryableProperty(String fieldName) : super(fieldName);
}

class DoubleQueryableProperty extends NumQueryableProperty<double> {
  const DoubleQueryableProperty(String fieldName) : super(fieldName);
}

class BoolQueryableProperty extends QueryableProperty<bool> {
  const BoolQueryableProperty(String fieldName) : super(fieldName);
}

class StringQueryableProperty extends QueryableProperty<String> {
  const StringQueryableProperty(String fieldName) : super(fieldName);
}

class ListQueryableProperty<T> extends QueryableProperty<List<T>> {
  const ListQueryableProperty(String fieldName) : super(fieldName);

  void includes(T item) {

  }

  void excludes(T item) {

  }
}