part of 'query.dart';

List<BooleanExpression> repairBoolean(Iterable<BooleanExpression> expressions) {
  var repaired = List<BooleanExpression>.from(expressions);

  for(var i = 0; i < expressions.length; i++) {
    var expr = expressions.elementAt(i);
    var children = expr._children;
    if(children.isNotEmpty) {
      if(!children.first._required) {
        var repairedChildren = children.first.copyWith(isRequired: true);
        children[0] = repairedChildren;
        repaired[i] = children.first._parent!.copyWith(isRequired: false, children: children);
      }

      // var repairedChildren = _repairChildren(children);
      // repaired[i] = expr.copyWith(children: repairedChildren);
    }
  }

  return repaired;
}

List<BooleanExpression> _repairChildren(List<BooleanExpression> children) {
  var repaired = <BooleanExpression>[];
  for(var i = 0; i < children.length; i++) {
    var child = children[i];
    if(!child._required && i != 0) {
      repaired.removeAt(i-1);
      repaired.insert(i-1, children[i-1].copyWith(isRequired: false));
    }

    repaired.add(child);
  }

  return repaired;
}