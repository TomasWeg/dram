import 'dart:convert';

import 'package:dram/app.dart';
import 'package:dram/src/app/storage/repository/query/limit.dart';
import 'package:dram/src/app/storage/repository/query/order.dart';

part 'filtered_queryable.dart';
part 'ordered_queryable.dart';

/// Base class to build a query
abstract class IQueryable<T> {
  
  Type? _type;
  bool? _requiredActivate = true; // This will turn OR and AND operators
  bool _buildingComplex = false;
  WhereConcat? _currentWhereConcat;

  /// Returns the query object type
  Type get type => this._type!;

  bool get isReady => _limit != null;

  List<BaseWhere>? _where;
  List<Order>? _order;
  Limit? _limit;

  IQueryable._(Type type) {
    this._type = type;
  }
  IQueryable();

  /// Starts a new query on a model
  static IQueryable<T> on<T>() => _QueryableImpl<T>(T);

  /// Starts a filter operation of [fieldName]
  IFilteredQueryable<T> where(String fieldName) {
    _buildingComplex = false;

    if(_currentWhereConcat != null) {
      this._where?.add(_currentWhereConcat!);
      _currentWhereConcat = null;
    }

    return _IFilteredQueryable<T>(this, fieldName);
  }

  IQueryable<T> whereC(Function(IComplexFilteredQueyable<T>) query) {
    _buildingComplex = true;
    _currentWhereConcat = WhereConcat([]);

    // Create query
    IComplexFilteredQueyable<T> filteredQueryable = _IComplexFilteredQueryable(this);
    
    // Execute query
    query(filteredQueryable);

    return this;
  } 

  /// Sort the results on the specified [fieldName] on an ascending order.
  _IOrderedQueryable<T> orderBy(String fieldName) {
    _appendOrder(fieldName, OrderDirection.Ascending);
    return _IOrderedQueryable<T>(this, fieldName);
  }

  /// Sort the results on the specified [fieldName] on an descending order.
  IOrderedQueryable<T> orderByDescending(String fieldName) {
    _appendOrder(fieldName, OrderDirection.Descending);
    return _IOrderedQueryable<T>(this, fieldName);
  }

  /// Limits the results to an specific [amount].
  IQueryable<T> limit(int amount) {
    _setLimit(Limit(0, amount));
    return this;
  }

  /// Paginates the result
  IQueryable<T> paginate(int page, int pageSize) {
    _setLimit(Limit((page - 1) * pageSize, pageSize));
    return this;
  }

  /// Limits the results to a single item
  IQueryable<T> single() {
    _setLimit(Limit(0, 1));
    return this;
  }

  IQueryable<T> _appendWhere(Where where) {
    if(this._where == null) {
      this._where = [];
    }

    if(this._requiredActivate != null && this._requiredActivate == false) {
      where = where.copyWith(isRequired: false) as Where;
    }

    if(_buildingComplex) {
      if(where.isRequired != this._requiredActivate) {
        where = where.copyWith(isRequired: this._requiredActivate) as Where;
      }

      // Get last added
      // BaseWhere? lastAdded; 
      // try { lastAdded = _currentWhereConcat!.conditions.last; } catch(_) { lastAdded = null; }

      // if(lastAdded != null && lastAdded.isRequired && !where.isRequired) {
      //   lastAdded = lastAdded.copyWith(isRequired: false);
      //   _currentWhereConcat!.conditions.removeLast();
      //   _currentWhereConcat!.conditions.add(lastAdded);
      // }

      _currentWhereConcat!.conditions.add(where);
    } else {
      this._where?.add(where);
    }

    return this;
  }

  IQueryable<T> _appendOrder(String fieldName, OrderDirection direction) {
    if(this._order == null) {
      this._order = [];
    }

    assert(!this._order!.any((element) => element.fieldName == fieldName), "Cannot create an order sentence over the same field.");

    this._order?.add(Order(fieldName, direction: direction));
    return this;
  }

  IQueryable<T> _setLimit(Limit limit) {
    assert(_limit == null, "Limit cannot be set twice.");
    this._limit = limit;

    if(this._currentWhereConcat != null) {
      this._where?.add(_currentWhereConcat!);
      _currentWhereConcat = null;
    }
    return this;
  }

  Map<String, dynamic> toJson() {
    return {
      "model": this.type.toString(),
      "whereStatements": this._where == null ? null : this._where!.map((e) => e.toJson()).toList().cast<Map<String, dynamic>>(),
      "orderStatements": this._order == null ? null : this._order!.map((e) => e.toJson()).toList().cast<Map<String, dynamic>>(),
      "limitStatement": this._limit?.toJson()
    };
  }

  void copyTo(IQueryable<T> target) {
    target._where = this._where;
    target._order = this._order;
    target._limit = this._limit;
    target._type = this._type;
    target._currentWhereConcat = this._currentWhereConcat;
    target._requiredActivate = this._requiredActivate;
    target._buildingComplex = this._buildingComplex;
  }

  @override
  String toString() => jsonEncode(toJson());

  List<BaseWhere> getWhereStatements() {
    return List.unmodifiable(this._where ?? const []);
  }
}

abstract class IWhereQueryable<T> extends IQueryable<T> {

  IWhereQueryable(IQueryable<T> parent) {
    parent.copyTo(this);
  }

  IFilteredQueryable<T> or(String fieldName);
  IFilteredQueryable<T> and(String fieldName);
}

class _WhereQueryableImpl<T> extends IWhereQueryable<T> {
  _WhereQueryableImpl(IQueryable<T> parent) : super(parent);

  IFilteredQueryable<T> or(String fieldName) {
    _requiredActivate = false;
    return _IFilteredQueryable(this, fieldName);
  }

  IFilteredQueryable<T> and(String fieldName) {
    _requiredActivate = true;
    return _IFilteredQueryable(this, fieldName);
  }
} 

class _QueryableImpl<T> extends IQueryable<T> {
  _QueryableImpl(Type type) : super._(type);
}