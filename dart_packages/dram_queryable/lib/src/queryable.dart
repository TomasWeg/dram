import 'package:dram_queryable/src/exception/incomplete_query.dart';
import 'package:dram_queryable/src/exception/invalid_query.dart';
import 'package:dram_queryable/src/model/sort.dart';
import 'package:dram_queryable/src/model/where.dart';
import 'package:dram_queryable/src/extension/extensions.dart';

part 'parser/query_parser.dart';
part 'filtered_queryable.dart';
part 'sorted_queryable.dart';

abstract class IQueryable<T> {

  Type? _type;
  final List<BaseWhere> _where = [];
  final List<Sort> _sorting = [];

  BaseWhere? _currentWhere;
  bool _isSub = false;
  IQueryable<T>? _parent;

  /// The queryable model type
  Type get type {
    if(_type == null) {
      throw InvalidQueryException('Query is incomplete and missing of a type.');
    }

    return _type!;
  }

  IQueryable._(this._type);
  IQueryable._empty();

  static IQueryable<T> on<T>() {
    return _IQueryableImpl._(T);
  }

  IPropertyFilteredQueryable<T> where(String fieldName) {
    _whereCheck();
    _currentWhere = Where(fieldName);
    return _IPropertyFilteredQueryableImpl(this);
  }



  IQueryable<T> or(Function(IQueryable<T>) logic) {
    _whereCheck();
    IQueryable<T> query = _IPropertyFilteredQueryableImpl(this);
    _isSub = true;

    logic(query);

    // Create where concat with query where statements
    _where.add(WhereConcat(query._where, isRequired: false));
    
    _isSub = false;

    return this;
  }

  IQueryable<T> and(Function(IQueryable<T>) logic) {
    _whereCheck();
    IQueryable<T> query = _IPropertyFilteredQueryableImpl(this);
    _isSub = true;

    logic(query);
    _where.add(WhereConcat(query._where, isRequired: true));

    _isSub = false;
    return this;
  }

  void copyTo(IQueryable<T> other) {
    other._type = _type;
    other._currentWhere = _currentWhere;
    //other._where = _where;
    other._isSub = _isSub;
    other._parent = _parent;
  }

  /// Checks if there is a pending where that is incomplete
  void _whereCheck() {
    if(!_isSub && _currentWhere != null) {
      throw IncompleteQueryException('There is an uncomplete query at field "${_currentWhere?.fieldName}". Close it adding a comparison.');
    }
  }

  void _appendWhere({required Operator compareOperator, required bool isRequired, required dynamic value, required bool not}) {
    // Clone "where" with new values 
    _currentWhere = _currentWhere?.copyWith(
      compareOperator: compareOperator,
      isRequired: _currentWhere is Or ? null : isRequired,
      value: value
    );
    
    _where.add(not ? Not(_currentWhere!, isRequired: isRequired) : _currentWhere!);
    print('Where ${not ? '(not) ' : ''}comparison appended on field ${_currentWhere?.fieldName}.');
    _currentWhere = null;

    // if(_parent != null) {
    //   (_parent!._currentWhere as WhereConcat).children.add(_currentWhere!);
    //   _currentWhere = null;
    //   print('Added where to current WhereConcat');

    // } else {
    //   // Append
    //   _where.add(not ? Not(_currentWhere!, isRequired: isRequired) : _currentWhere!);
    //   print('Where ${not ? '(not) ' : ''}comparison appended on field ${_currentWhere?.fieldName}.');
    //   _currentWhere = null;
    // }
  }
}

class _IQueryableImpl<T> extends IQueryable<T> {
  _IQueryableImpl._(Type type) : super._(type);
}