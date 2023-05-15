import 'package:cross_math_puzzle/helper/enums.dart';
import 'package:cross_math_puzzle/models/math_operation_model.dart';
import 'package:flutter/material.dart';

class BoxModel {
  String? value;
  BoxType boxType;
  final Size size;
  final BoxCoordination coordination;
  List<MathOperationModel> connectedMathOperations = <MathOperationModel>[];
  BoxModel({
    this.size = const Size(44, 44),
    this.value,
    required this.coordination,
    this.boxType = BoxType.empty,
  });

  ///boxType == BoxType.empty
  bool get isEmpty => boxType == BoxType.empty;

  ///boxType != BoxType.empty
  bool get isNotEmpty => !isEmpty;

  bool get hasValue => !(value == null || value!.isEmpty);

  bool isSameCoordination(BoxModel boxModel) => coordination._isSameCoordination(boxModel.coordination);

  void deleteBoxValue() {
    value = '';
    boxType = BoxType.empty;
  }
}

class BoxCoordination {
  ///coordinate of x
  final int indexOfColumn;

  ///coordinate of y
  final int indexOfRow;
  BoxCoordination({
    required this.indexOfColumn,
    required this.indexOfRow,
  });

  ///returns boxCoordination.indexOfColumn == this.indexOfColumn && boxCoordination.indexOfRow == this.indexOfRow
  bool _isSameCoordination(BoxCoordination boxCoordination) =>
      boxCoordination.indexOfColumn == indexOfColumn && boxCoordination.indexOfRow == indexOfRow;
}
