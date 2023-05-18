enum BoxType {
  number,
  arithmeticOperator,
  equalMark,
  empty,
}

enum ArithmeticOperatorTypes {
  /// `+`
  addition,

  /// `-`
  subtraction,

  /// `*`
  // multiplication,
  /// `/`
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
    //TODO custom exception yaz
    throw Exception();
  }
}

enum GameDifficult {
  easy,
  medium,
  hard,
}
