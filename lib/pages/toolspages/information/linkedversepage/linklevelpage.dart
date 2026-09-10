import 'package:chusearchsong_flutter/function/toolsfun/generateb50fun/generateb50.dart';
import 'package:flutter/material.dart';

class Linklevelpage extends StatefulWidget {
  final List linklevels;
  const Linklevelpage({super.key, required this.linklevels});

  @override
  State<Linklevelpage> createState() => _LinklevelpageState();
}

class _LinklevelpageState extends State<Linklevelpage> {
  List<DataRow> datarowlist = [];
  final ScrollController _datatable1 = ScrollController();
  final ScrollController _datatable2 = ScrollController();
  final ScrollController _bodyController = ScrollController();

  String diffindextoString(int diffindex) {
    switch (diffindex) {
      case 0:
        return 'BASIC';
      case 1:
        return 'ADVANCED';
      case 2:
        return 'EXPERT';
      case 3:
        return 'MASTER';
      case 4:
        return 'ULTIMATE';
      case 5:
        return 'World\'s End';
      default:
        return '未知难度';
    }
  }

  Widget requireddiffWidget(List diffindex) {
    List<Widget> children = [];
    for (var i in diffindex) {
      children.add(
        Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadiusGeometry.all(Radius.circular(5)),
          ),
          color: diffcolor(diffindex: i),
          child: Padding(
            padding: EdgeInsetsGeometry.only(
              left: 8,
              right: 8,
              top: 3,
              bottom: 3,
            ),
            child: Text(
              diffindextoString(i),
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      );
    }
    return Row(children: children);
  }

  void init() {
    for (var i in widget.linklevels) {
      datarowlist.add(
        DataRow(
          cells: [
            DataCell(Text('${i['level']}')),
            DataCell(Text('${i['link_gauge']}')),
            DataCell(Text('${i['relax_time']} 天')),
            DataCell(requireddiffWidget(i['difficulty'])),
          ],
        ),
      );
    }
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    init();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('解锁难度详情')),
      body: Scrollbar(
        controller: _bodyController,
        child: SingleChildScrollView(
          controller: _bodyController,
          child: Column(
            children: [
              Scrollbar(
                controller: _datatable1,
                child: SingleChildScrollView(
                  controller: _datatable1,
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    columns: [
                      DataColumn(label: Text('解锁难度')),
                      DataColumn(label: Text('血量')),
                      DataColumn(label: Text('缓和时间')),
                      DataColumn(label: Text('支持难度')),
                    ],
                    rows: datarowlist,
                  ),
                ),
              ),
              Scrollbar(
                controller: _datatable2,
                child: SingleChildScrollView(
                  controller: _datatable2,
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    columns: [
                      DataColumn(label: Text('Linked LEVEL')),
                      DataColumn(label: Text('GAUGE 最大値')),
                      DataColumn(label: Text('Justice')),
                      DataColumn(label: Text('Attack')),
                      DataColumn(label: Text('Miss')),
                      DataColumn(label: Text('回复量(自身以外)')),
                      DataColumn(label: Text('难度')),
                    ],
                    rows: [
                      DataRow(
                        cells: [
                          DataCell(Text('Ⅴ')),
                          DataCell(Text('1000')),
                          DataCell(Text('-50')),
                          DataCell(Text('-100')),
                          DataCell(Text('-200')),
                          DataCell(Text('+30')),
                          DataCell(requireddiffWidget([3])),
                        ],
                      ),
                      DataRow(
                        cells: [
                          DataCell(Text('Ⅳ')),
                          DataCell(Text('3000')),
                          DataCell(Text('-50')),
                          DataCell(Text('-100')),
                          DataCell(Text('-200')),
                          DataCell(Text('+90')),
                          DataCell(requireddiffWidget([3])),
                        ],
                      ),
                      DataRow(
                        cells: [
                          DataCell(Text('Ⅲ')),
                          DataCell(Text('5000')),
                          DataCell(Text('-50')),
                          DataCell(Text('-100')),
                          DataCell(Text('-200')),
                          DataCell(Text('+180')),
                          DataCell(requireddiffWidget([3])),
                        ],
                      ),
                      DataRow(
                        cells: [
                          DataCell(Text('Ⅱ')),
                          DataCell(Text('5000')),
                          DataCell(Text('-50')),
                          DataCell(Text('-100')),
                          DataCell(Text('-200')),
                          DataCell(Text('+200')),
                          DataCell(requireddiffWidget([2, 3, 4])),
                        ],
                      ),
                      DataRow(
                        cells: [
                          DataCell(Text('Ⅰ')),
                          DataCell(Text('5000')),
                          DataCell(Text('-50')),
                          DataCell(Text('-50')),
                          DataCell(Text('-50')),
                          DataCell(Text('+200')),
                          DataCell(requireddiffWidget([0, 1, 2, 3, 4])),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
