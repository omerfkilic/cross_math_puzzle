import 'dart:math';

import 'package:cross_math_puzzle/helper/game_table.dart';
import 'package:cross_math_puzzle/models/box/box_model.dart';
import 'package:cross_math_puzzle/models/math_operation/math_operation_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

part 'game_page_view_model.dart';

class GamePage extends StatefulWidget {
  const GamePage({super.key});

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  late _GamePageViewModel viewModel;
  @override
  void initState() {
    viewModel = _GamePageViewModel();
    viewModel.preapareGameTable(columnSize: 15, rowSize: 15);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Material App Bar'),
      ),
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: SingleChildScrollView(
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.center,
            // crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  setState(() {});
                  viewModel.addOperation();
                },
                child: const Text('child'),
              ),
              const SizedBox(height: 100),
              ...List.generate(
                viewModel.gameTable.length,
                (index1) => Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: List.generate(
                    viewModel.gameTable[index1].length,
                    (index2) => Container(
                      width: viewModel.gameTable[index1][index2].sizeW.toDouble(),
                      height: viewModel.gameTable[index1][index2].sizeH.toDouble(),
                      margin: const EdgeInsets.all(2),
                      color: (viewModel.gameTable[index1][index2].isFilled) ? Colors.blue : Colors.red,
                      child: Text('$index1 : $index2'),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }
}
