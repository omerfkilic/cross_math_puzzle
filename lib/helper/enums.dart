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
  // subtraction,
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
      // case ArithmeticOperatorTypes.subtraction:
      //   return '-';
      // case ArithmeticOperatorTypes.multiplication:
      //   return '*';
      // case ArithmeticOperatorTypes.division:
      //   return '/';
    }
  }

  static ArithmeticOperatorTypes fromString(String value) {
    switch (value) {
      case '+':
        ArithmeticOperatorTypes.addition;
        break;
      // case '-':
      //   ArithmeticOperatorTypes.subtraction;
      //   break;
      // case '*':
      //   ArithmeticOperatorTypes.multiplication;
      //   break;
      // case '/':
      //   ArithmeticOperatorTypes.division;
      //   break;
    }
    //TODO custom exception yaz yada farklı bir şeyler düşün
    throw Exception();
  }
}

extension BoxTypeExtension on BoxType {
  bool isEqual(BoxType boxType) => boxType == this;
}
