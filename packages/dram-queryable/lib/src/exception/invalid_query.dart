class InvalidQueryException extends Exception {

  factory InvalidQueryException(String message) {
    return Exception(message) as InvalidQueryException;
  }

}