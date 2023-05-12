import 'dart:math';

import 'package:cross_math_puzzle/helper/custom_exceptions.dart';
import 'package:cross_math_puzzle/helper/enums.dart';
import 'package:cross_math_puzzle/models/box_model.dart';
import 'package:cross_math_puzzle/models/math_operation_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:collection/collection.dart';
import 'dart:developer' as developer;

part 'game_page_view_model.dart';

class GamePage extends StatefulWidget {
  const GamePage({super.key});
  static int columnSize = 15;
  static int rowSize = 15;

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  late _GamePageViewModel viewModel;
  @override
  void initState() {
    viewModel = _GamePageViewModel.instant;
    viewModel.prepareGameTable(columnSize: GamePage.columnSize, rowSize: GamePage.rowSize);
    if (mounted) super.initState();
  }

  @override
  void setState(VoidCallback fn) {
    super.setState(fn);
    viewModel.restartGameTable(columnSize: GamePage.columnSize, rowSize: GamePage.rowSize);
  }

  @override
  Widget build(BuildContext context) {
    //TODO yatayda da scrollable yap
    return Scaffold(
      appBar: AppBar(
        title: const Text('Material App Bar'),
        actions: [
          //TODO IconButton yap bunu
          ElevatedButton(
            onPressed: () {
              if (viewModel.mathOperationsList.isNotEmpty) {
                try {
                  setState(() {
                    viewModel.fillBoxes();
                  });
                } on ThereIsNotAnyAvailableMathOperationToFillException {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('There Is Not Any Available Math Operation To Fill!'),
                      content: const Text('Can\'t find any operation addable numbers!\nPlease add free operation first!'),
                      actions: [
                        ElevatedButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: const Text('Done'),
                        ),
                      ],
                    ),
                  );
                } catch (e) {
                  //TODO catch (e) için custom showDialog yaz
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('An Exception Occurred!'),
                      content: Text(e.toString()),
                      actions: [
                        ElevatedButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: const Text('Done'),
                        ),
                      ],
                    ),
                  );
                }
              }
            },
            child: const Text('add first operations numbers'),
          ),
          IconButton(
              onPressed: () {
                try {
                  setState(() {
                    viewModel.addOperation();
                  });
                } on AddOperationTimedOutException {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Add Math Operation timed out!'),
                      content: const Text('Add Math Operation timed out! \n Please check is possible to add new math operation to game table!'),
                      actions: [
                        ElevatedButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: const Text('Done'),
                        ),
                      ],
                    ),
                  );
                } catch (e) {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('An Exception Occurred!'),
                      content: Text(e.toString()),
                      actions: [
                        ElevatedButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: const Text('Done'),
                        ),
                      ],
                    ),
                  );
                }
              },
              icon: const Icon(Icons.add)),
          IconButton(
            onPressed: () => setState(() {
              viewModel.restart();
            }),
            icon: const Icon(Icons.restart_alt),
          ),
        ],
      ),
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 10),
              ...List.generate(
                viewModel.gameTable.length,
                (indexOfColumn) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: List.generate(
                      viewModel.gameTable[indexOfColumn].length,
                      (indexOfRow) => Container(
                        width: viewModel.gameTable[indexOfColumn][indexOfRow].size.width,
                        height: viewModel.gameTable[indexOfColumn][indexOfRow].size.height,
                        padding: const EdgeInsets.symmetric(horizontal: 2),
                        margin: const EdgeInsets.all(2),
                        color: (viewModel.gameTable[indexOfColumn][indexOfRow].isNotEmpty)
                            ? viewModel.gameTable[indexOfColumn][indexOfRow].boxType == BoxType.number
                                ? Colors.blue
                                : viewModel.gameTable[indexOfColumn][indexOfRow].boxType == BoxType.result
                                    ? Colors.amber
                                    : Colors.red
                            : Colors.grey.shade400,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            //coordination of box
                            Text(
                              '$indexOfColumn : $indexOfRow',
                              style: const TextStyle(fontSize: 12),
                            ),
                            //box's value or boxType
                            Text(
                              viewModel.gameTable[indexOfColumn][indexOfRow].value ?? viewModel.gameTable[indexOfColumn][indexOfRow].boxType.name,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.center,
                              style: const TextStyle(fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 25),
            ],
          ),
        ),
      ),
    );
  }
}
