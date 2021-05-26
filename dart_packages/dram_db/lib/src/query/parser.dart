part of 'query.dart';

/// Converts the current query statement to an SQL statement
String toSql(Query query) {

  var _buffer = StringBuffer('SELECT * FROM ${query._table.tableName} WHERE ');

  // Filter expressions
  var whereExpressions = repairBoolean(query._where.whereType<BooleanExpression>());
  _writeWhereExpressions(_buffer, whereExpressions);

  _buffer.write(';');

  return _sanitize(_buffer.toString());
}

void _writeWhereExpressions(StringBuffer stringBuffer, List<BooleanExpression> exprs) {
  for(var expr in exprs) {
    _writeWhere(stringBuffer, expr);
    if(expr._children.isNotEmpty) {
      if(expr._required) {
        stringBuffer.write(' AND (');
      } else {
        stringBuffer.write(' OR (');
      }
      _writeWhereExpressions(stringBuffer, expr._children);
      stringBuffer.write(')');
    }

    if(expr._required) {
        stringBuffer.write(' AND ');
      } else {
        stringBuffer.write(' OR ');
      }
  }
}

String _sanitize(String sql) {
  sql = sql.replaceAll(' AND )', ')').replaceAll(' OR )', ')');

  return sql.replaceFirst(' AND ', '', sql.length - 6).replaceFirst(' OR ', '', sql.length - 6);
}

void _writeWhere(StringBuffer stringBuffer, BooleanExpression expr) {
  stringBuffer.write('${expr._fieldName} ${_sqlOperator(expr._operator)} ${_value(expr._value)}');
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