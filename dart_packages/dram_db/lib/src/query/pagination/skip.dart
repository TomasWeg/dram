part of '../query.dart';

class Skip extends Expression {

  final int count;

  const Skip(this.count) : super(fieldName: null);
}