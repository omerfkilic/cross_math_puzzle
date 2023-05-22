import 'package:cross_math_puzzle/models/game_box_coordination_model.dart';
import 'package:cross_math_puzzle/helper/enums.dart';
import 'package:flutter/material.dart';

class CConsts {
  CConsts._();
  static int gameTableColumnIndexSize = 12;
  static int gameTableRowIndexSize = 12;

  ///default `medium`
  static GameDifficult gameDifficult = GameDifficult.medium;

  /// `1` second
  static Duration singleTimeOutDuration = const Duration(seconds: -1);

  /// `2` second
  static Duration doubleBoxesTimeOutDuration = const Duration(seconds: -2);

  /// `mathOperation`'s `numberBoxes` value limit
  ///
  /// default `25`
  static int operationBoxNumberLimit = 25;

  ///if `true` `numberBoxes` can be `0`
  ///
  ///default `false`
  static bool isOperationNumberIncludeZero = false;

  ///default `true`
  static bool canOperationsAllNumberBoxesHidden = true;

  static GameBoxCoordination firstOperationStartCoordination = GameBoxCoordination(indexOfColumn: 0, indexOfRow: 0);

  static Size gameTableBoxSize = const Size(44, 44);
}
