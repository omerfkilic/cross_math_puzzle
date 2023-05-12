import 'dart:math';

import 'package:cross_math_puzzle/helper/enums.dart';
import 'package:cross_math_puzzle/models/box_model.dart';
import 'package:flutter/material.dart';

class MathOperationModel {
  final List<BoxModel> boxes = [];
  final Axis operationDirection;

  ///returns if all boxes filled
  bool get areBoxesFilled => boxes.every((element) => element.hasValue);

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
  //TODO Bu fonksiyon için daha mantıklı bir şey düşün
  //Bu işlem için bir method yaratmak çok mantıklı değil gibi düşün bunu!
  BoxModel getBoxModelForCreateANewOperation() {
    switch (Random().nextInt(5)) {
      case 0:
        return boxes[0];
      case 1:
      case 2:
        return boxes[2];
      default:
        return boxes[4];
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
