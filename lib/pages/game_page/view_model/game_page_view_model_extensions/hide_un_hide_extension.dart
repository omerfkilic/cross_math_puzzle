part of '../game_page_view_model.dart';

extension HideUnHideExtension on GamePageViewModel {
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
    while (hiddenBoxes.length < hideCount) {
      MathOperationModel selectedMathOperation = mathOperationsList.randomElement!;
      GameBox selectedBox = selectedMathOperation.numberBoxes.randomElement!;
      if (!selectedBox.isHidden && selectedBox.canHidable) {
        selectedBox.isHidden = true;
        hiddenBoxes.add(selectedBox);
      }
      if (startDateTime.isBefore(DateTime.now().add(CConsts.doubleBoxesTimeOutDuration))) {
        developer.log('TimedOut!', name: 'hideNumbers');
        throw HideNumbersTimedOutException();
      }
    }
    //This logic finds mathOperations wont has any hidden numberBox
    //and hide one of them
    for (MathOperationModel mathOperation in mathOperationsList) {
      if (!mathOperation.hasAnyHiddenNumber) {
        GameBox selectedBox = mathOperation.numberBoxes.randomElement!;
        selectedBox.isHidden = true;
        hiddenBoxes.add(selectedBox);
      }
    }
    // After we hide all gameBoxes, we have to check it is possible to solve this puzzle.
    //But i think we don't need this for now.
    //i'll check this later.
    //TODO puzzle'ın çözülebilir olduğunu anlamak için kullanıcının izleyeceği yöntemleri bul ve algoritmaya ekle
  }

  void unHideNumbers() {
    for (var mathOperation in mathOperationsList) {
      for (var gameBox in mathOperation.gameBoxes) {
        gameBox.isHidden = false;
      }
    }
    hiddenBoxes.clear();
  }
}
