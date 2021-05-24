part of 'queryable_model.dart';

List<Expression> refactor(List<Expression> expressions) {
  var refactored = <Where>[];
  for(var i = 0; i < (expressions.whereType<Where>()).length; i++) {
    var expr = expressions[i];
    if(expr is Where){

      if(!expr._required) {
        try {
          var previousExpr = refactored[i-1];
          if(previousExpr._required) {
            previousExpr = previousExpr.copyWith(isRequired: false);
            refactored.removeAt(i-1);
            refactored.insert(i-1, previousExpr);
          }
          
        } catch(_) {}
      }

      refactored.add(expr);

    } else {
      throw UnsupportedError('Cannot refactor ${expr.runtimeType} expression type.');
    }
  }

  return refactored;
}