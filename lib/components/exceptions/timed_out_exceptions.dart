abstract class CustomTimedOutException implements Exception {
  final String message;
  CustomTimedOutException(this.message);
  @override
  String toString() {
    return "Exception: $message";
  }
}

//TODO message'ın kullanımını düzenle
class AddOperationTimedOutException extends CustomTimedOutException {
  @override
  String get message;

  AddOperationTimedOutException(super.message);
  @override
  String toString() {
    return "Add Operation Function Timed Out!";
  }
}

class FillGameBoxesTimedOutException extends CustomTimedOutException {
  @override
  String get message;

  FillGameBoxesTimedOutException(super.message);
  @override
  String toString() {
    return "Fill Game Boxes Function Timed Out!";
  }
}

class HideNumbersTimedOutException extends CustomTimedOutException {
  @override
  String get message;

  HideNumbersTimedOutException(super.message);
  @override
  String toString() {
    return "Hide Numbers Function Timed Out!";
  }
}
