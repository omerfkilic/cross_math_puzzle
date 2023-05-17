import 'dart:developer' as developer;
import 'dart:math';

import 'package:collection/collection.dart';
import 'package:cross_math_puzzle/components/exceptions/timed_out_exceptions.dart';
import 'package:cross_math_puzzle/components/functions.dart';
import 'package:cross_math_puzzle/helper/consts.dart';
import 'package:cross_math_puzzle/helper/custom_extensions.dart';
import 'package:cross_math_puzzle/models/game_box_coordination_model.dart';
import 'package:flutter/material.dart';

import 'package:cross_math_puzzle/components/exceptions/custom_exceptions.dart';
import 'package:cross_math_puzzle/helper/enums.dart';
import 'package:cross_math_puzzle/models/game_box_model.dart';
import 'package:cross_math_puzzle/models/math_operation_model.dart';

class GamePageViewModel {
  GamePageViewModel._();
  static GamePageViewModel? _instant;
  static GamePageViewModel get instant => _instant ??= GamePageViewModel._();
  final Random _random = Random();

  final List<List<GameBox>> gameTable = [];

  ///list of mathematical operations found in the game table
  final List<MathOperationModel> mathOperationsList = [];

  final Set<int> hiddenNumbers = {};

  ///This function prepares [gameTable]
  void prepareGameTable({required int columnSize, required int rowSize}) {
    for (int indexOfColumn = 0; indexOfColumn < columnSize; indexOfColumn++) {
      gameTable.add(
        List<GameBox>.generate(
          rowSize,
          (indexOfRow) => GameBox(
            coordination: GameBoxCoordination(indexOfColumn: indexOfColumn, indexOfRow: indexOfRow),
          ),
        ),
      );
    }
    developer.log('gameTable Prepared!', name: 'prepareGameTable');
  }

  int _findNumberBoxesCount() {
    Set<GameBox> numberBoxes = {};
    for (var mathOperation in mathOperationsList) {
      for (var gameBox in mathOperation.gameBoxes) {
        if (gameBox.boxType == BoxType.number) {
          numberBoxes.add(gameBox);
        }
      }
    }
    return numberBoxes.length;
  }

  void hideNumbers() {
    int hideCount = (_findNumberBoxesCount() * CConsts.gameDifficult.hiddenCountDivider).toInt();

    final DateTime startDateTime = DateTime.now();
    while (hiddenNumbers.length <= hideCount) {
      MathOperationModel selectedMathOperation = mathOperationsList.randomElement!;
      GameBox selectedBox = selectedMathOperation.numberBoxes.randomElement!;
      if (!selectedBox.isHidden && !selectedMathOperation.isAllNumberBoxesHidden(exceptedList: [selectedBox])) {
        selectedBox.isHidden = true;
        hiddenNumbers.add(selectedBox.valueAsInt!);
      }
      if (startDateTime.isBefore(DateTime.now().add(CConsts.addOperationTimeOutDuration))) {
        developer.log('TimedOut!', name: 'hideNumbers');
        throw HideNumbersTimedOutException('HideNumbers TimedOut!');
      }
    }
    // After we hide all game boxes, we have to check it is possible to solve this puzzle.
    //But i think we don't need this for now.
    //i'll check this after.
    //TODO puzzle'ın çözülebilir olduğunu anlama için kullanıcının izleyeceği yöntemleri bul ve algoritmaya ekle
  }

  void unHideNumbers() {
    for (var mathOperation in mathOperationsList) {
      for (var gameBox in mathOperation.gameBoxes) {
        gameBox.isHidden = false;
      }
    }
  }

