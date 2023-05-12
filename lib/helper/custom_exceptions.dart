class AddOperationTimedOutException implements Exception {
  String message;
  AddOperationTimedOutException(this.message);
  @override
  String toString() {
    return "Exception: $message";
  }
}

class ThereIsNotAnyAvailableMathOperationToFillException implements Exception {
  String message;
  ThereIsNotAnyAvailableMathOperationToFillException(this.message);
  @override
  String toString() {
    return "Exception: $message";
  }
}
