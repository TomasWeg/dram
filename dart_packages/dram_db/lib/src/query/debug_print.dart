part of 'query.dart';

void debugPrint(Query query) {
  
  print('=================================');
  print('Printing query on table: ${query._table.runtimeType} (${query._table.tableName})');

  _printExpr(query._where, 0, false);
}

void tracePrint(Query query) {
  print('=================================');
  print('Printing trace query on table: ${query._table.runtimeType} (${query._table.tableName})');
  _printExpr(query._where, 0, true);
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
  } else if(expr is BinaryExpression) {
    _printBinary(expr, 0);
  }
}

void _printBinary(BinaryExpression expr, int deep, {bool tabFirst = true}) {
  var tab = List.filled(deep, '\t').join('');
  io.stdout.write('${tabFirst ? tab : ''}Binary expression: ${expr.sqlName}\n');
  io.stdout.writeln('$tab\t--> Left: ');
  if(expr.left is BooleanExpression) {
    io.stdout.write('${_sql(expr.left as BooleanExpression)}');
  } else {
    _printBinary(expr.left as BinaryExpression, deep+1);
  }

  io.stdout.write('$tab\t--> Right: ');
  if(expr.right is BooleanExpression) {
    io.stdout.write('${_sql(expr.right as BooleanExpression)}\n');
  } else {
    _printBinary(expr.right as BinaryExpression, deep+1, tabFirst: false);
  }
}