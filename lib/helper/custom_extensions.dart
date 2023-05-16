import 'dart:math';

extension GetRandomElementFromListExtension<T> on List<T> {
  ///returns random element of list
  ///
  ///if list is empty return null
  T? get randomElement {
    if (isEmpty) {
      return null;
    }
    return this[Random().nextInt(length)];
  }
}
