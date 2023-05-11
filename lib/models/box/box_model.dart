class BoxModel {
  double sizeH;
  double sizeW;

  ///coordinate of x
  int indexOfColumn;

  ///coordinate of y
  int indexOfRow;
  String value;
  BoxType boxType;

  BoxModel({
    this.sizeH = 50.0,
    this.sizeW = 50.0,
    required this.indexOfColumn,
    required this.indexOfRow,
    this.value = '',
    this.boxType = BoxType.empty,
  });

  ///returns boxModel.indexOfColumn == this.indexOfColumn && boxModel.indexOfRow == this.indexOfRow
  bool isPositionSame(BoxModel boxModel) => boxModel.indexOfColumn == indexOfColumn && boxModel.indexOfRow == indexOfRow;
  bool get isEmpty => boxType == BoxType.empty;
  bool get isFilled => !isEmpty;
}

enum BoxType {
  number,
  result,
  arithmeticOperator,
  equalMark,
  empty,
}

extension BoxTypeExtension on BoxType {
  bool isEqual(BoxType boxType) {
    switch (this) {
      case BoxType.number:
      case BoxType.result:
        return boxType == BoxType.number || boxType == BoxType.result;
      case BoxType.arithmeticOperator:
      case BoxType.equalMark:
      case BoxType.empty:
        return boxType == this;
    }
  }
}
