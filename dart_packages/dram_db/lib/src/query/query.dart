import 'package:drambase/src/database/table.dart';

part 'expression.dart';
part 'queryable.dart';
part 'query_expression.dart';

class Query<TModel, TTable extends DatabaseTable<TModel>> {

  Query._();

  static Query<TModel, TTable> on<TModel, TTable extends DatabaseTable<TModel>>(TTable Function(DatabaseTable<TModel> database) selector) {
    return Query._();   
  }  

}