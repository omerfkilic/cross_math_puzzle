import 'package:cross_math_puzzle/models/box_model.dart';
import 'package:flutter/material.dart';

class CConsts {
  CConsts._();
  static int gameTableColumnIndexSize = 15;
  static int gameTableRowIndexSize = 15;

  ///2 second
  static Duration addOperationTimeOutDuration = const Duration(seconds: -2);

  ///5 second
  static Duration fillBoxesTimeOutDuration = const Duration(seconds: -5);

  /// mathOperation number boxes value limit
  static int operationBoxNumberLimit = 25;

  static bool isOperationNumberIncludeZero = false;

  static BoxCoordination firstOperationStartCoordination = BoxCoordination(indexOfColumn: 0, indexOfRow: 0);

  static Size gameTableBoxSize = const Size(44, 44);
}
