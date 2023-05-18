import 'package:cross_math_puzzle/helper/enums.dart';
import 'package:cross_math_puzzle/models/game_box_coordination_model.dart';
import 'package:cross_math_puzzle/models/math_operation_model.dart';

class GameBox {
  String? value;
  BoxType boxType;
  final GameBoxCoordination coordination;

  ///means `botType` is `BoxType.number` and `gameBox` has value but `hidden`
  bool isHidden = false;
  Set<MathOperationModel> connectedMathOperations = <MathOperationModel>{};
  GameBox({
    this.value,
    required this.coordination,
    this.boxType = BoxType.empty,
  });
}

extension GameBoxModelExtension on GameBox {
  ///`boxType` == `BoxType.empty`
  bool get isEmpty => boxType == BoxType.empty;

  ///`boxType` != `BoxType.empty`
  bool get isNotEmpty => !isEmpty;

  bool get hasValue => !(value == null || value!.isEmpty);

  ///work if `boxType` == `BoxType.number` and `hasValue`
  ///
  ///Otherwise returns `null`
  int? get valueAsInt {
    if (boxType == BoxType.number) return int.tryParse(hasValue ? value! : '');
    return null;
  }

  bool isSameCoordination(GameBox boxModel) => coordination.isSameCoordination(boxModel.coordination);

  void deleteBoxValue() {
    value = null;
    boxType = BoxType.empty;
  }
}
