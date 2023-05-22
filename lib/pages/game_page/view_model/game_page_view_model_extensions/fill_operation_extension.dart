part of '../game_page_view_model.dart';

extension FillOperationExtension on GamePageViewModel {
  void fillOperationBoxes() {
    MathOperationModel? fillableMathOperation;
    final List<MathOperationModel> filledMathOperationList = [];

    for (var mathOperation in mathOperationsList) {
      if (mathOperation.areGameBoxesFilled) {
        filledMathOperationList.add(mathOperation);
      } else {
        fillableMathOperation ??= mathOperation;
        developer.log('Found one fillable MathOperation', name: 'fillOperationBoxes');
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
        developer.log('Filled all gameBoxes which has another gameBoxes has value at the same coordinate', name: 'fillOperationBoxes');

        //TODO Burayı method olarak dışarı çıkartmamız lazım
        //içine firstNumber, secondNumber, result'ı alır
        //HiddenNumbers'ı da alır içine
        //eğer hiddenNumber null değilse doldurması gereken number'ları bu listeden seçer yoksa random atar
        //Bu şekilde hem fillOperationBoxes'da hem de hideNumbers'da kullanabiliriz bunu
        //Yada MathHelper diye bir class kurup tüm matematiksel işlemleri o class'ın içinde yapabiliriz

        //// This logic only for addition and subtraction, Other will add when i ready to write :)
        ///////////////////
        //if all values are null
        if (firstNumber == null && secondNumber == null && result == null) {
          firstNumber ??= getRandomInt(CConsts.operationBoxNumberLimit);
          secondNumber ??= getRandomInt(CConsts.operationBoxNumberLimit);
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
              // 5 + x = 10 => x = 10 - 5
              // 10 - x = 5 => x = 10 - 5
              // that means 'subtract smaller from bigger' works for addition and subtraction
              secondNumber = _solveOperation(
                  first: max(firstNumber, result), second: min(firstNumber, result), arithmeticOperator: ArithmeticOperatorTypes.subtraction);
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
            firstNumber ??= getRandomInt(CConsts.operationBoxNumberLimit);
            secondNumber ??= getRandomInt(CConsts.operationBoxNumberLimit);
            result = _solveOperation(first: firstNumber, second: secondNumber, arithmeticOperator: arithmeticOperator);
            // x  y res
            // 0  0  1
          } else {
            secondNumber ??= getRandomInt(result);
            firstNumber = _solveOperation(first: result, second: secondNumber, arithmeticOperator: arithmeticOperator.reverse);
          }
          ///// this condition wont happened cause _checkThereAreTooMuchConnectedOperationException will ignore
          //if didn't we will throw an exception for now
          //This condition's logic will added when i ready to write this :)
        } else if (firstNumber != null && secondNumber != null && result != null) {
          throw Exception();
        }

        if (result! % 1 == 0 &&
            (CConsts.isOperationNumberIncludeZero == true
                ? (result > 0 && firstNumber! > 0 && secondNumber! > 0)
                : (result >= 0 && firstNumber! >= 0 && secondNumber! >= 0)) &&
            isTransactionCorrect(firstNumber: firstNumber, secondNumber: secondNumber, result: result, arithmeticOperator: arithmeticOperator)) {
          fillableMathOperation.gameBoxes[0].value = firstNumber.toString();
          fillableMathOperation.gameBoxes[1].value = arithmeticOperator.toString();
          fillableMathOperation.gameBoxes[2].value = secondNumber.toString();
          fillableMathOperation.gameBoxes[3].value = '=';
          fillableMathOperation.gameBoxes[4].value = result.toString();
          developer.log('Filled all missing values and added gameTable', name: 'fillOperationBoxes');

          break;
        }
        if (startDateTime.isBefore(DateTime.now().add(CConsts.doubleBoxesTimeOutDuration))) {
          developer.log('TimedOut!', name: 'fillOperationBoxes');
          throw FillOperationBoxesTimedOutException();
        }
        developer.log('New filled operation didn\'t fit gameTable', name: 'fillOperationBoxes');
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

  void checkAllFilledOperationsAreCorrect() {
    for (var mathOperation in mathOperationsList) {
      if (mathOperation.isOperationResultCorrect == false) {
        throw OneOfTheOperationIsNotCorrectException('${mathOperation.getInfo} is not correct');
      }
    }
    developer.log('All Filled Operations Are Correct', name: 'checkAllFilledOperationsAreCorrect');
  }
}
