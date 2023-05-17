import 'package:cross_math_puzzle/helper/enums.dart';
import 'package:cross_math_puzzle/models/box_model.dart';
import 'package:flutter/material.dart';

class MathOperationModel {
  final List<BoxModel> boxes = [];
  final Axis operationDirection;

  ///returns if all boxes filled
  bool get areBoxesFilled => boxes.every((element) => element.hasValue);
  List<BoxModel> get numberBoxes => [boxes[0], boxes[2], boxes[4]];

  BoxModel get operatorBox => boxes[1];

  MathOperationModel({
    required int indexOfColumn,
    required int indexOfRow,
    required this.operationDirection,
  }) {
    switch (operationDirection) {
      case Axis.vertical:
        for (var index = 0; index < 5; index++) {
          boxes.add(BoxModel(
            coordination: BoxCoordination(indexOfColumn: indexOfColumn + index, indexOfRow: indexOfRow),
            boxType: _findBoxType(index),
          ));
        }
        break;
      case Axis.horizontal:
        for (var index = 0; index < 5; index++) {
          boxes.add(BoxModel(
            coordination: BoxCoordination(indexOfColumn: indexOfColumn, indexOfRow: indexOfRow + index),
            boxType: _findBoxType(index),
          ));
        }
        break;
    }
  }

  ///if all numberBoxes are hidden except exceptedList has
  bool isAllNumberBoxesHidden([List<BoxModel> exceptedList = const []]) => numberBoxes.every(
        (numberBox) => (exceptedList.any((box) => box == numberBox) || numberBox.isHidden),
      );

  //TODO bu yapıyı düşün!
  ///if this.areBoxesFilled == false returns false
  ///
  ///checks is result of the transaction correct
  bool get isOperationResultCorrect {
    if (!areBoxesFilled) {
      return false;
    }
    return isOperationCorrect(
      firstNumber: int.tryParse(boxes[0].value!)!,
      secondNumber: int.tryParse(boxes[2].value!)!,
      result: int.tryParse(boxes[4].value!)!,
      arithmeticOperator: ArithmeticOperatorTypes.fromString(operatorBox.value!),
    );
  }

  String get getInfo => '(${boxes.first.coordination.indexOfColumn}, ${boxes.first.coordination.indexOfRow} , ${operationDirection.name})';

  void deleteOperationValues() {
    for (BoxModel box in boxes) {
      box.deleteBoxValue();
    }
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
