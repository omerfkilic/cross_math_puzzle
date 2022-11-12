part of 'game_page_view.dart';

class _GamePageViewModel {
  List<List<BoxModel>> gameTable = [];
  void preapareGameTable({required int columnSize, required int rowSize}) {
    //Burası oyun ekranı açıldığında çalışacak ve oyun kutularını oluşturacak.
    for (var indexOfColumn = 0; indexOfColumn < columnSize; indexOfColumn++) {
      gameTable.add(
        List<BoxModel>.generate(
          rowSize,
          (indexOfRow) => BoxModel(
            indexOfColumn: indexOfColumn,
            indexOfRow: indexOfRow,
          ),
        ),
      );
    }
    if (kDebugMode) {
      print('Game Table preapared!!');
    }
  }

  void addOperation() {
    Random rnd = Random();
    while (true) {
      int columnIndex = rnd.nextInt(gameTable.length - 5);
      int rowIndex = rnd.nextInt(gameTable.first.length - 5);
      OperationDirection operationDirection = OperationDirection.values[rnd.nextInt(2)];
      MathOperationModel mathOperation = MathOperationModel(
        indexOfColumn: columnIndex,
        indexOfRow: rowIndex,
        operationDirection: operationDirection,
      );
      if (_isPosibleToAddOperation(
        columnIndex: columnIndex,
        rowIndex: rowIndex,
        operationDirection: operationDirection,
        mathOperation: mathOperation,
      )) {
        for (var index = 0; index < 5; index++) {
          switch (operationDirection) {
            case OperationDirection.horizontal:
              gameTable[columnIndex + index][rowIndex] = mathOperation.boxes[index];
              break;
            case OperationDirection.vertical:
              gameTable[columnIndex][rowIndex + index] = mathOperation.boxes[index];

              break;
          }
        }
        break;
      }
    }

    // MathOperationModel();
  }

  bool _isPosibleToAddOperation({
    required int columnIndex,
    required int rowIndex,
    required OperationDirection operationDirection,
    required MathOperationModel mathOperation,
  }) {
    switch (operationDirection) {
      case OperationDirection.horizontal:
        for (var index = 0; index < 5; index++) {
          if (gameTable[columnIndex + index][rowIndex].boxType != mathOperation.boxes[index].boxType &&
              gameTable[columnIndex + index][rowIndex].boxType != BoxType.empty) {
            return false;
          }
        }
        return true;
      case OperationDirection.vertical:
        for (var index = 0; index < 5; index++) {
          if (gameTable[columnIndex][rowIndex + index].boxType != mathOperation.boxes[index].boxType &&
              gameTable[columnIndex][rowIndex + index].boxType != BoxType.empty) {
            return false;
          }
        }
        return true;
    }
  }
}
