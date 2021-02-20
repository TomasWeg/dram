extension IterableExtensions<T> on Iterable<T> {

  /// Returns the first element that satisfies the given predicate [test].
  /// Otherwise, returns a [defaultValue] or null. 
  T firstOrDefault(bool Function(T) test, {T defaultValue}) {
    return this.firstWhere(test, orElse: () => defaultValue);
  }
}