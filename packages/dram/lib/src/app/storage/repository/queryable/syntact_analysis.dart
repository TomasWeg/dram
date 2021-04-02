import 'package:dram/app.dart';
import 'package:dram/src/extensions/queryable_extensions.dart';

abstract class IQueryableSyntacticAnalyzer {

  const IQueryableSyntacticAnalyzer();
  static const IQueryableSyntacticAnalyzer instance = _IQueryableSyntactAnalyzerImpl();

  void analyze<T>(IQueryable<T> query, {bool useRealOperators});
}

class _IQueryableSyntactAnalyzerImpl extends IQueryableSyntacticAnalyzer {
  
  const _IQueryableSyntactAnalyzerImpl();
  
  @override
  void analyze<T>(IQueryable<T> query, {bool useRealOperators = false}) {

    print("Analyzing query on type ${query.type}");

    List<BaseWhere> whereStatements = query.getWhereStatements();

    print("Where statements: ${whereStatements.length}");

    print("Analyzing where statements:");
    for(BaseWhere where in whereStatements) {
      print("Type: ${where.runtimeType.toString()}");
      print("\t${_downtreeWhere(where)}");
      print("\tIs required: ${where.isRequired}");
    }

    print("Printing complete interpreted where:");
    print(_completeWhere(whereStatements));
  }

  String _downtreeWhere(BaseWhere where) {
    if(where is WhereConcat) {
      return where.conditions.map((e) => "${_downtreeWhere(e)}").join(' || ');
    } else {
      return "${where.fieldName} ${where.compareOperator.getOperator()} ${where.value} (required: ${where.isRequired})";
    }
  }

  String _completeWhere(List<BaseWhere> whereList) {
    StringBuffer buffer = StringBuffer();

    BaseWhere? lastWhere;
    for(int i = 0; i < whereList.length; i++) {
      BaseWhere where = whereList[i];
      String field = where.fieldName;
      dynamic value = where.value;
      Operator compareOperator = where.compareOperator;
      bool isRequired = where.isRequired;

      if(lastWhere == null) {

      }

      lastWhere = where;
    }

    return buffer.toString();
  }



}