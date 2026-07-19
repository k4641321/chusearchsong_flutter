import 'dart:developer';

import 'package:flutter/material.dart';
import '../../function/list.dart';
import '../../function/toolsfun/ratingcalculatorpagefun.dart';

//Rating计算器
class RatingCalculator extends StatefulWidget {
  const RatingCalculator({super.key});

  @override
  State<RatingCalculator> createState() => _RatingCalculatorState();
}

class _RatingCalculatorState extends State<RatingCalculator> {
  final TextEditingController _scoreController = TextEditingController();
  final TextEditingController _diffController = TextEditingController();
  final TextEditingController _resultController = TextEditingController();
  final TextEditingController _diffController2 = TextEditingController();
  final ScrollController _ratingCalculatorController = ScrollController();
  final ScrollController _ratingCalculatorController2 = ScrollController();

  List<DataRow> ratingCalculatorList = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('单曲Rating计算器'),
        // backgroundColor: const Color.fromARGB(255, 255, 229, 84),
      ),
      body: Center(
        child: DefaultTabController(
          length: 2,
          child: Column(
            children: [
              TabBar(
                tabs: [
                  Tab(text: '按分数算'),
                  Tab(text: '按定数算'),
                ],
                labelColor: Theme.of(context).colorScheme.onSurface,
                unselectedLabelColor: Theme.of(context).colorScheme.secondary,
                indicatorColor: Theme.of(context).colorScheme.primary,
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    Scrollbar(
                      controller: _ratingCalculatorController2,
                      child: SingleChildScrollView(
                        controller: _ratingCalculatorController2,
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Text('定数: '),
                                Expanded(
                                  child: TextField(
                                    keyboardType: TextInputType.number,
                                    controller: _diffController,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Text('成绩: '),
                                Expanded(
                                  child: TextField(
                                    keyboardType: TextInputType.number,
                                    controller: _scoreController,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: TextButton(
                                    onPressed: () {
                                      String scorestr = _scoreController.text;
                                      String diffstr = _diffController.text;
                                      double result = 0;
                                      try {
                                        result = calculatorRating(
                                          scorestr: scorestr,
                                          diffstr: diffstr,
                                        );
                                        _resultController.text = result
                                            .toString();
                                      } catch (e) {
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          const SnackBar(
                                            content: Text('看看你哪里输入错误了'),
                                          ),
                                        );
                                      }
                                    },
                                    child: Text(
                                      '计算',
                                      style: TextStyle(
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.onSurface,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const Divider(),
                            Row(
                              children: [
                                Text('Rating: '),
                                Expanded(
                                  child: TextField(
                                    controller: _resultController,
                                    readOnly: true,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    Scrollbar(
                      controller: _ratingCalculatorController,
                      child: SingleChildScrollView(
                        controller: _ratingCalculatorController,
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Text('定数: '),
                                Expanded(
                                  child: TextField(
                                    controller: _diffController2,
                                    keyboardType: TextInputType.number,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: TextButton(
                                    onPressed: () {
                                      String diffstr = _diffController2.text;
                                      double diff = 0;
                                      List<DataRow> ratingCalculatorListData =
                                          [];
                                      try {
                                        if (diffstr.isEmpty) {
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            const SnackBar(
                                              content: Text('看看你哪里输入错误了'),
                                            ),
                                          );
                                          return;
                                        }
                                        diff = double.parse(diffstr);
                                      } catch (e) {
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          const SnackBar(
                                            content: Text('看看你哪里输入错误了'),
                                          ),
                                        );
                                      }

                                      ratingCalculatorListData =
                                          ratingCalculator(
                                            diff: diff,
                                            context: context,
                                          );
                                      setState(() {
                                        ratingCalculatorList =
                                            ratingCalculatorListData;
                                      });
                                    },
                                    child: Text(
                                      '计算',
                                      style: TextStyle(
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.onSurface,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const Divider(),
                            DataTable(
                              columns: [
                                DataColumn(label: Text('分数')),
                                DataColumn(label: Text('Rating')),
                              ],
                              rows: ratingCalculatorList,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
