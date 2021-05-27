part of '../query.dart';

class Limit extends Expression {

  final int count;

  const Limit(this.count) : super(fieldName: null);
}