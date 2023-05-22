part of '../game_page_view_model.dart';

extension GameTableExtension on GamePageViewModel {
  ///This function prepares `gameTable`
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

  ///clears `gameTable` and `mathOperationsList`
  void restartGameData({required int columnSize, required int rowSize}) {
    gameTable.clear();
    mathOperationsList.clear();
    hiddenBoxes.clear();
    developer.log('Cleared gameTable and mathOperationsList!', name: 'restartFunction');
    prepareGameTable(columnSize: columnSize, rowSize: rowSize);
  }
}
