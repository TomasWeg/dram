abstract class BaseWhere {
  final String fieldName;
  final dynamic value;
  final Operator compareOperator;
  final bool isRequired; // If true, the query must evaluate to true to be valid (AND), otherwise (OR).

  const BaseWhere(this.fieldName, this.value, this.compareOperator, this.isRequired);
}

class Where extends BaseWhere {
  const Where(String fieldName, {dynamic value, Operator compareOperator = Operator.equal, bool isRequired = true}) : super(fieldName, value, compareOperator, isRequired);
}

class WhereConcat extends BaseWhere {
  final List<BaseWhere> children;

  const WhereConcat(String fieldName, dynamic value, bool isRequired, this.children) : super(fieldName, value, Operator.equal, isRequired);
}

class Not extends BaseWhere {
  final BaseWhere child;
  const Not(this.child) : super('', null, Operator.equal, false);
}

enum Operator {
  equal,
  greaterThan,
  greaterThanOrEqualsTo,
  lessThan,
  lessThanOrEqualsTo,
  between,
  contains,
  startsWith,
  endsWith
}