part of 'query.dart';

/// Converts the current query statement to an SQL statement
String toSql(Query query) {

  var _buffer = StringBuffer('SELECT * FROM ${query._table.tableName} WHERE ');

  // Where expressions
  _writeWhereExpression(_buffer, query._where);
  _buffer.write(' ');

  // Order expressions
  if(query._sort.isNotEmpty) {
    _writeOrderExpression(_buffer, query._sort.entries.first.key, query._sort.entries.first.value);
    _buffer.write(' ');
  }

  // Write SKIP & LIMIT
  if(query._limit != null) {
    _buffer.write('LIMIT ${query._limit!.count}');
  }

  if(query._skip?.count != 0) {
    _buffer.write(' OFFSET ${query._skip!.count}');
  }

  _buffer.write(';');

  return _buffer.toString();
}

void _writeWhereExpression(StringBuffer buffer, Expression expression) {
  if(expression is BooleanExpression) {
    buffer.write(_sql(expression));
  } else if(expression is BinaryExpression) {
    buffer.write('('); // Maybe wrap this expression and allow the execution only if the expression is an OrExpression
    _writeWhereExpression(buffer, expression.left);
    buffer.write(expression.sqlName);
    _writeWhereExpression(buffer, expression.right);
    buffer.write(')');
  } else {
    throw Exception("Don't know how to handle ${expression.runtimeType} expression.");
  }
}

void _writeOrderExpression(StringBuffer buffer, DatabaseTableField field, SortDirection direction) {
  buffer.write('ORDER BY ');
  buffer.write('${field.fieldName} ');
  buffer.write(_direction(direction));
}

String _sql(BooleanExpression expr) {
  return '${expr._fieldName} ${_sqlOperator(expr._operator)} ${_value(expr._value)}';
}

dynamic _value(dynamic value) {
  if(value is String) {
    return '\'$value\'';
  } else if(value is List || value is Map) {
    return json.encode(value);
  } else {
    return value;
  }
}

const _sqlOperators = <CompareOperator, String>{
  CompareOperator.equal: '=',
  CompareOperator.notEqual: '!=',
  CompareOperator.greaterThan: '>',
  CompareOperator.greaterThanOrEqualsTo: '>=',
  CompareOperator.lessThan: '<',
  CompareOperator.lessThanOrEqualsTo: '<=',
  CompareOperator.includes: 'IN',
  CompareOperator.excludes: 'NOT IN',
};
String _sqlOperator(CompareOperator operator) {
  return _sqlOperators[operator]!;
}

const _sqlDirection = <SortDirection, String>{
  SortDirection.ascending: 'ASC',
  SortDirection.descending: 'DESC'
};
String _direction(SortDirection direction) {
  return _sqlDirection[direction]!;
}