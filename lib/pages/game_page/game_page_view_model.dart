part of 'game_page_view.dart';

class _GamePageViewModel {
  _GamePageViewModel._();
  static _GamePageViewModel? _instant;
  static _GamePageViewModel get instant => _instant ??= _GamePageViewModel._();

  ///as seconds
  final int timeoutDuration = 2;

  final List<List<BoxModel>> gameTable = [];

  ///list of mathematical operations found in the game table
  final List<MathOperationModel> mathOperationsList = [];

  ///This function prepares [gameTable]
  void prepareGameTable({required int columnSize, required int rowSize}) {
    for (int indexOfColumn = 0; indexOfColumn < columnSize; indexOfColumn++) {
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
    developer.log('gameTable Prepared', name: 'prepareGameTable');
  }

  void addOperation() {
    Random rnd = Random();
    //DateTime for check timeout
    DateTime startDateTime = DateTime.now();
    //this while will loop until it creates newMathOperation or timed out!
    while (true) {
      int columnIndex;
      int rowIndex;
      //if mathOperationsList is empty first mathOperation will start from (1, 1)
      try {
        if (mathOperationsList.isEmpty) {
          columnIndex = 0;
          rowIndex = 0;
        } else {
          BoxModel boxModel = mathOperationsList[rnd.nextInt(mathOperationsList.length)].getBoxModelForCreateANewOperation();
          columnIndex = boxModel.indexOfColumn;
          rowIndex = boxModel.indexOfRow;
        }

        MathOperationModel newMathOperation = MathOperationModel(
          indexOfColumn: columnIndex,
          indexOfRow: rowIndex,
          operationDirection: Axis.values[rnd.nextInt(2)],
        );
        developer.log('created newMathOperation x:$columnIndex y:$rowIndex direction:${newMathOperation.operationDirection.name}',
            name: 'addOperation');
        //isPossibleChecks
        if (_isPossibleToAddNewOperation(newMathOperation: newMathOperation))
        //true means newMathOperation can be added to table
        {
          developer.log('newMathOperation passed isPossibleChecks!', name: 'addOperation');
          for (var index = 0; index < 5; index++) {
            switch (newMathOperation.operationDirection) {
              case Axis.vertical:
                gameTable[columnIndex + index][rowIndex] = newMathOperation.boxes[index];
                break;
              case Axis.horizontal:
                gameTable[columnIndex][rowIndex + index] = newMathOperation.boxes[index];
                break;
            }
          }
          mathOperationsList.add(newMathOperation);
          developer.log('newMathOperation added to gameTable!', name: 'addOperation');
          developer.log('///////////////////////////////////////', name: '--');
          break;
        } else {
          //else means newMathOperation can't be added to table
          developer.log('newMathOperation wont passed isPossibleChecks!', name: 'addOperation');
        }
      } on Exception {
        developer.log('An Exception Occurred', name: 'addOperation');
        rethrow;
      }
      //true means function timed out
      if (startDateTime.isBefore(DateTime.now().add(Duration(seconds: -timeoutDuration)))) {
        developer.log('addOperation function timed out!!', name: 'addOperation');

        throw AddOperationTimedOut('Add Operation Timed Out');
      }
    }
  }

  ///clears [gameTable] and [mathOperationsList]
  void restart() {
    for (int i = 0; i < gameTable.length; i++) {
      for (var j = 0; j < gameTable[1].length; j++) {
        gameTable[i][j] = BoxModel(indexOfColumn: i, indexOfRow: j);
      }
    }
    mathOperationsList.clear();
    developer.log('Cleared gameTable and mathOperationsList', name: 'restartFunction');
  }

  ///Checks if [newMathOperation]'s [BoxType]s matches gameTable's [BoxType]s
  bool _isPossibleToAddNewOperation({
    required MathOperationModel newMathOperation,
  }) {
    //Checks if mathOperationList has newMathOperation already
    if (mathOperationsList.any((mathOperationModel) => (mathOperationModel.boxes.first.isPositionSame(newMathOperation.boxes.first) &&
        mathOperationModel.operationDirection == newMathOperation.operationDirection))) {
      developer.log('returned false cause already mathOperationList has newMathOperation', name: 'isPossibleToAddNewOperationFunction');
      return false;
    }
    int columnIndex = newMathOperation.boxes.first.indexOfColumn;
    int rowIndex = newMathOperation.boxes.first.indexOfRow;
    switch (newMathOperation.operationDirection) {
      case Axis.vertical:
        if (columnIndex >= GamePage.columnSize - 4) {
          developer.log('returned false cause newMathOperation will pass the gameTable border', name: 'isPossibleToAddNewOperationFunction');
          return false;
        }
        for (var index = 0; index < 5; index++) {
          if ((!gameTable[columnIndex + index][rowIndex].boxType.isEqual(newMathOperation.boxes[index].boxType)) &&
              !gameTable[columnIndex + index][rowIndex].isEmpty) {
            developer.log('returned false cause newMathOperation\'s box(${columnIndex + index}, $rowIndex) wont matched gameTables box',
                name: 'isPossibleToAddNewOperationFunction');
            return false;
          }
        }
        if (columnIndex <= GamePage.columnSize - 6 && gameTable[columnIndex + 5][rowIndex].isEmpty) {
          developer.log('returned true', name: 'isPossibleToAddNewOperationFunction');
          return true;
        }
        developer.log('returned false cause newMathOperations next box isn\'t empty', name: 'isPossibleToAddNewOperationFunction');
        return false;
      case Axis.horizontal:
        if (rowIndex >= GamePage.rowSize - 4) {
          developer.log('returned false cause newMathOperation will pass the gameTable border', name: 'isPossibleToAddNewOperationFunction');
          return false;
        }
        for (var index = 0; index < 5; index++) {
          if ((!gameTable[columnIndex][rowIndex + index].boxType.isEqual(newMathOperation.boxes[index].boxType)) &&
              !gameTable[columnIndex][rowIndex + index].isEmpty) {
            developer.log('returned false cause newMathOperation\'s box($columnIndex , ${rowIndex + index}) wont matched gameTables box',
                name: 'isPossibleToAddNewOperationFunction');
            return false;
          }
        }
        if (rowIndex <= GamePage.rowSize - 6 && gameTable[columnIndex][rowIndex + 5].isEmpty) {
          developer.log('returned true', name: 'isPossibleToAddNewOperationFunction');
          return true;
        }
        developer.log('returned false cause newMathOperations next box isn\'t empty', name: 'isPossibleToAddNewOperationFunction');
        return false;
    }
  }
}

class AddOperationTimedOut implements Exception {
  String message;
  AddOperationTimedOut(this.message);
  @override
  String toString() {
    return "Exception: $message";
  }
}
