import 'package:flutter/material.dart';
import '../tools/list.dart';

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

class RatingColor extends StatelessWidget {
  const RatingColor({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rating Color'),
        backgroundColor: const Color.fromARGB(255, 255, 229, 84),
      ),
      body: Center(
        child: DataTable(
          columns: [
            DataColumn(label: Text('颜色')),
            DataColumn(label: Text('Rating值')),
          ],
          rows: ratingColor(),
        ),
      ),
    );
  }
}

//主窗口
class ToolPage extends StatefulWidget {
  const ToolPage({super.key});

  @override
  State<ToolPage> createState() => _ToolPageState();
}

class _ToolPageState extends State<ToolPage> {
  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            Text('信息'),
            Row(
              children: [
                InkWell(
                  child: Card(
                    child: TextButton.icon(
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => RankInfo()),
                      ),
                      icon: Icon(
                        Icons.table_chart_outlined,
                        color: const Color.fromARGB(255, 0, 0, 0),
                      ),
                      label: Text(
                        '等级划分与判定',
                        style: TextStyle(
                          color: const Color.fromARGB(255, 0, 0, 0),
                        ),
                      ),
                    ),
                  ),
                ),
                InkWell(
                  child: Card(
                    child: TextButton.icon(
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => RankInfo()),
                      ),
                      icon: Icon(
                        Icons.r_mobiledata,
                        color: const Color.fromARGB(255, 0, 0, 0),
                      ),
                      label: Text(
                        'Rating颜色',
                        style: TextStyle(
                          color: const Color.fromARGB(255, 0, 0, 0),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
