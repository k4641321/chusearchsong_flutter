import '../tools/list.dart';
import 'package:flutter/material.dart';

// 等级划分与判定
class RankInfo extends StatelessWidget {
  const RankInfo({super.key});

  @override
  Widget build(BuildContext context) {
    final ScrollController controller = ScrollController();
    return Scaffold(
      appBar: AppBar(
        title: const Text('等级划分与判定'),
        backgroundColor: const Color.fromARGB(255, 255, 229, 84),
      ),
      body: Scrollbar(
        controller: controller,
        child: SingleChildScrollView(
          controller: controller,
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              Center(
                child: DataTable(
                  columns: [
                    DataColumn(label: Text('判定')),
                    DataColumn(
                      label: Expanded(
                        child: Text('取得分数与JUSTICE判定成绩比率', softWrap: true),
                      ),
                    ),
                  ],
                  rows: determineList(),
                ),
              ),
              const Divider(),
              Center(
                child: DataTable(
                  columns: [
                    DataColumn(label: Text('评级')),
                    DataColumn(label: Text('达成率')),
                  ],
                  rows: rankList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
