import 'dart:math';

import 'package:cross_math_puzzle/helper/enums.dart';

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

extension GameDifficultExtension on GameDifficult {
  ///easy 0.4
  ///
  ///medium 0.65
  ///
  ///hard 0.825
  double get hiddenCountDivider {
    switch (this) {
      case GameDifficult.easy:
        return 0.4;
      case GameDifficult.medium:
        return 0.65;
      case GameDifficult.hard:
        return 0.825;
    }
  }
}

extension ArithmeticOperatorTypesExtension on ArithmeticOperatorTypes {
  ArithmeticOperatorTypes get reverse {
    switch (this) {
      case ArithmeticOperatorTypes.addition:
        return ArithmeticOperatorTypes.subtraction;
      case ArithmeticOperatorTypes.subtraction:
        return ArithmeticOperatorTypes.addition;
    }
  }
}

extension BoxTypeExtension on BoxType {
  bool isEqual(BoxType boxType) => boxType == this;
}
