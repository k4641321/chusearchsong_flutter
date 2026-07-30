import 'package:flutter/material.dart';

class Ratingcalculationmethodpage extends StatelessWidget {
  Ratingcalculationmethodpage({super.key});

  final ScrollController _scrollController = ScrollController();
  final ScrollController _scrollController2 = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Rating计算方式')),
      body: Scrollbar(
        controller: _scrollController,
        child: SingleChildScrollView(
          controller: _scrollController,
          scrollDirection: Axis.horizontal,
          child: SingleChildScrollView(
            controller: _scrollController2,

            child: Center(
              child: DataTable(
                columns: [
                  DataColumn(label: Text('评级')),
                  DataColumn(label: Text('分数')),
                  DataColumn(label: Text('评级值')),
                  DataColumn(label: Text('上升量')),
                ],
                rows: [
                  DataRow(
                    cells: [
                      DataCell(Text('SSS+')),
                      DataCell(Text('1,009,000')),
                      DataCell(Text('谱面常数＋2.15')),
                      DataCell(Text('0')),
                    ],
                  ),
                  DataRow(
                    cells: [
                      DataCell(Text('SSS')),
                      DataCell(Text('1,007,500')),
                      DataCell(Text('谱面定数＋2.0')),
                      DataCell(Text('每100点+0.01')),
                    ],
                  ),
                  DataRow(
                    cells: [
                      DataCell(Text('SS+')),
                      DataCell(Text('1,005,000')),
                      DataCell(Text('谱面常数＋1.5')),
                      DataCell(Text('每50点+0.01')),
                    ],
                  ),
                  DataRow(
                    cells: [
                      DataCell(Text('SS')),
                      DataCell(Text('1,000,000')),
                      DataCell(Text('谱面常数＋1.0')),
                      DataCell(Text('每100点+0.01')),
                    ],
                  ),
                  DataRow(
                    cells: [
                      DataCell(Text('S+')),
                      DataCell(Text('990,000')),
                      DataCell(Text('谱面常数＋0.6')),
                      DataCell(Text('每250点+0.01')),
                    ],
                  ),
                  DataRow(
                    cells: [
                      DataCell(Text('S')),
                      DataCell(Text('975,000')),
                      DataCell(Text('谱面常数')),
                      DataCell(Text('')),
                    ],
                  ),
                  DataRow(
                    cells: [
                      DataCell(Text('AAA')),
                      DataCell(Text('950,000')),
                      DataCell(Text('谱面常数－1.67')),
                      DataCell(Text('每150点+0.01')),
                    ],
                  ),
                  DataRow(
                    cells: [
                      DataCell(Text('AA')),
                      DataCell(Text('925,000')),
                      DataCell(Text('谱面常数－3.34')),
                      DataCell(Text('每150点+0.01')),
                    ],
                  ),
                  DataRow(
                    cells: [
                      DataCell(Text('A')),
                      DataCell(Text('900,000')),
                      DataCell(Text('谱面常数－5.0')),
                      DataCell(Text('每150点+0.01')),
                    ],
                  ),
                  DataRow(
                    cells: [
                      DataCell(Text('BBB')),
                      DataCell(Text('800,000')),
                      DataCell(Text('(谱面常数－5.0)/2')),
                      DataCell(Text('每2000/(谱面常数-5)点+0.01')),
                    ],
                  ),
                  DataRow(
                    cells: [
                      DataCell(Text('C')),
                      DataCell(Text('500,000')),
                      DataCell(Text('0')),
                      DataCell(Text('每6000/(谱面常数-5)点+0.01')),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
