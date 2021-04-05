import 'package:dram/app.dart';
import 'package:dram_core/dram_core.dart';
import 'package:dram/src/app/storage/adapter/model_adapter_provider.dart';
import 'package:dram_queryable/dram_queryable.dart';
import 'package:sqflite/sqflite.dart';

class SqlQueryInterpreter extends BaseQueryInterpreter<Database> {

  final List<String> _statements = [];
  final List _values = [];
  final List<String> _where = [];

  @override
  Future<Iterable<T>> executeOn<T>(QueryDetails queryDetails, {Database? source}) async {
    assert(source != null, 'Source must not be null on SqlQueryInterpreter.');

    var adapterProvider = ModelAdapterProvider();
    var modelAdapter = adapterProvider.adapterFor<T>();

    String sql = _generateSql(queryDetails, modelAdapter);
    List<Map<String, Object?>> results = await source!.rawQuery(sql, _values);

    if(results.isEmpty || results.first.isEmpty) {
      return <T>[];
    }

    return results.map((row) => modelAdapter.fromProvider(row));
  }

  String _generateSql<T>(QueryDetails details, ModelAdapter<T> adapter) {

    _statements.clear();
    _values.clear();
    _where.clear();

    // Distinct is used to avoid duplicated data when using INNER JOIN
    final command = "SELECT DISTINCT `${adapter.collectionName}`.* FROM `${adapter.collectionName}`";
    _statements.add(command);

    details.whereStatements.forEach((condition) {
      final whereStatement = _expandWhere(condition, adapter.collectionName);
      if(whereStatement.isNotEmpty) {
        _where.add(whereStatement);
      }
    });

    if(_where.isNotEmpty) {
      _statements.add(_getWhereClause());
    }

    return _statements.join(' ').trim();
  }

  String _getWhereClause() {
    if(_where.isNotEmpty) {
      final cleanedWhere = _clearWhere(_where.join(''));
      return 'WHERE $cleanedWhere';
    }

    return '';
  }

  String _clearWhere(String statement) {
    return statement.replaceFirst(RegExp(r'^ (AND|OR)'), '')
    .replaceAll(RegExp(r' \( (AND|OR)'), ' (')
    .replaceAll(RegExp(r'\(\s+'), '(')
    .trim();
  }

  String _expandWhere(BaseWhere where, String tableName) {
    if(where is WhereConcat) {
      final conditions = where.children.fold<String>('', (previous, condition) {
        return previous + _expandWhere(condition, tableName);
      });

      if(conditions.isEmpty) {
        return '';
      }

      final matcher = where.isRequired ? 'AND' : 'OR';
      return ' $matcher ($conditions)';
    }

    if(where.value is Where) {
      return _expandWhere(where.value as Where, tableName);
    }

    final sqliteColumn = "`$tableName`.${where.fieldName}";
    final whereStatement = _WhereStatement(where, sqliteColumn);
    _values.add(whereStatement.values);
    return whereStatement.toString();
  }

  Tuple<String, List> generateSql<T>(QueryDetails details) {
    var adapterProvider = ModelAdapterProvider();
    var modelAdapter = adapterProvider.adapterFor<T>();
    return Tuple(_generateSql(details, modelAdapter), _values);
  }
}

class _WhereStatement {
  final BaseWhere where;
  final String columnName;
  final List values = [];
  String? _statement;

  String get matcher => where.isRequired ? 'AND' : 'OR';
  String get sign {
    if(where.value == null) {
      if(where.compareOperator == Operator.equal) return 'IS';
      if(where is Not) return 'IS NOT';
    }

    return operatorSign(where.compareOperator, where is Not);
  }

  _WhereStatement(this.where, this.columnName) {
    _statement = generateStatement();
  }

  String generateStatement() {
    if(where.value is Iterable) {
      if(where.compareOperator == Operator.between) {
        return generateBetween();
      }

      return generateIterable();
    }

    if(where.value == null) {
      return ' $matcher $columnName $sign NULL';
    } else {
      values.add(valueToSql(where.value, where.compareOperator));
    }

    return ' $matcher $columnName $sign ?';
  }

  String generateBetween() {
    if(where.value.length != 2) {
      throw new ArgumentError("${where.fieldName} expects two values to compare between. Given ${where.value}.");
    }

    values.add(where.value);
    return ' $matcher $columnName $sign ? AND ?';
  }

  String generateIterable() {
    final wherePrepend = [];
    where.value.forEach((conditionValue) {
      wherePrepend.add('$columnName $sign ?');
      values.add(valueToSql(conditionValue, where.compareOperator));
    });

    return ' $matcher ${wherePrepend.join(' $matcher ')}';
  }

  dynamic valueToSql(dynamic value, Operator compareOperator) {
    if(compareOperator == Operator.contains) {
      return "%$value%";
    }

    if(value == null) {
      return 'NULL';
    }

    return value;
  }

  static String operatorSign(Operator compareOperator, bool isNot) {
    if(isNot) {
      switch(compareOperator) {
        case Operator.equal:
          return "!=";

        case Operator.contains:
          return "NOT LIKE";

        default:
          throw ArgumentError("Not where expects  'equal' or 'contains' comparison operator. Given ${compareOperator.toString()}");
      }
    }
    switch(compareOperator) {
      case Operator.equal:
        return "=";
      case Operator.contains:
        return "LIKE";
      case Operator.greaterThan:
        return ">";
      case Operator.greaterThanOrEqualsTo:
        return ">=";
      case Operator.lessThan:
        return "<";
      case Operator.lessThan:
        return "<=";
      case Operator.between:
        return "BETWEEN";
      default:
        throw new UnimplementedError("Parsing ${compareOperator.toString()} to SQL not implemented.");
    }
  }

  @override
  String toString() => _statement ?? '';
}