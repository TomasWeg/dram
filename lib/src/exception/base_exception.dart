abstract class BaseException implements Exception {
  final String message;

  BaseException({required this.message});

  @override
  String toString() {
    return this.message;
  }
}