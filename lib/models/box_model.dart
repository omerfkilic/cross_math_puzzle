import 'package:cross_math_puzzle/helper/enums.dart';
import 'package:flutter/material.dart';

class BoxModel {
  Size size;

  String? value;
  BoxType boxType;
  BoxCoordination coordination;
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
}

class BoxCoordination {
  ///coordinate of x
  int indexOfColumn;

  ///coordinate of y
  int indexOfRow;
  BoxCoordination({
    required this.indexOfColumn,
    required this.indexOfRow,
  });

  ///returns boxCoordination.indexOfColumn == this.indexOfColumn && boxCoordination.indexOfRow == this.indexOfRow
  bool isSameCoordination(BoxCoordination boxCoordination) =>
      boxCoordination.indexOfColumn == indexOfColumn && boxCoordination.indexOfRow == indexOfRow;
}
