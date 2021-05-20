extension IterableExtensions<T> on Iterable<T> {

  Iterable<T> sortBy(dynamic Function(T) selector) {
    return toList()..sort((a, b) => selector(a!).compareTo(selector(b!)));
  }

  Iterable<T> sortByDescending(dynamic Function(T) selector) {
    return sortBy(selector).toList().reversed;
  }
}