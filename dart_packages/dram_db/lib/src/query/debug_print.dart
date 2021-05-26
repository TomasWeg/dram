part of 'query.dart';

void debugPrint(Query query) {
  
  print('=================================');
  print('Printing query on table: ${query._table.runtimeType} (${query._table.tableName})');

  _printExpressions(query._where, 0, false);
}

void tracePrint(Query query) {
  print('=================================');
  print('Printing trace query on table: ${query._table.runtimeType} (${query._table.tableName})');
  print('Expressions count: ${query._where.length}');
  
  var total = query._where.length;
  total += _totalCount(query._where);
  print('Total expression count: $total');

  _printExpressions(query._where, 0, true);
}

int _totalCount(Iterable<Expression> exprs) {
  var count = 0;
  for(var expr in exprs.whereType<BooleanExpression>()) {
    count += expr._children.length;
    count += _totalCount(expr._children);
  }

  return count;
}

void _printExpressions(Iterable<Expression> expressions, int deep, bool trace) {
  if(trace) {
    print('Found ${expressions.length} expressions in the first iteration. Deep: $deep');
  }
  for(var expr in expressions) {
    _printExpr(expr, deep, trace);
  }
}

void _printExpr(Expression expr, int deep, bool trace) {
  if(trace) {
    print('Printing expression ${expr.runtimeType} on deep $deep');
  }

  var tab = List.filled(deep, '\t').join('');
  if(expr is BooleanExpression) {
    print('${tab}Field: ${expr._fieldName} - Operator: ${expr._operator} - Value: ${expr._value} - Required: ${expr._required}');
    if(expr._children.isNotEmpty) {
      if(trace) {
        print('Expression children is not empty. Children count: ${expr._children.length}');
      }
      deep++;
      _printExpressions(expr._children, deep, trace);
    }
  }
}