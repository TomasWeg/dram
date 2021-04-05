class Sort {

  final SortingDirection direction;
  final String fieldName;

  const Sort(this.fieldName, {this.direction = SortingDirection.ascending}); 
}

enum SortingDirection {
  ascending,
  descending
}