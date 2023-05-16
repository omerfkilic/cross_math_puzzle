class AddOperationTimedOutException implements Exception {
  final String message;
  AddOperationTimedOutException(this.message);
  @override
  String toString() {
    return "Exception: $message";
  }
}

class FillBoxesTimedOutException implements Exception {
  final String message;
  FillBoxesTimedOutException(this.message);
  @override
  String toString() {
    return "Exception: $message";
  }
}

class HideNumbersTimedOutException implements Exception {
  final String message;
  HideNumbersTimedOutException(this.message);
  @override
  String toString() {
    return "Exception: $message";
  }
}

class OneOfTheOperationIsNotCorrectException implements Exception {
  final String message;
  OneOfTheOperationIsNotCorrectException(this.message);
  @override
  String toString() {
    return "Exception: $message";
  }
}

class ThereIsNotAnyAvailableMathOperationToFillException implements Exception {
  final String message;
  ThereIsNotAnyAvailableMathOperationToFillException(this.message);
  @override
  String toString() {
    return "Exception: $message";
  }
}
