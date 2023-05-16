import 'package:cross_math_puzzle/helper/enums.dart';
import 'package:cross_math_puzzle/models/math_operation_model.dart';

class BoxModel {
  String? value;
  BoxType boxType;
  final BoxCoordination coordination;

  ///means botType is BoxType.number and box has value but hidden for game
  bool isHidden = false;
  Set<MathOperationModel> connectedMathOperations = <MathOperationModel>{};
  BoxModel({
    this.value,
    required this.coordination,
    this.boxType = BoxType.empty,
  });

  ///boxType == BoxType.empty
  bool get isEmpty => boxType == BoxType.empty;

  ///boxType != BoxType.empty
  bool get isNotEmpty => !isEmpty;

  bool get hasValue => !(value == null || value!.isEmpty);

  ///work if boxType == BoxType.number and hasValue
  ///
  ///Otherwise returns null
  int? get valueAsInt {
    if (boxType == BoxType.number) return int.tryParse(hasValue ? value! : '');
    return null;
  }

  bool isSameCoordination(BoxModel boxModel) => coordination._isSameCoordination(boxModel.coordination);

  void deleteBoxValue() {
    value = null;
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
