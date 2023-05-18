abstract class CustomTimedOutException implements Exception {
  final String? message;
  CustomTimedOutException([this.message]);
  @override
  String toString() {
    return message ?? "Some Functions Timed Out";
  }
}

class AddOperationTimedOutException extends CustomTimedOutException {
  @override
  String? get message;

  AddOperationTimedOutException([super.message]);
  @override
  String toString() {
    return message ?? "Add Operation Function Timed Out!";
  }
}

class FillGameBoxesTimedOutException extends CustomTimedOutException {
  @override
  String? get message;

  FillGameBoxesTimedOutException([super.message]);
  @override
  String toString() {
    return message ?? "Fill Game Boxes Function Timed Out!";
  }
}

class HideNumbersTimedOutException extends CustomTimedOutException {
  @override
  String? get message;

  HideNumbersTimedOutException([super.message]);
  @override
  String toString() {
    return message ?? "Hide Numbers Function Timed Out!";
  }
}
