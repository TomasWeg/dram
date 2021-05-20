abstract class BaseWhere {
  final String fieldName;
  final dynamic value;
  final Operator compareOperator;
  final bool isRequired; // If true, the query must evaluate to true to be valid (AND), otherwise (OR).

  const BaseWhere(this.fieldName, this.value, this.compareOperator, this.isRequired);

  BaseWhere copyWith({bool? isRequired, Operator? compareOperator, dynamic value});
}

class Where extends BaseWhere {
  const Where(String fieldName, {dynamic value, Operator compareOperator = Operator.equal, bool isRequired = true}) : super(fieldName, value, compareOperator, isRequired);

  @override
  BaseWhere copyWith({bool? isRequired, Operator? compareOperator, dynamic value}) {
    return Where(fieldName, isRequired: isRequired ?? this.isRequired, compareOperator: compareOperator ?? this.compareOperator, value: value ?? this.value);
  }
}

class WhereConcat extends BaseWhere {
  final List<BaseWhere> children;

  const WhereConcat(this.children, {dynamic value, bool isRequired = true}) : super('', value, Operator.equal, isRequired);

  @override
  BaseWhere copyWith({bool? isRequired, Operator? compareOperator, value}) {
    return WhereConcat(children, isRequired: isRequired ?? this.isRequired, value: value ?? this.value);
  }
}

class Not extends BaseWhere {
  final BaseWhere child;
  const Not(this.child, {bool isRequired = true}) : super('', null, Operator.equal, isRequired);

  @override
  BaseWhere copyWith({bool? isRequired, Operator? compareOperator, value}) {
    return Not(child);
  }
}

class Or extends Where {
  Or(String fieldName) : super(fieldName, isRequired: false);
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