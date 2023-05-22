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
    while (hiddenNumbers.length <= hideCount) {
      MathOperationModel selectedMathOperation = mathOperationsList.randomElement!;
      GameBox selectedBox = selectedMathOperation.numberBoxes.randomElement!;
      if (!selectedBox.isHidden && !selectedMathOperation.isAllNumberBoxesHidden(exceptedList: [selectedBox])) {
        selectedBox.isHidden = true;
        hiddenNumbers.add(selectedBox.valueAsInt!);
      }
      //TODO hideCount dolduğunda hiç hidden box'ı olmayan operation'lardan birer tane hide'la
      if (startDateTime.isBefore(DateTime.now().add(CConsts.doubleBoxesTimeOutDuration))) {
        developer.log('TimedOut!', name: 'hideNumbers');
        throw HideNumbersTimedOutException();
      }
    }
    // After we hide all gameBoxes, we have to check it is possible to solve this puzzle.
    //But i think we don't need this for now.
    //i'll check this after.
    //TODO puzzle'ın çözülebilir olduğunu anlamak için kullanıcının izleyeceği yöntemleri bul ve algoritmaya ekle
  }

  void unHideNumbers() {
    for (var mathOperation in mathOperationsList) {
      for (var gameBox in mathOperation.gameBoxes) {
        gameBox.isHidden = false;
      }
    }
    hiddenNumbers.clear();
  }
}
