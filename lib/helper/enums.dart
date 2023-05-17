enum BoxType {
  number,
  arithmeticOperator,
  equalMark,
  empty,
}

enum ArithmeticOperatorTypes {
  ///'+'
  addition,

  ///'-'
  subtraction,

  ///'*'
  // multiplication,
  ///'/'
  // division,
  ;

  @override
  String toString() {
    switch (this) {
      case ArithmeticOperatorTypes.addition:
        return '+';
      case ArithmeticOperatorTypes.subtraction:
        return '-';
      // case ArithmeticOperatorTypes.multiplication:
      //   return '*';
      // case ArithmeticOperatorTypes.division:
      //   return '/';
    }
  }

  static ArithmeticOperatorTypes fromString(String value) {
    switch (value) {
      case '+':
        return ArithmeticOperatorTypes.addition;
      case '-':
        return ArithmeticOperatorTypes.subtraction;
      // case '*':
      //   ArithmeticOperatorTypes.multiplication;
      //   break;
      // case '/':
      //   ArithmeticOperatorTypes.division;
      //   break;
    }
    throw Exception();
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

enum GameDifficult {
  easy,
  medium,
  hard,
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
