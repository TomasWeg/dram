part of '../queryable.dart';

class QueryParser {
  QueryParser._();

  static QueryDetails parse<T>(IQueryable<T> query) {
    return QueryDetails._(query._where);
  }
}

class QueryDetails {
  static const String _prefix = '[DEBUG-QUERY]';
  
  late List<BaseWhere> _where;

  List<BaseWhere> get whereStatements => _where;

  QueryDetails._(List<BaseWhere> where) {
    _where = List.unmodifiable(where);
  }

  void debugPrint() {
    print('Where statements: ${whereStatements.length}');

    var tabPrefix = '';

    void downtree(BaseWhere baseWhere) {
      if(baseWhere is Where) {
        _print('$tabPrefix${baseWhere.fieldName} ${baseWhere.compareOperator.getOperator()} ${baseWhere.value} (required: ${baseWhere.isRequired})');
      } else if(baseWhere is Not) {
        _print('$tabPrefix${baseWhere.child.fieldName} NOT ${baseWhere.child.compareOperator.getOperator()} ${baseWhere.child.value} (required: ${baseWhere.child.isRequired})');
      } else if (baseWhere is WhereConcat) {
        tabPrefix += '\t';
        baseWhere.children.forEach((where) => downtree(where));
      }
    }

    for(var where in _where) {
      downtree(where);
    }
  }

  void _print(String message) {
    print('$_prefix $message');
  }
}