class BoxModel {
  bool isFilled;
  int sizeH;
  int sizeW;
  int indexOfColumn;
  int indexOfRow;
  BoxType boxType;
  String value;

  BoxModel({
    this.sizeH = 40,
    this.sizeW = 40,
    required this.indexOfColumn,
    required this.indexOfRow,
    this.isFilled = false,
    this.value = '',
    this.boxType = BoxType.empty,
  });
}

enum BoxType {
  number,
  aritmeticOperator,
  equalMark,
  empty,
}
