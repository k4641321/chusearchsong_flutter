import 'ratingcalculatorpage.dart';
import 'package:flutter/material.dart';
import './rankcolorpage.dart';
import './rankinfopage.dart';
import 'scorecalculationpage.dart';
import './searchlobbypage.dart';
import 'randommusicpage.dart';

//主窗口
class ToolPage extends StatefulWidget {
  const ToolPage({super.key});

  @override
  State<ToolPage> createState() => _ToolPageState();
}

class _ToolPageState extends State<ToolPage> {
  @override
  Widget build(BuildContext context) {
    final ScrollController controller = ScrollController();
    return Scaffold(
      body: Scrollbar(
        controller: controller,
        child: SingleChildScrollView(
          controller: controller,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('信息'),
              Row(
                children: [
                  Expanded(
                    child: InkWell(
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
                  ),
                  Expanded(
                    child: InkWell(
                      child: Card(
                        child: TextButton.icon(
                          onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => RatingColor(),
                            ),
                          ),
                          icon: Icon(
                            Icons.align_vertical_bottom,
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
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: InkWell(
                      child: Card(
                        child: TextButton.icon(
                          onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SearchLobbyPage(),
                            ),
                          ),
                          icon: Icon(
                            Icons.storefront,
                            color: const Color.fromARGB(255, 0, 0, 0),
                          ),
                          label: Text(
                            '机厅信息',
                            style: TextStyle(
                              color: const Color.fromARGB(255, 0, 0, 0),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const Divider(),
              Text('工具'),
              Row(
                children: [
                  Expanded(
                    child: InkWell(
                      child: Card(
                        child: TextButton.icon(
                          label: Text(
                            '单曲Rating计算器',
                            style: TextStyle(
                              color: const Color.fromARGB(255, 0, 0, 0),
                            ),
                          ),
                          onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const RatingCalculator(),
                            ),
                          ),
                          icon: Icon(
                            Icons.calculate,
                            color: const Color.fromARGB(255, 0, 0, 0),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: InkWell(
                      child: Card(
                        child: TextButton.icon(
                          label: Text(
                            '分数计算',
                            style: TextStyle(
                              color: const Color.fromARGB(255, 0, 0, 0),
                            ),
                          ),
                          onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const ScoreCalculation(),
                            ),
                          ),
                          icon: Icon(
                            Icons.calculate,
                            color: const Color.fromARGB(255, 0, 0, 0),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const Divider(),
              Text('其他'),
              Row(
                children: [
                  Expanded(
                    child: InkWell(
                      child: Card(
                        child: TextButton.icon(
                          label: Text(
                            '随机歌曲',
                            style: TextStyle(
                              color: const Color.fromARGB(255, 0, 0, 0),
                            ),
                          ),
                          onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const RandomMusicPage(),
                            ),
                          ),
                          icon: Icon(
                            Icons.calculate,
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
      ),
    );
  }
}
