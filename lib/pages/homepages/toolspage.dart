import 'package:chusearchsong_flutter/pages/toolspages/tools/chuqinturntablepage.dart';
import 'package:chusearchsong_flutter/pages/toolspages/tools/friendbattlepage.dart';
import 'package:chusearchsong_flutter/pages/toolspages/tools/overpowercalculationpage.dart';
import 'package:chusearchsong_flutter/pages/toolspages/information/ratingcalculationmethodpage.dart';
import 'package:chusearchsong_flutter/pages/toolspages/information/searchlobbynewpage.dart';
import 'package:chusearchsong_flutter/pages/toolspages/tools/searchsongzxzrpage/searchsongzxzrpage.dart';
import 'package:chusearchsong_flutter/pages/toolspages/tools/songrecommendationpage.dart';
import 'package:chusearchsong_flutter/function/fun.dart';
import 'package:chusearchsong_flutter/pages/toolspages/tools/variousrankingspage.dart';
import 'package:chusearchsong_flutter/pages/toolspages/tools/viewallgradespage.dart';
import '../../function/toolsfun/ratingtrendpagefun.dart';
import '../toolspages/tools/ratingcalculatorpage.dart';
import 'package:flutter/material.dart';
import '../toolspages/information/rankcolorpage.dart';
import '../toolspages/information/rankinfopage.dart';
import '../toolspages/tools/scorecalculationpage.dart';
import '../toolspages/information/searchlobbypage.dart';
import '../toolspages/tools/randommusicpage.dart';
import '../toolspages/information/searchcollectibles/searchcollectiblespage.dart';
import '../toolspages/tools/faulttoterantcomputationpage.dart';
import '../toolspages/information/ratingtrendpages.dart';
import '../toolspages/tools/updatescorepage.dart';
import '../toolspages/tools/generateb50page.dart';
import '../toolspages/information/playerinfopage.dart';
import '../toolspages/tools/levelcompletionprogresspage/levelcompletionprogresspage.dart';

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
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                          label: Text(
                            '等级划分与判定',
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.onSurface,
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
                            Icons.align_vertical_bottom_outlined,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                          label: Text(
                            'Rating颜色',
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.onSurface,
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
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                          label: Text(
                            '机厅搜索',
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.onSurface,
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
                              builder: (context) => Searchlobbynewpage(),
                            ),
                          ),
                          icon: Icon(
                            Icons.store,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                          label: Text(
                            '机厅搜索(新)',
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.onSurface,
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
                          onPressed: () async {
                            try {
                              List data1 = [];
                              data1 = await returnscoretrendlist();
                              List data2 = [];
                              data2 = await returnSpot(data: data1);
                              if (!context.mounted) return;
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => RatingTrendPages(
                                    data2: data1,
                                    data1: data2,
                                  ),
                                ),
                              );
                            } catch (e) {
                              if (!context.mounted) return;
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('获取Rating趋势失败，请尝试在关于页面更新数据'),
                                ),
                              );
                            }
                          },
                          icon: Icon(
                            Icons.trending_up_outlined,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                          label: Text(
                            'Rating趋势',
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.onSurface,
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
                          onPressed: () async {
                            try {
                              final Map<String, dynamic> playerdata =
                                  await returnplayerinfodata();
                              if (!context.mounted) return;
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      PlayerInfoPage(playerdata: playerdata),
                                ),
                              );
                            } catch (e) {
                              if (!context.mounted) return;
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('获取玩家信息失败，请尝试在关于页面更新数据'),
                                ),
                              );
                            }
                          },
                          icon: Icon(
                            Icons.person_outlined,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                          label: Text(
                            '玩家信息',
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.onSurface,
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
                          onPressed: () async {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    Ratingcalculationmethodpage(),
                              ),
                            );
                          },
                          icon: Icon(
                            Icons.functions_outlined,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                          label: Text(
                            'Rating计算方式',
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.onSurface,
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
                              builder: (context) => SearchCollectiblesPage(),
                            ),
                          ),
                          icon: Icon(
                            Icons.inventory_2_outlined,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                          label: Text(
                            '收藏品查询',
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.onSurface,
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
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                          ),
                          onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const RatingCalculator(),
                            ),
                          ),
                          icon: Icon(
                            Icons.calculate_outlined,
                            color: Theme.of(context).colorScheme.onSurface,
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
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ScoreCalculation(),
                              ),
                            );
                          },
                          icon: Icon(
                            Icons.score_outlined,
                            color: Theme.of(context).colorScheme.onSurface,
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
                          label: Text(
                            '各种B50生成',
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                          ),
                          onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => GenerateB50Page(),
                            ),
                          ),
                          icon: Icon(
                            Icons.image_outlined,
                            color: Theme.of(context).colorScheme.onSurface,
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
                            '最新最热查歌',
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                          ),
                          onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Searchsongzxzrpage(),
                            ),
                          ),
                          icon: Icon(
                            Icons.search_outlined,
                            color: Theme.of(context).colorScheme.onSurface,
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
                          label: Text(
                            '随机歌曲',
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                          ),
                          onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const RandomMusicPage(),
                            ),
                          ),
                          icon: Icon(
                            Icons.casino_outlined,
                            color: Theme.of(context).colorScheme.onSurface,
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
                            '更新成绩',
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                          ),
                          onPressed: () {
                            final platform = Theme.of(context).platform;
                            if (platform != TargetPlatform.android) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('不是目标平台，不给予打开')),
                              );
                              return;
                            }
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => UpdateScorePage(),
                              ),
                            );
                          },
                          icon: Icon(
                            Icons.sync,
                            color: Theme.of(context).colorScheme.onSurface,
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
                          label: Text(
                            '容错计算',
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                          ),
                          onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  const FaulttoterantcomputationPage(
                                    totaltap: 0,
                                  ),
                            ),
                          ),
                          icon: Icon(
                            Icons.shield_outlined,
                            color: Theme.of(context).colorScheme.onSurface,
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
                            '吃分推荐',
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                          ),
                          onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  const SongRecommendationPage(),
                            ),
                          ),
                          icon: Icon(
                            Icons.recommend_outlined,
                            color: Theme.of(context).colorScheme.onSurface,
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
                          label: Text(
                            '等级完成进度',
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                          ),
                          onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  LevelCompletionProgressPage(),
                            ),
                          ),
                          icon: Icon(
                            Icons.fact_check_outlined,
                            color: Theme.of(context).colorScheme.onSurface,
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
                            'Over Power计算',
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                          ),
                          onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  const Overpowercalculationpage(),
                            ),
                          ),
                          icon: Icon(
                            Icons.rocket_launch_outlined,
                            color: Theme.of(context).colorScheme.onSurface,
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
                          label: Text(
                            '所有成绩查看',
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                          ),
                          onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const Viewallgradespage(),
                            ),
                          ),
                          icon: Icon(
                            Icons.view_list_outlined,
                            color: Theme.of(context).colorScheme.onSurface,
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
                            '友人对战',
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                          ),
                          onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const FriendBattlePage(),
                            ),
                          ),
                          icon: Icon(
                            Icons.sports_kabaddi_outlined,
                            color: Theme.of(context).colorScheme.onSurface,
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
                          label: Text(
                            '神秘转盘',
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                          ),
                          onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const Chuqinturntablepage(),
                            ),
                          ),
                          icon: Icon(
                            Icons.album_outlined,
                            color: Theme.of(context).colorScheme.onSurface,
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
                            '各种排行榜',
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                          ),
                          onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const Variousrankingspage(),
                            ),
                          ),
                          icon: Icon(
                            Icons.leaderboard_outlined,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              // Row(
              //   children: [
              //     Expanded(
              //       child: InkWell(
              //         child: Card(
              //           child: TextButton.icon(
              //             label: Text(
              //               'test',
              //               style: TextStyle(
              //                 color: Theme.of(context).colorScheme.onSurface,
              //               ),
              //             ),
              //             onPressed: () => Navigator.push(
              //               context,
              //               MaterialPageRoute(
              //                 builder: (context) => const Testpage(),
              //               ),
              //             ),
              //             icon: Icon(
              //               Icons.leaderboard_outlined,
              //               color: Theme.of(context).colorScheme.onSurface,
              //             ),
              //           ),
              //         ),
              //       ),
              //     ),
              //   ],
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
