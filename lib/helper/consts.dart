import 'package:cross_math_puzzle/models/box_model.dart';
import 'package:flutter/material.dart';

class CConsts {
  CConsts._();
  static int gameTableColumnIndexSize = 15;
  static int gameTableRowIndexSize = 15;

  ///as second
  static int addOperationTimeOutDuration = 2;

  ///as second
  static int fillBoxesTimeOutDuration = 2;

  /// mathOperation number boxes value limit
  static int operationBoxNumberLimit = 25;

  static bool isOperationNumberIncludeZero = false;

  static BoxCoordination firstOperationStartCoordination = BoxCoordination(indexOfColumn: 0, indexOfRow: 0);

  static Size gameTableBoxSize = const Size(44, 44);
}
