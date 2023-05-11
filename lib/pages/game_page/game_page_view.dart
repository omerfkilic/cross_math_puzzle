import 'dart:math';

import 'package:cross_math_puzzle/models/box/box_model.dart';
import 'package:cross_math_puzzle/models/math_operation/math_operation_model.dart';
import 'package:flutter/material.dart';
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
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Material App Bar'),
        actions: [
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
              ElevatedButton(
                onPressed: () {
                  try {
                    setState(() {
                      viewModel.addOperation();
                    });
                  } on AddOperationTimedOut {
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
                child: const Text('Add Math Operation'),
              ),
              const SizedBox(height: 25),
              ...List.generate(
                viewModel.gameTable.length,
                (indexOfColumn) => Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: List.generate(
                    viewModel.gameTable[indexOfColumn].length,
                    (indexOfRow) => Container(
                      width: viewModel.gameTable[indexOfColumn][indexOfRow].sizeW,
                      height: viewModel.gameTable[indexOfColumn][indexOfRow].sizeH,
                      padding: const EdgeInsets.symmetric(horizontal: 2),
                      margin: const EdgeInsets.all(2),
                      color: (viewModel.gameTable[indexOfColumn][indexOfRow].isFilled)
                          ? viewModel.gameTable[indexOfColumn][indexOfRow].boxType == BoxType.number
                              ? Colors.blue
                              : viewModel.gameTable[indexOfColumn][indexOfRow].boxType == BoxType.result
                                  ? Colors.amber
                                  : Colors.red
                          : Colors.grey.shade400,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '$indexOfColumn : $indexOfRow',
                            style: const TextStyle(fontSize: 12),
                          ),
                          Text(
                            viewModel.gameTable[indexOfColumn][indexOfRow].boxType.name,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 25),
            ],
          ),
        ),
      ),
    );
  }
}