  void fillGameBoxes() {
    MathOperationModel? fillableMathOperation;
    final List<MathOperationModel> filledMathOperationList = [];

    for (var mathOperation in mathOperationsList) {
      if (mathOperation.areGameBoxesFilled) {
        filledMathOperationList.add(mathOperation);
      } else {
        fillableMathOperation ??= mathOperation;
        developer.log('Found one fillable MathOperation', name: 'fillGameBoxes');
      }
    }

    if (fillableMathOperation == null) {
      throw ThereIsNotAnyAvailableMathOperationToFillException('There Is Not Any Available Math Operation To Fill');
    } else {
      final DateTime startDateTime = DateTime.now();

      while (true) {
        int? firstNumber;
        int? secondNumber;
        int? result;

        //for firstNumber
        for (var mathOperation in filledMathOperationList) {
          GameBox? filledBox = mathOperation.gameBoxes.firstWhereOrNull(
              (GameBox gameBox) => gameBox.isSameCoordination(fillableMathOperation!.gameBoxes[0]) && mathOperation.gameBoxes[0].hasValue);
          if (filledBox != null) {
            firstNumber = int.tryParse(filledBox.value!);
            break;
          }
        }

        //for secondNumber
        for (var mathOperation in filledMathOperationList) {
          final GameBox? filledBox = mathOperation.gameBoxes.firstWhereOrNull(
              (GameBox gameBox) => gameBox.isSameCoordination(fillableMathOperation!.gameBoxes[2]) && mathOperation.gameBoxes[2].hasValue);
          if (filledBox != null) {
            secondNumber = int.tryParse(filledBox.value!);
            break;
          }
        }

        //for result
        for (var mathOperation in filledMathOperationList) {
          final GameBox? filledBox = mathOperation.gameBoxes.firstWhereOrNull(
              (GameBox gameBox) => gameBox.isSameCoordination(fillableMathOperation!.gameBoxes[4]) && mathOperation.gameBoxes[4].hasValue);
          if (filledBox != null) {
            result = int.tryParse(filledBox.value!);
            break;
          }
        }

        ArithmeticOperatorTypes? arithmeticOperator;
        // for arithmeticOperator
        // this for maybe will delete or not :) i wont decide yet
        // for (var mathOperation in filledMathOperationList) {
        //   final GameBox? filledBox = mathOperation.gameBoxes.firstWhereOrNull(
        //       (GameBox gameBox) => gameBox.isSameCoordination(fillableMathOperation!.gameBoxes[3]) && mathOperation.gameBoxes[3].hasValue);
        //   if (filledBox != null) {
        //     firstNumber = int.tryParse(filledBox.value!);
        //     break;
        //   }
        // }

        arithmeticOperator ??= ArithmeticOperatorTypes.values.randomElement!;
        developer.log('Filled all gameBoxes which has another gameBoxes has value at the same coordinate', name: 'fillGameBoxes');

        //TODO Burayı method olarak dışarı çıkartmamız lazım
        //içine firstNumber, secondNumber, result'ı alır
        //HiddenNumbers'ı da alır içine
        //eğer hiddenNumber null değilse doldurması gereken number'ları bu listeden seçer yoksa random atar
        //Bu şekilde hem fillGameBoxes'da hem de hideNumbers'da kullanabiliriz bunu
        //Yada MathHelper diye bir class kurup tüm matematiksel işlemleri o class'ın içinde yapabiliriz

        //// This logic only for addition and subtraction, Other will add when i ready to write :)
        ///////////////////
        //if all values are null
        if (firstNumber == null && secondNumber == null && result == null) {
          firstNumber ??= _random.nextInt(CConsts.operationBoxNumberLimit);
          secondNumber ??= _random.nextInt(CConsts.operationBoxNumberLimit);
          result = _solveOperation(first: firstNumber, second: secondNumber, arithmeticOperator: arithmeticOperator);

          //////////////////////
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
              firstNumber = _solveOperation(first: result, second: secondNumber!, arithmeticOperator: arithmeticOperator.reverse);
            } else {
              //TODO if arithmeticOperator is - ekle
              secondNumber = _solveOperation(first: result, second: firstNumber, arithmeticOperator: arithmeticOperator.reverse);
            }
            // x  y res
            // 1  1  0
          } else {
            result = _solveOperation(first: firstNumber!, second: secondNumber!, arithmeticOperator: arithmeticOperator);
          }
          /////////////////////////
          //if only two of values are null
          //  x  y res
          //  0  0  1
          //  0  1  0
          //  1  0  0
        } else if ((firstNumber != null) ^ (secondNumber != null) ^ (result != null)) {
          // x  y res
          // 0  1  0
          // 1  0  0
          if (result == null) {
            firstNumber ??= _random.nextInt(CConsts.operationBoxNumberLimit);
            secondNumber ??= _random.nextInt(CConsts.operationBoxNumberLimit);
            result = _solveOperation(first: firstNumber, second: secondNumber, arithmeticOperator: arithmeticOperator);
            // x  y res
            // 0  0  1
          } else {
            //TODO if arithmeticOperator is - ekle
            firstNumber ??= _random.nextInt(result);
            secondNumber = _solveOperation(first: result, second: firstNumber, arithmeticOperator: arithmeticOperator.reverse);
          }
          ///// this condition wont happened cause _checkThereAreTooMuchConnectedOperationException will ignore
          //if didn't we will throw an exception for now
          //This condition's logic will added when i ready to write this :)
        } else if (firstNumber != null && secondNumber != null && result != null) {
          throw Exception();
        }

        if (result! % 1 == 0 &&
            result >= 0 &&
            firstNumber! >= 0 &&
            secondNumber! >= 0 &&
            isOperationCorrect(firstNumber: firstNumber, secondNumber: secondNumber, result: result, arithmeticOperator: arithmeticOperator)) {
          fillableMathOperation.gameBoxes[0].value = firstNumber.toString();
          fillableMathOperation.gameBoxes[1].value = arithmeticOperator.toString();
          fillableMathOperation.gameBoxes[2].value = secondNumber.toString();
          fillableMathOperation.gameBoxes[3].value = '=';
          fillableMathOperation.gameBoxes[4].value = result.toString();
          developer.log('Filled all missing values and added gameTable', name: 'fillGameBoxes');

          break;
        }
        if (startDateTime.isBefore(DateTime.now().add(CConsts.fillGameBoxesTimeOutDuration))) {
          developer.log('TimedOut!', name: 'fillGameBoxes');
          throw FillGameBoxesTimedOutException('FillGameBoxes TimedOut!');
        }
        developer.log('New filled operation didn\'t fit gameTable', name: 'fillGameBoxes');
      }
    }
  }

  int _solveOperation({
    required int first,
    required int second,
    required ArithmeticOperatorTypes arithmeticOperator,
  }) {
    switch (arithmeticOperator) {
      case ArithmeticOperatorTypes.addition:
        return first + second;
      case ArithmeticOperatorTypes.subtraction:
        return first - second;
    }
  }

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

        throw AddOperationTimedOutException('Add Operation Timed Out');
      }
    }
  }

  void checkAllFilledOperationsAreCorrect() {
    for (var mathOperation in mathOperationsList) {
      if (mathOperation.isOperationResultCorrect == false) {
        throw OneOfTheOperationIsNotCorrectException('${mathOperation.getInfo} is not correct');
      }
    }
    developer.log('All Filled Operations Are Correct', name: 'checkAllFilledOperationsAreCorrect');
  }

  ///clears [gameTable] and [mathOperationsList]
  void restartGameData({required int columnSize, required int rowSize}) {
    gameTable.clear();
    mathOperationsList.clear();
    hiddenNumbers.clear();
    developer.log('Cleared gameTable and mathOperationsList!', name: 'restartFunction');
    prepareGameTable(columnSize: columnSize, rowSize: rowSize);
  }

  ///Checks if [newMathOperation]'s [BoxType]s matches gameTable's [BoxType]'s
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

  ///This check for all number filled but operation won't state
  ///
  ///This exception will deleted before full version
  bool _checkThereAreTooMuchConnectedOperationException({required MathOperationModel newMathOperation}) =>
      newMathOperation.numberBoxes.every((numberBox) => _findBoxAtCoordinate(numberBox.coordination).boxType == BoxType.number);
  GameBox _findBoxAtCoordinate(GameBoxCoordination boxCoordination) => gameTable[boxCoordination.indexOfColumn][boxCoordination.indexOfRow];
}
