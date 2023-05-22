import 'package:cross_math_puzzle/components/functions.dart';
import 'package:cross_math_puzzle/helper/consts.dart';
import 'package:cross_math_puzzle/helper/enums.dart';
import 'package:cross_math_puzzle/models/game_box_model.dart';
import 'package:cross_math_puzzle/models/game_box_coordination_model.dart';
import 'package:flutter/material.dart';

class MathOperationModel {
  final List<GameBox> gameBoxes = [];
  final Axis operationDirection;

  ///returns if all `gameBoxes` are `filled`
  bool get areGameBoxesFilled => gameBoxes.every((element) => element.hasValue);
  List<GameBox> get numberBoxes => [gameBoxes[0], gameBoxes[2], gameBoxes[4]];
  //TODO firstNumberBox, secondNumberBox falan ekle
  GameBox get operatorBox => gameBoxes[1];

  MathOperationModel({
    required int indexOfColumn,
    required int indexOfRow,
    required this.operationDirection,
  }) {
    switch (operationDirection) {
      case Axis.vertical:
        for (var index = 0; index < 5; index++) {
          gameBoxes.add(GameBox(
            coordination: GameBoxCoordination(indexOfColumn: indexOfColumn + index, indexOfRow: indexOfRow),
            boxType: _findBoxType(index),
          ));
        }
        break;
      case Axis.horizontal:
        for (var index = 0; index < 5; index++) {
          gameBoxes.add(GameBox(
            coordination: GameBoxCoordination(indexOfColumn: indexOfColumn, indexOfRow: indexOfRow + index),
            boxType: _findBoxType(index),
          ));
        }
        break;
    }
  }
  @override
  String toString() =>
      '$getInfo ${gameBoxes[0].value ?? 'x'} ${gameBoxes[1].value ?? '±'} ${gameBoxes[2].value ?? 'y'} ${gameBoxes[3].value ?? '='} ${gameBoxes[4].value ?? 'res'}';
}

extension MathOperationModelExtension on MathOperationModel {
  //TODO Bunu box'ın içinde kontrol edebiliriz
  //Bu şekilde connectedOperations'a erişimimiz olur

  //Fonksiyonun ismi allOtherBoxesHidden falan olabilir
  ///if all `numberBoxes` are `hidden` except [exceptedList] elements
  ///
  ///if [CConsts.canOperationsAllNumberBoxesHidden] `false` returns `false`
  bool areAllNumberBoxesHidden({List<GameBox> exceptedList = const []}) {
    if (!CConsts.canOperationsAllNumberBoxesHidden) {
      return false;
    }
    return numberBoxes.every(
      (numberBox) => (exceptedList.any((GameBox gameBox) => gameBox == numberBox) || numberBox.isHidden),
    );
  }

  bool get hasAnyHiddenNumber => numberBoxes.any((GameBox gameBox) => gameBox.isHidden);

  ///if `areGameBoxesFilled` is `false` returns `false`
  ///
  ///checks, result of the transaction is `correct`
  bool get isOperationResultCorrect {
    if (!areGameBoxesFilled) {
      return false;
    }
    return isTransactionCorrect(
      firstNumber: int.tryParse(gameBoxes[0].value!)!,
      secondNumber: int.tryParse(gameBoxes[2].value!)!,
      result: int.tryParse(gameBoxes[4].value!)!,
      arithmeticOperator: ArithmeticOperatorTypes.fromString(operatorBox.value!),
    );
  }

  String get getInfo => '(${gameBoxes.first.coordination.indexOfColumn}, ${gameBoxes.first.coordination.indexOfRow} , ${operationDirection.name})';

  void deleteOperationValues() {
    for (GameBox gameBox in gameBoxes) {
      gameBox.deleteBoxValue();
    }
  }

  BoxType _findBoxType(int index) {
    if (index == 1) {
      return BoxType.arithmeticOperator;
    } else if (index == 3) {
      return BoxType.equalMark;
    } else {
      return BoxType.number;
    }
  }
}
