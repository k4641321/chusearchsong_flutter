import 'package:chusearchsong_flutter/pages/toolspages/information/brandprogresspage/brandprogresspage.dart';
import 'package:chusearchsong_flutter/pages/toolspages/information/linkedversepage/linkedversepage.dart';
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

// ── 数据模型 ──

class _ToolItem {
  final String title;
  final IconData icon;
  final WidgetBuilder pageBuilder;
  final Future<void> Function(BuildContext)? onTap;

  const _ToolItem({
    required this.title,
    required this.icon,
    required this.pageBuilder,
    this.onTap,
  });
}

class _ToolSection {
  final String title;
  final List<_ToolItem> items;
  const _ToolSection({required this.title, required this.items});
}

// ── 主窗口 ──

class ToolPage extends StatefulWidget {
  const ToolPage({super.key});

  @override
  State<ToolPage> createState() => _ToolPageState();
}

class _ToolPageState extends State<ToolPage> {
  List<_ToolSection> get _sections => [
    _ToolSection(
      title: '信息',
      items: [
        _ToolItem(
          title: '等级划分与判定',
          icon: Icons.table_chart_outlined,
          pageBuilder: (_) => RankInfo(),
        ),
        _ToolItem(
          title: 'Rating颜色',
          icon: Icons.align_vertical_bottom_outlined,
          pageBuilder: (_) => RatingColor(),
        ),
        _ToolItem(
          title: '机厅搜索',
          icon: Icons.storefront,
          pageBuilder: (_) => SearchLobbyPage(),
        ),
        _ToolItem(
          title: '机厅搜索(新)',
          icon: Icons.store,
          pageBuilder: (_) => Searchlobbynewpage(),
        ),
        _ToolItem(
          title: 'Rating趋势',
          icon: Icons.trending_up_outlined,
          pageBuilder: (_) => const SizedBox(),
          onTap: (ctx) async {
            try {
              final data1 = await returnscoretrendlist();
              final data2 = await returnSpot(data: data1);
              if (!ctx.mounted) return;
              Navigator.push(
                ctx,
                MaterialPageRoute(
                  builder: (_) => RatingTrendPages(data2: data1, data1: data2),
                ),
              );
            } catch (_) {
              if (!ctx.mounted) return;
              ScaffoldMessenger.of(ctx).showSnackBar(
                const SnackBar(content: Text('获取Rating趋势失败，请尝试在关于页面更新数据')),
              );
            }
          },
        ),
        _ToolItem(
          title: '玩家信息',
          icon: Icons.person_outlined,
          pageBuilder: (_) => const SizedBox(),
          onTap: (ctx) async {
            try {
              final playerdata = await returnplayerinfodata();
              if (!ctx.mounted) return;
              Navigator.push(
                ctx,
                MaterialPageRoute(
                  builder: (_) => PlayerInfoPage(playerdata: playerdata),
                ),
              );
            } catch (_) {
              if (!ctx.mounted) return;
              ScaffoldMessenger.of(ctx).showSnackBar(
                const SnackBar(content: Text('获取玩家信息失败，请尝试在关于页面更新数据')),
              );
            }
          },
        ),
        _ToolItem(
          title: 'Rating计算方式',
          icon: Icons.functions_outlined,
          pageBuilder: (_) => Ratingcalculationmethodpage(),
        ),
        _ToolItem(
          title: '收藏品查询',
          icon: Icons.inventory_2_outlined,
          pageBuilder: (_) => SearchCollectiblesPage(),
        ),
        _ToolItem(
          title: 'Linke Verse',
          icon: Icons.door_back_door_outlined,
          pageBuilder: (_) => const Linkedversepage(),
        ),
        _ToolItem(
          title: '牌子进度',
          icon: Icons.emoji_events_outlined,
          pageBuilder: (_) => const Brandprogresspage(),
        ),
      ],
    ),
    _ToolSection(
      title: '工具',
      items: [
        _ToolItem(
          title: '单曲Rating计算器',
          icon: Icons.calculate_outlined,
          pageBuilder: (_) => const RatingCalculator(),
        ),
        _ToolItem(
          title: '分数计算',
          icon: Icons.score_outlined,
          pageBuilder: (_) => ScoreCalculation(),
        ),
        _ToolItem(
          title: '各种B50生成',
          icon: Icons.image_outlined,
          pageBuilder: (_) => GenerateB50Page(),
        ),
        _ToolItem(
          title: '最新最热查歌',
          icon: Icons.search_outlined,
          pageBuilder: (_) => Searchsongzxzrpage(),
        ),
        _ToolItem(
          title: '随机歌曲',
          icon: Icons.casino_outlined,
          pageBuilder: (_) => const RandomMusicPage(),
        ),
        _ToolItem(
          title: '更新成绩',
          icon: Icons.sync,
          pageBuilder: (_) => Updatescorepage(),
        ),
        _ToolItem(
          title: '容错计算',
          icon: Icons.shield_outlined,
          pageBuilder: (_) => const FaulttoterantcomputationPage(totaltap: 0),
        ),
        _ToolItem(
          title: '吃分推荐',
          icon: Icons.recommend_outlined,
          pageBuilder: (_) => const SongRecommendationPage(),
        ),
        _ToolItem(
          title: '等级完成进度',
          icon: Icons.fact_check_outlined,
          pageBuilder: (_) => LevelCompletionProgressPage(),
        ),
        _ToolItem(
          title: 'Over Power计算',
          icon: Icons.rocket_launch_outlined,
          pageBuilder: (_) => const Overpowercalculationpage(),
        ),
        _ToolItem(
          title: '所有成绩查看',
          icon: Icons.view_list_outlined,
          pageBuilder: (_) => const Viewallgradespage(),
        ),
        _ToolItem(
          title: '友人对战',
          icon: Icons.sports_kabaddi_outlined,
          pageBuilder: (_) => const FriendBattlePage(),
        ),
        _ToolItem(
          title: '神秘转盘',
          icon: Icons.album_outlined,
          pageBuilder: (_) => const Chuqinturntablepage(),
        ),
        _ToolItem(
          title: '各种排行榜',
          icon: Icons.leaderboard_outlined,
          pageBuilder: (_) => const Variousrankingspage(),
        ),
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: _buildSections(context),
        ),
      ),
    );
  }

  List<Widget> _buildSections(BuildContext context) {
    final widgets = <Widget>[];
    for (final section in _sections) {
      widgets.add(const Divider());
      widgets.add(
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Text(
            section.title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
      );
      widgets.addAll(_buildRows(section.items, context));
    }
    return widgets.skip(1).toList(); // 跳过第一个 Divider
  }

  List<Widget> _buildRows(List<_ToolItem> items, BuildContext context) {
    final rows = <Widget>[];
    for (int i = 0; i < items.length; i += 2) {
      rows.add(
        Row(
          children: [
            Expanded(child: _buildTile(items[i], context)),
            if (i + 1 < items.length)
              Expanded(child: _buildTile(items[i + 1], context)),
          ],
        ),
      );
    }
    return rows;
  }

  Widget _buildTile(_ToolItem item, BuildContext context) {
    return Card(
      child: TextButton.icon(
        onPressed: item.onTap != null
            ? () => item.onTap!(context)
            : () => Navigator.push(
                context,
                MaterialPageRoute(builder: item.pageBuilder),
              ),
        icon: Icon(item.icon, color: Theme.of(context).colorScheme.onSurface),
        label: Text(
          item.title,
          style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
        ),
      ),
    );
  }
}

// Expanded(
                  //   child: InkWell(
                  //     child: Card(
                  //       child: TextButton.icon(
                  //         label: Text(
                  //           'test',
                  //           style: TextStyle(
                  //             color: Theme.of(context).colorScheme.onSurface,
                  //           ),
                  //         ),
                  //         onPressed: () => Navigator.push(
                  //           context,
                  //           MaterialPageRoute(
                  //             builder: (context) => const Testpage(),
                  //           ),
                  //         ),
                  //         icon: Icon(
                  //           Icons.leaderboard_outlined,
                  //           color: Theme.of(context).colorScheme.onSurface,
                  //         ),
                  //       ),
                  //     ),
                  //   ),
                  // ),
