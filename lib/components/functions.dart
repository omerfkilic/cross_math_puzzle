import 'dart:math';

import 'package:cross_math_puzzle/helper/consts.dart';
import 'package:cross_math_puzzle/helper/enums.dart';

bool isOperationCorrect({
  required int firstNumber,
  required int secondNumber,
  required int result,
  required ArithmeticOperatorTypes arithmeticOperator,
}) {
  switch (arithmeticOperator) {
    case ArithmeticOperatorTypes.addition:
      return (firstNumber + secondNumber == result);

    case ArithmeticOperatorTypes.subtraction:
      return (firstNumber - secondNumber == result);
  }
}

Random _random = Random();

int getRandomInt(
  int max,
) {
  return _random.nextInt(max) + (CConsts.isOperationNumberIncludeZero ? 0 : 1);
}
