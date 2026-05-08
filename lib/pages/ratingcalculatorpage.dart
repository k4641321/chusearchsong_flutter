import 'package:flutter/material.dart';
import '../tools/list.dart';

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
  List<DataRow> ratingCalculatorList = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('单曲Rating计算器'),
        backgroundColor: const Color.fromARGB(255, 255, 229, 84),
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
                labelColor: const Color.fromARGB(255, 0, 0, 0),
                unselectedLabelColor: const Color.fromARGB(255, 128, 128, 128),
                indicatorColor: const Color.fromARGB(255, 255, 229, 84),
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    Center(
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
                                      double score = double.parse(scorestr);
                                      double diff = double.parse(diffstr);

                                      if (score >= 1010000) {
                                        throw Exception('分数输入错误');
                                      } else if (score >= 1009000) {
                                        result = diff + 2.15;
                                      } else if (score < 1009000 &&
                                          score >= 1007500) {
                                        result =
                                            diff +
                                            2.0 +
                                            (score - 1007500) / 100 * 0.01;
                                      } else if (score < 1007500 &&
                                          score >= 1005000) {
                                        result =
                                            diff +
                                            1.5 +
                                            (score - 1005000) / 50 * 0.01;
                                      } else if (score < 1005000 &&
                                          score >= 1000000) {
                                        result =
                                            diff +
                                            1.0 +
                                            (score - 1000000) / 100 * 0.01;
                                      } else if (score < 1000000 &&
                                          score >= 975000) {
                                        result =
                                            diff +
                                            (score - 990000) / 250 * 0.01;
                                      } else if (score < 975000 &&
                                          score >= 925000) {
                                        result = diff - 3.0;
                                      } else if (score < 925000 &&
                                          score >= 900000) {
                                        result = diff - 5.0;
                                      } else if (score < 900000 &&
                                          score >= 800000) {
                                        result = (diff - 5.0) / 2;
                                      } else if (score < 800000) {
                                        result = 0;
                                      }
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
                                      color: Color.fromARGB(255, 0, 0, 0),
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
                    Center(
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
                                    List<DataRow> ratingCalculatorListData = [];
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

                                    ratingCalculatorListData = ratingCalculator(
                                      diff: diff,
                                    );
                                    setState(() {
                                      ratingCalculatorList =
                                          ratingCalculatorListData;
                                    });
                                  },
                                  child: Text(
                                    '计算',
                                    style: TextStyle(
                                      color: Color.fromARGB(255, 0, 0, 0),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const Divider(),
                          Expanded(
                            child: Scrollbar(
                              controller: _ratingCalculatorController,
                              child: SingleChildScrollView(
                                controller: _ratingCalculatorController,
                                child: DataTable(
                                  columns: [
                                    DataColumn(label: Text('分数')),
                                    DataColumn(label: Text('Rating')),
                                  ],
                                  rows: ratingCalculatorList,
                                ),
                              ),
                            ),
                          ),
                        ],
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
