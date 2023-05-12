part of 'game_page_view.dart';

class _GamePageViewModel {
  _GamePageViewModel._();
  static _GamePageViewModel? _instant;
  static _GamePageViewModel get instant => _instant ??= _GamePageViewModel._();
  final Random _random = Random();

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
            coordination: BoxCoordination(indexOfColumn: indexOfColumn, indexOfRow: indexOfRow),
          ),
        ),
      );
    }
    developer.log('gameTable Prepared', name: 'prepareGameTable');
  }

  ///restarts gameTable's values and boxTypes
  void restartGameTable({required int columnSize, required int rowSize}) {
    gameTable.clear();
    prepareGameTable(columnSize: columnSize, rowSize: rowSize);
    //adds mathOperations to gameTable
    for (var mathOperation in mathOperationsList) {
      for (var box in mathOperation.boxes) {
        if (gameTable[box.coordination.indexOfColumn][box.coordination.indexOfRow].isEmpty) {
          gameTable[box.coordination.indexOfColumn][box.coordination.indexOfRow].boxType = box.boxType;
        }
        if (mathOperation.areBoxesFilled) {
          gameTable[box.coordination.indexOfColumn][box.coordination.indexOfRow].value = box.value;
        }
      }
    }
  }

  //TODO yazdığımız logic 2 tane yarı dolu operation'nın çakıştığı durumlarda patlıyor çözüm bul!!!
  void fillBoxes() {
    MathOperationModel? fillableMathOperation;
    List<MathOperationModel> filledMathOperationList = [];
    //TODO try catch ekle
    for (var mathOperation in mathOperationsList) {
      if (mathOperation.areBoxesFilled) {
        filledMathOperationList.add(mathOperation);
      } else {
        fillableMathOperation ??= mathOperation;
      }
    }

    if (fillableMathOperation == null) {
      throw ThereIsNotAnyAvailableMathOperationToFillException('There Is Not Any Available Math Operation To Fill');
    } else {
      DateTime startDateTime = DateTime.now();

      while (true) {
        int? firstNumber;
        int? secondNumber;
        int? result;
        //for firstNumber
        for (var mathOperation in filledMathOperationList) {
          BoxModel? filledBox = mathOperation.boxes.firstWhereOrNull((BoxModel boxModel) =>
              boxModel.coordination.isSameCoordination(fillableMathOperation!.boxes[0].coordination) && mathOperation.boxes[0].hasValue);
          if (filledBox != null) {
            firstNumber = int.tryParse(filledBox.value!);
            break;
          }
        }
        //for secondNumber
        for (var mathOperation in filledMathOperationList) {
          BoxModel? filledBox = mathOperation.boxes.firstWhereOrNull((BoxModel boxModel) =>
              boxModel.coordination.isSameCoordination(fillableMathOperation!.boxes[2].coordination) && mathOperation.boxes[2].hasValue);
          if (filledBox != null) {
            secondNumber = int.tryParse(filledBox.value!);
            break;
          }
        }
        //for result
        for (var mathOperation in filledMathOperationList) {
          BoxModel? filledBox = mathOperation.boxes.firstWhereOrNull((BoxModel boxModel) =>
              boxModel.coordination.isSameCoordination(fillableMathOperation!.boxes[4].coordination) && mathOperation.boxes[4].hasValue);
          if (filledBox != null) {
            result = int.tryParse(filledBox.value!);
            break;
          }
        }
        ArithmeticOperatorTypes? arithmeticOperator;
        //for arithmeticOperator
        // for (var mathOperation in filledMathOperationList) {
        //   BoxModel? filledBox = mathOperation.boxes.firstWhereOrNull((BoxModel boxModel) =>
        //       boxModel.boxCoordination.isSameCoordination(fillableMathOperation!.boxes[3].boxCoordination) && mathOperation.boxes.first.hasValue);
        //   if (filledBox != null) {
        //     firstNumber = int.tryParse(filledBox.value!);
        //     break;
        //   }
        // }

        arithmeticOperator ??= ArithmeticOperatorTypes.values[_random.nextInt(ArithmeticOperatorTypes.values.length)];

        //TODO Bu algoritma sadece toplama için diğer işlemlerin de eklenmesi lazım
        //Burayı while içinde döndürebiliriz

        //if all values are null
        if (firstNumber == null && secondNumber == null && result == null) {
          firstNumber ??= _random.nextInt(25);
          secondNumber ??= _random.nextInt(25);
          result = firstNumber + secondNumber;
          //if only one of values is null
          //  x  y res
          //  1  1  0
          //  1  0  1
          //  0  1  1
        } else if ((firstNumber == null) ^ (secondNumber == null) ^ (result == null)) {
          // x  y res
          // 1  0  1
          // 0  1  1
          if (result != null) {
            if (firstNumber == null) {
              firstNumber = result - secondNumber!;
            } else {
              secondNumber = result - firstNumber;
            }
            // x  y res
            // 1  1  0
          } else {
            result = firstNumber! + secondNumber!;
          }
          /////////////////////////
          //if only two of values is null
          //  x  y res
          //  0  0  1
          //  0  1  0
          //  1  0  0
        } else if ((firstNumber != null) ^ (secondNumber != null) ^ (result != null)) {
          // x  y res
          // 0  1  0
          // 1  0  0
          if (result == null) {
            firstNumber ??= _random.nextInt(25);
            secondNumber ??= _random.nextInt(25);
            result = firstNumber + secondNumber;
            // x  y res
            // 0  0  1
          } else {
            firstNumber ??= _random.nextInt(result);
            secondNumber = result - firstNumber;
          }
        }

        // switch (arithmeticOperator) {
        //   case ArithmeticOperatorTypes.addition:
        //     result = firstNumber + secondNumber;
        //     break;
        //   case ArithmeticOperatorTypes.subtraction:
        //     result = firstNumber - secondNumber;
        //     break;
        // }
        if (result! % 1 == 0 && result > 0) {
          fillableMathOperation.boxes[0].value = firstNumber.toString();
          fillableMathOperation.boxes[1].value = arithmeticOperator.toString();
          fillableMathOperation.boxes[2].value = secondNumber.toString();
          fillableMathOperation.boxes[3].value = '=';
          fillableMathOperation.boxes[4].value = result.toString();
          break;
        }
        if (startDateTime.isBefore(DateTime.now().add(const Duration(seconds: -5)))) {
          //TODO log ekle
          if (kDebugMode) {
            print('timed out');
          }
          break;
        }
      }
    }
  }

  void addOperation() {
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
          BoxModel boxModel = mathOperationsList[_random.nextInt(mathOperationsList.length)].getBoxModelForCreateANewOperation();
          columnIndex = boxModel.coordination.indexOfColumn;
          rowIndex = boxModel.coordination.indexOfRow;
        }

        MathOperationModel newMathOperation = MathOperationModel(
          indexOfColumn: columnIndex,
          indexOfRow: rowIndex,
          operationDirection: Axis.values[_random.nextInt(2)],
        );
        developer.log('created newMathOperation x:$columnIndex y:$rowIndex direction:${newMathOperation.operationDirection.name}',
            name: 'addOperation');
        //isPossibleChecks
        if (_isPossibleToAddNewOperation(newMathOperation: newMathOperation))
        //true means newMathOperation can be added to table
        {
          developer.log('newMathOperation passed isPossibleChecks!', name: 'addOperation');
          // for (var index = 0; index < 5; index++) {
          //   switch (newMathOperation.operationDirection) {
          //     case Axis.vertical:
          //       gameTable[columnIndex + index][rowIndex] = newMathOperation.boxes[index];
          //       break;
          //     case Axis.horizontal:
          //       gameTable[columnIndex][rowIndex + index] = newMathOperation.boxes[index];
          //       break;
          //   }
          // }
          // developer.log('newMathOperation added to gameTable!', name: 'addOperation');
          mathOperationsList.add(newMathOperation);
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

        throw AddOperationTimedOutException('Add Operation Timed Out');
      }
    }
  }

  ///clears [gameTable] and [mathOperationsList]
  void restart() {
    for (int i = 0; i < gameTable.length; i++) {
      for (var j = 0; j < gameTable[1].length; j++) {
        gameTable[i][j] = BoxModel(
          coordination: BoxCoordination(indexOfColumn: i, indexOfRow: i),
        );
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
    if (mathOperationsList.any((mathOperationModel) =>
        (mathOperationModel.boxes.first.coordination.isSameCoordination(newMathOperation.boxes.first.coordination) &&
            mathOperationModel.operationDirection == newMathOperation.operationDirection))) {
      developer.log('returned false cause already mathOperationList has newMathOperation', name: 'isPossibleToAddNewOperationFunction');
      return false;
    }
    int columnIndex = newMathOperation.boxes.first.coordination.indexOfColumn;
    int rowIndex = newMathOperation.boxes.first.coordination.indexOfRow;
    switch (newMathOperation.operationDirection) {
      case Axis.vertical:
        if (columnIndex >= GamePage.columnSize - 4) {
          developer.log('returned false cause newMathOperation will pass the gameTable border', name: 'isPossibleToAddNewOperationFunction');
          return false;
        }
        for (var index = 0; index < 5; index++) {
          if ((!gameTable[columnIndex + index][rowIndex].boxType.isEqual(newMathOperation.boxes[index].boxType)) &&
              gameTable[columnIndex + index][rowIndex].isNotEmpty) {
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
              gameTable[columnIndex][rowIndex + index].isNotEmpty) {
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
