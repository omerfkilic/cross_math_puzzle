import 'package:cross_math_puzzle/models/box/box_model.dart';

class MathOperationModel {
  List<BoxModel> boxes = [];
  MathOperationModel({required int indexOfColumn, required int indexOfRow, required OperationDirection operationDirection}) {
    switch (operationDirection) {
      case OperationDirection.horizontal:
        for (var index = 0; index < 5; index++) {
          boxes.add(BoxModel(
            indexOfColumn: indexOfColumn + index,
            indexOfRow: indexOfRow,
            boxType: findBoxType(index),
            isFilled: true,
          ));
        }
        break;
      case OperationDirection.vertical:
        for (var index = 0; index < 5; index++) {
          boxes.add(BoxModel(
            indexOfColumn: indexOfColumn,
            indexOfRow: indexOfRow + index,
            boxType: findBoxType(index),
            isFilled: true,
          ));
        }
        break;
    }
  }
}

BoxType findBoxType(int index) {
  if (index == 1) {
    return BoxType.aritmeticOperator;
  } else if (index == 4) {
    return BoxType.equalMark;
  } else {
    return BoxType.number;
  }
}

enum OperationDirection {
  horizontal,
  vertical,
}
