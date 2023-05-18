import 'package:cross_math_puzzle/models/game_box_coordination_model.dart';
import 'package:cross_math_puzzle/helper/enums.dart';
import 'package:flutter/material.dart';

class CConsts {
  CConsts._();
  static int gameTableColumnIndexSize = 15;
  static int gameTableRowIndexSize = 15;

  ///default `easy`
  static GameDifficult gameDifficult = GameDifficult.easy;

//TODO daha genel bir isim bul
  /// `2` second
  static Duration addOperationTimeOutDuration = const Duration(seconds: -2);

  /// `5` second
  static Duration fillOperationBoxesTimeOutDuration = const Duration(seconds: -5);

  /// `mathOperation`'s `numberBoxes` value limit
  ///
  /// default `25`
  static int operationBoxNumberLimit = 25;

  static bool isOperationNumberIncludeZero = false;

  static GameBoxCoordination firstOperationStartCoordination = GameBoxCoordination(indexOfColumn: 0, indexOfRow: 0);

  static Size gameTableBoxSize = const Size(44, 44);
}
