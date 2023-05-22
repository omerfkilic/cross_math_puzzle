import 'package:cross_math_puzzle/components/functions.dart';
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
}

extension MathOperationModelExtension on MathOperationModel {
  //TODO Bu method'u daha sonra kaldırmamız lazım! Yada değil düşün bunu!
  //Ayarlar kısmına zorluk ayarı olarak ekleyebiliriz belki
  //TODO Bu fonksiyonu bağlı olduğu diğer operation'ları da kontrol edecek hale getir

  ///if all `numberBoxes` are `hidden` except [exceptedList] has
  bool isAllNumberBoxesHidden({List<GameBox> exceptedList = const []}) => numberBoxes.every(
        (numberBox) => (exceptedList.any((GameBox gameBox) => gameBox == numberBox) || numberBox.isHidden),
      );

  //TODO bu yapıyı düşün!

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
