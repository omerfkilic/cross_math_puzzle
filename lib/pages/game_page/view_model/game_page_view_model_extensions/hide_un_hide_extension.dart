part of '../game_page_view_model.dart';

extension HideUnHideExtension on GamePageViewModel {
  //TODO expand methodunu code base'de başka nerelere ekleyebiliriz incele!
  Set<GameBox> get hiddenBoxes => mathOperationsList
      .expand<GameBox>((MathOperationModel mathOperation) => mathOperation.numberBoxes.where((GameBox numberBox) => numberBox.isHidden))
      .toSet();

  int _findNumberBoxesCount() => mathOperationsList.expand<GameBox>((MathOperationModel mathOperation) => mathOperation.numberBoxes).length;

  void hideNumbers() {
    int hideCount = (_findNumberBoxesCount() * CConsts.gameDifficult.hiddenCountDivider).toInt();

    final DateTime startDateTime = DateTime.now();
    while (hiddenBoxes.length < hideCount) {
      MathOperationModel selectedMathOperation = mathOperationsList.randomElement!;
      GameBox selectedBox = selectedMathOperation.numberBoxes.randomElement!;
      if (selectedBox.isHidable) {
        selectedBox.isHidden = true;
      }
      if (startDateTime.isBefore(DateTime.now().add(CConsts.doubleBoxesTimeOutDuration))) {
        developer.log('TimedOut!', name: 'hideNumbers');
        throw HideNumbersTimedOutException();
      }
    }
    //This logic finds mathOperations wont has any hidden numberBox
    //and hide one of them
    if (CConsts.areAllOperationAtLeastMustHaveOneHiddenBox) {
      for (MathOperationModel mathOperation in mathOperationsList) {
        if (!mathOperation.hasAnyHiddenNumber) {
          GameBox selectedBox = mathOperation.numberBoxes.randomElement!;
          if (selectedBox.isHidable) {
            selectedBox.isHidden = true;
          }
        }
      }
    }
    // After we hide all gameBoxes, we have to check it is possible to solve this puzzle.
    //But i think we don't need this for now.
    //i'll check this later.
    //TODO puzzle'ın çözülebilir olduğunu anlamak için kullanıcının izleyeceği yöntemleri bul ve algoritmaya ekle
  }

  void unHideNumbers() {
    for (GameBox hiddenBox in hiddenBoxes) {
      hiddenBox.isHidden = false;
    }
  }
}
