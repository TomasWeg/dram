import 'package:dram/app.dart';
import 'package:dram/src/app/storage/repository/query/order.dart';

import 'limit.dart';

/// An interface to query data from data providers
class Query {
  final List<BaseWhere>? where;
  final List<Order>? order;
  final Limit? limit;

  Query({this.where, this.order, this.limit});

  factory Query.where(String fieldName, dynamic value, {Operator? compareOperator}) {
    compareOperator ??= Operator.equal;
    return Query(
      where: [Where(fieldName, value: value, compareOperator: compareOperator)],
    );
  }
}