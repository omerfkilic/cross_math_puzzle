part of '../game_page_view_model.dart';

extension AddOperationExtension on GamePageViewModel {
  /// add a new operation to `gameTable`
  void addOperation() {
    //DateTime for check timeout
    final DateTime startDateTime = DateTime.now();
    //this while will loop until it creates newMathOperation or timed out!
    while (true) {
      int? indexOfColumn;
      int? indexOfRow;
      //if mathOperationsList is empty first mathOperation will start from (0, 0)
      try {
        if (mathOperationsList.isEmpty) {
          indexOfColumn = CConsts.firstOperationStartCoordination.indexOfColumn;
          indexOfRow = CConsts.firstOperationStartCoordination.indexOfRow;
        } else {
          final GameBox gameBox = mathOperationsList.randomElement!.numberBoxes.randomElement!;
          indexOfColumn = gameBox.coordination.indexOfColumn;
          indexOfRow = gameBox.coordination.indexOfRow;
        }

        final MathOperationModel newMathOperation = MathOperationModel(
          indexOfColumn: indexOfColumn,
          indexOfRow: indexOfRow,
          operationDirection: Axis.values.randomElement!,
        );
        developer.log('created newMathOperation ${newMathOperation.getInfo}', name: 'addOperation');

        if (_isPossibleToAddNewOperation(newMathOperation: newMathOperation))
        //true means newMathOperation can be added to table
        {
          developer.log('newMathOperation passed isPossibleToAddNewOperation! It will add to gameTable', name: 'addOperation');
          for (var index = 0; index < 5; index++) {
            final GameBox gameTablesBox;
            switch (newMathOperation.operationDirection) {
              case Axis.vertical:
                gameTablesBox = gameTable[indexOfColumn + index][indexOfRow];
                break;
              case Axis.horizontal:
                gameTablesBox = gameTable[indexOfColumn][indexOfRow + index];
                break;
            }
            if (gameTablesBox.boxType == BoxType.empty) {
              gameTablesBox.boxType = newMathOperation.gameBoxes[index].boxType;
            }
            newMathOperation.gameBoxes[index] = gameTablesBox;
            gameTablesBox.connectedMathOperations.add(newMathOperation);
          }
          mathOperationsList.add(newMathOperation);

          developer.log('///////////////////////////////////////', name: '--');
          break;
        } else {
          //else means newMathOperation cannot be added to table
          developer.log('newMathOperation won\'t passed isPossibleChecks!', name: 'addOperation');
        }
      } on Exception {
        developer.log('An Exception Occurred', name: 'addOperation');
        rethrow;
      }
      //true means function timed out
      if (startDateTime.isBefore(DateTime.now().add(CConsts.addOperationTimeOutDuration))) {
        developer.log('addOperation function timed out!!', name: 'addOperation');

        throw AddOperationTimedOutException();
      }
    }
  }

  ///Checks if `newMathOperation`'s `BoxType`s matches `gameTable`'s `BoxType`s
  bool _isPossibleToAddNewOperation({required MathOperationModel newMathOperation}) {
    //Checks if mathOperationList has newMathOperation already
    if (mathOperationsList.any((mathOperationModel) => (mathOperationModel.gameBoxes.first.isSameCoordination(newMathOperation.gameBoxes.first) &&
        mathOperationModel.operationDirection == newMathOperation.operationDirection))) {
      developer.log('returned false cause mathOperationList already has newMathOperation', name: 'isPossibleToAddNewOperationFunction');
      return false;
    }

    final int indexOfColumn = newMathOperation.gameBoxes.first.coordination.indexOfColumn;
    final int indexOfRow = newMathOperation.gameBoxes.first.coordination.indexOfRow;

    switch (newMathOperation.operationDirection) {
      case Axis.vertical:
        if (indexOfColumn >= CConsts.gameTableColumnIndexSize - 4) {
          developer.log('returned false cause newMathOperation will pass the gameTable border', name: 'isPossibleToAddNewOperationFunction');
          return false;
        }
        /////////////////////
        ///this check for there are too much connected operation exception
        ///it will for a state i explained on check function
        ///it will delete before full version
        if (_checkThereAreTooMuchConnectedOperationException(newMathOperation: newMathOperation)) {
          developer.log('returned false cause ThereAreTooMuchConnectedOperation! exception', name: 'isPossibleToAddNewOperationFunction');
          return false;
        }
        /////////////////////

        for (var index = 0; index < 5; index++) {
          if ((!gameTable[indexOfColumn + index][indexOfRow].boxType.isEqual(newMathOperation.gameBoxes[index].boxType)) &&
              gameTable[indexOfColumn + index][indexOfRow].isNotEmpty) {
            developer.log('returned false cause newMathOperation\'s box(${indexOfColumn + index}, $indexOfRow) wont matched gameTables box',
                name: 'isPossibleToAddNewOperationFunction');
            return false;
          }
        }

        developer.log('returned true', name: 'isPossibleToAddNewOperationFunction');
        return true;

      case Axis.horizontal:
        if (indexOfRow >= CConsts.gameTableRowIndexSize - 4) {
          developer.log('returned false cause newMathOperation will pass the gameTable border', name: 'isPossibleToAddNewOperationFunction');
          return false;
        }
        /////////////////////
        ///this check for there are too much connected operation exception
        ///it will for a state i explained on check function
        ///it will delete before full version
        if (_checkThereAreTooMuchConnectedOperationException(newMathOperation: newMathOperation)) {
          developer.log('returned false cause ThereAreTooMuchConnectedOperation! exception', name: 'isPossibleToAddNewOperationFunction');
          return false;
        }
        /////////////////////

        for (var index = 0; index < 5; index++) {
          if ((!gameTable[indexOfColumn][indexOfRow + index].boxType.isEqual(newMathOperation.gameBoxes[index].boxType)) &&
              gameTable[indexOfColumn][indexOfRow + index].isNotEmpty) {
            developer.log('returned false cause newMathOperation\'s box($indexOfColumn , ${indexOfRow + index}) wont matched gameTables box',
                name: 'isPossibleToAddNewOperationFunction');
            return false;
          }
        }

        developer.log('returned true', name: 'isPossibleToAddNewOperationFunction');
        return true;
    }
  }

  ///This check for all `numberBoxes` places `filled` by other operations
  ///
  ///This exception will deleted before full version
  bool _checkThereAreTooMuchConnectedOperationException({required MathOperationModel newMathOperation}) =>
      newMathOperation.numberBoxes.every((numberBox) => _findBoxAtCoordinate(numberBox.coordination).boxType == BoxType.number);
  GameBox _findBoxAtCoordinate(GameBoxCoordination boxCoordination) => gameTable[boxCoordination.indexOfColumn][boxCoordination.indexOfRow];
}
