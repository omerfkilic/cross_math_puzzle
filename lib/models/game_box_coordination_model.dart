class GameBoxCoordination {
  ///coordinate of x
  final int indexOfColumn;

  ///coordinate of y
  final int indexOfRow;

  GameBoxCoordination({
    required this.indexOfColumn,
    required this.indexOfRow,
  });
}

extension GameBoxCoordinationExtension on GameBoxCoordination {
  ///returns gameBoxCoordination.indexOfColumn == this.indexOfColumn && gameBoxCoordination.indexOfRow == this.indexOfRow
  bool isSameCoordination(GameBoxCoordination gameBoxCoordination) =>
      gameBoxCoordination.indexOfColumn == indexOfColumn && gameBoxCoordination.indexOfRow == indexOfRow;
}
