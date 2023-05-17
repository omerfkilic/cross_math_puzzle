import 'package:cross_math_puzzle/models/game_box_coordination_model.dart';
import 'package:cross_math_puzzle/helper/enums.dart';
import 'package:flutter/material.dart';

class CConsts {
  CConsts._();
  static int gameTableColumnIndexSize = 15;
  static int gameTableRowIndexSize = 15;

  ///default easy
  static GameDifficult gameDifficult = GameDifficult.easy;

  ///2 second
  static Duration addOperationTimeOutDuration = const Duration(seconds: -2);

  ///5 second
  static Duration fillGameBoxesTimeOutDuration = const Duration(seconds: -5);

  /// mathOperation number boxes value limit
  static int operationBoxNumberLimit = 25;

  static bool isOperationNumberIncludeZero = false;

  static GameBoxCoordination firstOperationStartCoordination = GameBoxCoordination(indexOfColumn: 0, indexOfRow: 0);

  static Size gameTableBoxSize = const Size(44, 44);
}
