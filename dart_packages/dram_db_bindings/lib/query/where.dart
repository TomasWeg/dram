part of 'query.dart';

abstract class BaseWhere extends Statement {
  final Operator operator;
  final dynamic value;
  final bool isRequired;

  const BaseWhere(String fieldName, this.operator, this.value, this.isRequired) : super(fieldName);
}

class Where extends BaseWhere {
  const Where(String fieldName, {dynamic value, Operator operator = Operator.equal, bool isRequired = true}) : super(fieldName, operator, value, isRequired);
}

class WhereConcat extends BaseWhere {
  final List<BaseWhere> children;
  const WhereConcat(this.children, {dynamic value, bool isRequired = true}) : super('', Operator.equal, value, isRequired);
}

class Not extends BaseWhere {
  final BaseWhere child;
  const Not(this.child, {bool isRequired = true}) : super('', Operator.equal, null, isRequired);
}

class Or extends Where {
  Or(String fieldName) : super(fieldName, isRequired: false);
}