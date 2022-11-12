class GameTable {
  // void preapareGameOperations({required int maxOperation}) {
  //   int numberOfOperations = 0;
  //   while (numberOfOperations < maxOperation) {
  //     int columnIndex = Random().nextInt(gameTable.length);
  //     int rowIndex = Random().nextInt(gameTable.first.length);
  //     OperationDirection operationDirection = OperationDirection.values[Random().nextInt(2)];
  //     switch (operationDirection) {
  //       //yatay
  //       case OperationDirection.horizontal:
  //         //oluşturulacak işlemin taşma yapıp yapmayacağını kontrol eder
  //         if (columnIndex + 5 < gameTable.length) {
  //           MathOperationModel tempMathOperations = MathOperationModel();
  //           for (var i = 0; i < 5; i++) {
  //             //oluşturulan işlemin kutularu başka bir işlemle çakışıyorsa ve üst üste gelemiyecekse döngünüyü tekrarlar
  //             if (gameTable[columnIndex + i][rowIndex].isFilled &&
  //                 (gameTable[columnIndex + i][rowIndex].isAritmeticOperator != tempMathOperations.boxes[i].isAritmeticOperator)) {
  //               break;
  //             }
  //           }
  //           for (var i = 0; i < 5; i++) {
  //             gameTable[columnIndex + i][rowIndex] = tempMathOperations.boxes[i];
  //           }
  //           numberOfOperations++;
  //           //TODO Operation oluştur.
  //           //TODO numberOfOperations++;
  //         }
  //         break;
  //       //dikey
  //       case OperationDirection.vertical:
  //         if (rowIndex + 5 < gameTable.length) {
  //           MathOperationModel tempMathOperations = MathOperationModel();
  //           for (var i = 0; i < 5; i++) {
  //             //oluşturulan işlemin kutularu başka bir işlemle çakışıyorsa ve üst üste gelemiyecekse döngünüyü tekrarlar
  //             if (gameTable[columnIndex][rowIndex + i].isFilled &&
  //                 (gameTable[columnIndex][rowIndex + i].isAritmeticOperator != tempMathOperations.boxes[i].isAritmeticOperator)) {
  //               break;
  //             }
  //           }
  //           for (var i = 0; i < 5; i++) {
  //             gameTable[columnIndex][rowIndex + i] = tempMathOperations.boxes[i];
  //           }
  //           numberOfOperations++;
  //           //TODO Operation oluştur.
  //           //TODO numberOfOperations++;
  //         }
  //         break;
  //     }
  //   }
  // }

}
