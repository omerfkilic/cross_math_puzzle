import 'dart:developer' as developer;
import 'dart:math';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

import 'package:cross_math_puzzle/components/exceptions/custom_exceptions.dart';
import 'package:cross_math_puzzle/components/exceptions/timed_out_exceptions.dart';
import 'package:cross_math_puzzle/components/functions.dart';
import 'package:cross_math_puzzle/helper/consts.dart';
import 'package:cross_math_puzzle/helper/custom_extensions.dart';
import 'package:cross_math_puzzle/helper/enums.dart';
import 'package:cross_math_puzzle/models/game_box_coordination_model.dart';
import 'package:cross_math_puzzle/models/game_box_model.dart';
import 'package:cross_math_puzzle/models/math_operation_model.dart';

part 'game_page_view_model_extensions/game_table_extension.dart';
part 'game_page_view_model_extensions/add_operation_extension.dart';
part 'game_page_view_model_extensions/fill_operation_extension.dart';
part 'game_page_view_model_extensions/hide_un_hide_extension.dart';

class GamePageViewModel {
  GamePageViewModel._();
  static GamePageViewModel? _instant;
  static GamePageViewModel get instant => _instant ??= GamePageViewModel._();

  final List<List<GameBox>> gameTable = [];

  ///list of mathematical operations found in the game table
  final List<MathOperationModel> mathOperationsList = [];

//TODO Set<hiddenBoxes> yap
  final List<int> hiddenNumbers = [];
}
