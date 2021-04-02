import 'dart:convert';

/// Used to filter data while querying
abstract class BaseWhere {
  String get fieldName;
  Operator get compareOperator;
  dynamic get value;
  bool get isRequired;

  const BaseWhere();

  Map<String, dynamic> toJson() {
    return {
      "fieldName": this.fieldName,
      "value": this.value,
      "type": runtimeType.toString(),
      "operator": Operator.values.indexOf(this.compareOperator),
      "required": this.isRequired,
      // "children": children == null ? null : children?.map((e) => e.toJson()).toList().cast<Map<String, dynamic>>()
    };
  }

  @override
  String toString() => jsonEncode(toJson());

  BaseWhere copyWith({bool? isRequired}) {
    return Where(this.fieldName, value: this.value, compareOperator: this.compareOperator, isRequired: isRequired ?? this.isRequired);
  }
}

/// Represents a single filter operator
class Where extends BaseWhere {
  @override
  final Operator compareOperator;

  @override
  final String fieldName;

  @override
  final dynamic value;

  @override
  final bool isRequired;

  const Where(this.fieldName, {this.value, Operator? compareOperator, bool? isRequired}) : compareOperator = compareOperator ?? Operator.equal, isRequired = isRequired ?? true;

  factory Where.equals(String fieldName, dynamic value, {bool isRequired = true}) => Where(fieldName, value: value, compareOperator: Operator.equal, isRequired: isRequired);
  Where isExact(dynamic value) => Where(fieldName, value: value, compareOperator: Operator.equal, isRequired: isRequired);
  Where isBetween(dynamic first, dynamic second) {
    assert(first.runtimeType == second.runtimeType, "Comparison between two values must be the same type.");
    return Where(fieldName, value: [first, second], compareOperator: Operator.between, isRequired: isRequired);
  }
  Where contains(dynamic value) => Where(fieldName, value: value, compareOperator: Operator.contains, isRequired: isRequired);
  Where isLessThan(dynamic value) => Where(fieldName, value: value, compareOperator: Operator.lessThan, isRequired: isRequired);
  Where isLessThanOrEqualTo(dynamic value) => Where(fieldName, value: value, compareOperator: Operator.lessThanOrEqualTo, isRequired: isRequired);
  Where isGreaterThan(dynamic value) => Where(fieldName, value: value, compareOperator: Operator.greaterThan, isRequired: isRequired);
  Where isGreaterThanOrEqualTo(dynamic value) => Where(fieldName, value: value, compareOperator: Operator.greaterThanOrEqualTo, isRequired: isRequired);

  static List<BaseWhere> byField(String fieldName, List<BaseWhere>? conditions) {
    final flattenedConditions = <BaseWhere>[];

    void recurseConditions(BaseWhere condition) {
      if(condition is! WhereConcat || (condition is WhereConcat && condition.conditions.length <= 0)) {
        flattenedConditions.add(condition);
      } else {
        condition.conditions.forEach(recurseConditions);
      }
    }

    conditions?.forEach(recurseConditions);

    return flattenedConditions
      .where((element) => element.fieldName == fieldName)
      .toList();
  }

  static BaseWhere? firstByField(String fieldName, List<BaseWhere>? conditions) {
    final results = byField(fieldName, conditions);
    return results.isEmpty ? null : results.first;
  }
}

class WhereConcat extends BaseWhere {
  
  @override
  final String fieldName = '';

  @override
  final Operator compareOperator = Operator.equal;

  @override
  final dynamic value = null;

  @override
  final bool isRequired;

  final List<BaseWhere> conditions;

  const WhereConcat(this.conditions, {bool? isRequired}) : isRequired = isRequired ?? false; 
}

class And extends Where {
  const And(String fieldName) : super(fieldName);
}

class Or extends Where {
  const Or(String fieldName) : super(fieldName);
}

class Not extends Where {

  final Where child;

  const Not(this.child) : super("");
}

enum Operator {
  equal,
  between,
  contains,
  lessThan,
  lessThanOrEqualTo,
  greaterThan,
  greaterThanOrEqualTo,  
}