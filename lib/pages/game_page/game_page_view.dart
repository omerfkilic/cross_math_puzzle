import 'dart:developer' as developer;
import 'dart:math';

import 'package:collection/collection.dart';
import 'package:cross_math_puzzle/helper/custom_extensions.dart';
import 'package:flutter/material.dart';

import 'package:cross_math_puzzle/helper/custom_exceptions.dart';
import 'package:cross_math_puzzle/helper/enums.dart';
import 'package:cross_math_puzzle/models/box_model.dart';
import 'package:cross_math_puzzle/models/math_operation_model.dart';

part 'game_page_view_model.dart';

class GamePage extends StatefulWidget {
  const GamePage({super.key});
  static const int columnSize = 15;
  static const int rowSize = 15;

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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Material App Bar'),
        actions: [
          ElevatedButton(
            onPressed: () {
              if (viewModel.mathOperationsList.isNotEmpty) {
                try {
                  setState(() {
                    viewModel.checkAllFilledOperationsAreCorrect();
                  });
                } on OneOfTheOperationIsNotCorrectException catch (error) {
                  _showCErrorDialog(
                    context: context,
                    titleWidget: const Text('One Of The Operation Is Not Correct!'),
                    contentWidget: Text(error.toString()),
                  );
                } catch (error) {
                  _showCErrorDialog(
                    context: context,
                    titleWidget: const Text('An Exception Occurred!'),
                    contentWidget: Text(error.toString()),
                  );
                }
              }
              _showCErrorDialog(
                context: context,
                titleWidget: const Text('There are no operation here'),
              );
            },
            child: const Text('Check All Operations Correct'),
          ),
          const SizedBox(width: 5),
          ElevatedButton(
            onPressed: () {
              if (viewModel.mathOperationsList.isNotEmpty) {
                try {
                  setState(() {
                    viewModel.fillBoxes();
                  });
                } on ThereIsNotAnyAvailableMathOperationToFillException {
                  _showCErrorDialog(
                    context: context,
                    titleWidget: const Text('There Is Not Any Available Math Operation To Fill!'),
                    contentWidget: const Text('Can\'t find any operation addable numbers!\nPlease add free operation first!'),
                  );
                } on FillBoxesTimedOutException {
                  _showCErrorDialog(
                    context: context,
                    titleWidget: const Text('FillBoxes TimedOut'),
                    contentWidget: const Text('FillBoxes TimedOut! \n Maybe there isn\'t any correctly fillable operation'),
                  );
                } catch (error) {
                  _showCErrorDialog(
                    context: context,
                    titleWidget: const Text('An Exception Occurred!'),
                    contentWidget: Text(error.toString()),
                  );
                }
              }
            },
            child: const Text('Fill Boxes'),
          ),
          const SizedBox(width: 5),
          ElevatedButton(
            onPressed: () {
              try {
                setState(() {
                  viewModel.addOperation();
                });
              } on AddOperationTimedOutException {
                _showCErrorDialog(
                  context: context,
                  titleWidget: const Text('Add Math Operation timed out!'),
                  contentWidget: const Text('Add Math Operation timed out! \n Please check is possible to add new math operation to game table!'),
                );
              } catch (error) {
                _showCErrorDialog(
                  context: context,
                  titleWidget: const Text('An Exception Occurred!'),
                  contentWidget: Text(error.toString()),
                );
              }
            },
            child: const Text('Add Operation'),
          ),
          const SizedBox(width: 5),
          ElevatedButton(
            onPressed: () => setState(() {
              viewModel.restartGameData(columnSize: GamePage.columnSize, rowSize: GamePage.rowSize);
            }),
            child: const Text('Restart Game Table'),
          ),
        ],
      ),
      body: Container(
        padding: const EdgeInsets.all(15),
        alignment: Alignment.center,
        child: SingleChildScrollView(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
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
                                  : viewModel.gameTable[indexOfColumn][indexOfRow].boxType == BoxType.equalMark
                                      ? Colors.amber
                                      : Colors.red
                              : Colors.grey.shade400,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              //coordinate of box
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
      ),
    );
  }
}

Future _showCErrorDialog({
  required BuildContext context,
  required Widget titleWidget,
  Widget? contentWidget,
}) async {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: titleWidget,
      content: contentWidget,
      actions: [
        ElevatedButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Done'),
        ),
      ],
    ),
  );
}
