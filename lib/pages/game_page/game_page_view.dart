import 'package:cross_math_puzzle/components/exceptions/timed_out_exceptions.dart';
import 'package:cross_math_puzzle/helper/consts.dart';
import 'package:cross_math_puzzle/models/game_box_model.dart';
import 'package:cross_math_puzzle/pages/game_page/view_model/game_page_view_model.dart';
import 'package:flutter/material.dart';

import 'package:cross_math_puzzle/components/exceptions/custom_exceptions.dart';
import 'package:cross_math_puzzle/helper/enums.dart';

class GamePage extends StatefulWidget {
  const GamePage({super.key});

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  late GamePageViewModel viewModel;
  @override
  void initState() {
    viewModel = GamePageViewModel.instant;
    viewModel.prepareGameTable(columnSize: CConsts.gameTableColumnIndexSize, rowSize: CConsts.gameTableRowIndexSize);
    if (mounted) super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cross Math Puzzle Generator'),
        actions: [
          ElevatedButton(
            onPressed: () {
              setState(() {
                viewModel.unHideNumbers();
              });
            },
            child: const Text('UnHide Numbers'),
          ),
          const SizedBox(width: 5),
          ElevatedButton(
            onPressed: () {
              try {
                setState(() {
                  viewModel.hideNumbers();
                });
              } on HideNumbersTimedOutException catch (error) {
                _showCErrorDialog(
                  context: context,
                  titleWidget: Text(error.toString()),
                );
              } catch (error) {
                _showCErrorDialog(
                  context: context,
                  titleWidget: const Text('An Exception Occurred!'),
                  contentWidget: Text(error.toString()),
                );
              }
            },
            child: const Text('Hide Numbers'),
          ),
          const SizedBox(width: 5),
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
              } else {
                _showCErrorDialog(
                  context: context,
                  titleWidget: const Text('There Are no Operation Here'),
                );
              }
            },
            child: const Text('Check All Operations Correct'),
          ),
          const SizedBox(width: 5),
          ElevatedButton(
            onPressed: () {
              if (viewModel.mathOperationsList.isNotEmpty) {
                try {
                  setState(() {
                    viewModel.fillOperationBoxes();
                  });
                } on ThereIsNotAnyAvailableMathOperationToFillException {
                  _showCErrorDialog(
                    context: context,
                    titleWidget: const Text('There Is Not Any Available Math Operation To Fill!'),
                    contentWidget: const Text('Can\'t find any operation fillable!\nPlease add free operation first!'),
                  );
                } on FillOperationBoxesTimedOutException catch (error) {
                  _showCErrorDialog(
                    context: context,
                    titleWidget: Text(error.toString()),
                    contentWidget: const Text('Maybe there isn\'t any correctly fillable operation'),
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
            child: const Text('Fill Operation Boxes'),
          ),
          const SizedBox(width: 5),
          ElevatedButton(
            onPressed: () {
              try {
                setState(() {
                  viewModel.addOperation();
                });
              } on AddOperationTimedOutException catch (error) {
                _showCErrorDialog(
                  context: context,
                  titleWidget: Text(error.toString()),
                  contentWidget: const Text('Please check is possible to add new math operation to game table!'),
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
              viewModel.restartGameData(columnSize: CConsts.gameTableColumnIndexSize, rowSize: CConsts.gameTableRowIndexSize);
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
                          width: CConsts.gameTableBoxSize.width,
                          height: CConsts.gameTableBoxSize.height,
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
                              //coordinate of gameBox
                              Text(
                                '$indexOfColumn : $indexOfRow',
                                style: const TextStyle(fontSize: 12),
                              ),
                              //gameBox's value or boxType
                              Text(
                                viewModel.gameTable[indexOfColumn][indexOfRow].isHidden
                                    ? 'hidden'
                                    : viewModel.gameTable[indexOfColumn][indexOfRow].value ??
                                        viewModel.gameTable[indexOfColumn][indexOfRow].boxType.name,
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
