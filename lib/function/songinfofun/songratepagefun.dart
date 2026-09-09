import 'dart:convert';
import 'dart:developer';
import 'package:intl/intl.dart';

import 'package:chusearchsong_flutter/function/list.dart';
import 'package:chusearchsong_flutter/function/request.dart';
import 'package:chusearchsong_flutter/function/toolsfun/generateb50fun/generateb50.dart';
import 'package:chusearchsong_flutter/function/toolsfun/searchsongzxzrpagefun/songinfopagefun.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

Future<Widget> buildChildren({required int songid, int? index}) async {
  try {
    index ??= 0;
    final formatter = NumberFormat.percentPattern();
    List zxzrsongs = await loadzxzrSongs();
    String? chunirecId;
    for (var i in zxzrsongs) {
      if (i['id'] == songid) {
        chunirecId = i['chunirec_id'];
        break;
      }
    }
    if (chunirecId == null) {
      return Text('暂无数据');
    }
    String chunirecHtmlData = await requestChunirecSongInfoPage(chunirecId);
    Map<String, Map<String, dynamic>> diffData = parseUrecPdx(chunirecHtmlData);
    // print(diffData);
    List<Widget> tabBars = [];
    List<Widget> tabBarViews = [];

    for (var i in diffData.keys) {
      tabBars.add(
        Text(
          i,
          style: TextStyle(
            color: diffcolor(diffindex: returnDiffIndex(diff: i)),
          ),
        ),
      );
      //评级表
      List<PieChartSectionData> rankSections = [];
      List<Widget> legendRankList = [];
      double otherRank = diffData[i]!['players'].toDouble();
      final totalPlayers = diffData[i]!['players'].toDouble();
      for (var j in diffData[i]!['rank'].keys) {
        final rankValue = diffData[i]!['rank'][j].toDouble();
        otherRank = otherRank - rankValue;
        rankSections.add(
          PieChartSectionData(
            radius: 150,
            title: (formatter.format(
              rankValue / totalPlayers,
            )).replaceAll('p', '+'),
            titlePositionPercentageOffset: 0.8,
            value: rankValue,
            color: _rankColor(rank: j),
          ),
        );
        legendRankList.add(
          Padding(
            padding: EdgeInsetsGeometry.only(
              bottom: 3,
              top: 3,
              left: 5,
              right: 5,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    color: _rankColor(rank: j),
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 4),
                Text(
                  '${j.toUpperCase().replaceAll('P', '+')} ${(rankValue / totalPlayers * 100).toStringAsFixed(1)}%',
                  style: TextStyle(fontSize: 12),
                ),
              ],
            ),
          ),
        );
      }
      rankSections.add(
        PieChartSectionData(
          radius: 150,
          title: (formatter.format(
            otherRank / totalPlayers,
          )).replaceAll('p', '+'),
          titlePositionPercentageOffset: 0.8,
          value: otherRank.toDouble(),
          color: _rankColor(rank: 'd'),
        ),
      );
      legendRankList.add(
        Padding(
          padding: EdgeInsetsGeometry.only(
            bottom: 3,
            top: 3,
            left: 5,
            right: 5,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  color: _rankColor(rank: 'd'),
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 4),
              Text(
                'Other ${(otherRank / totalPlayers * 100).toStringAsFixed(1)}%',
                style: TextStyle(fontSize: 12),
              ),
            ],
          ),
        ),
      );
      //连击表
      List<PieChartSectionData> lampSections = [];
      List<Widget> legendLampList = [];
      double otherfc = diffData[i]!['players'].toDouble();
      for (var j in diffData[i]!['lamp'].keys) {
        final lampValue = diffData[i]!['lamp'][j].toDouble();
        final totalPlayers = diffData[i]!['players'].toDouble();
        otherfc = otherfc - lampValue;
        lampSections.add(
          PieChartSectionData(
            radius: 150,
            title: (formatter.format(
              lampValue / totalPlayers,
            )).replaceAll('p', '+'),
            titlePositionPercentageOffset: 0.8,
            value: lampValue,
            color: _fullcombocolor(fullcombo: j),
          ),
        );
        legendLampList.add(
          Padding(
            padding: EdgeInsetsGeometry.only(
              bottom: 3,
              top: 3,
              left: 5,
              right: 5,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    color: _fullcombocolor(fullcombo: j),
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 4),
                Text(
                  '${j.toUpperCase().replaceAll('P', '+')} ${(lampValue / totalPlayers * 100).toStringAsFixed(1)}%',
                  style: TextStyle(fontSize: 12),
                ),
              ],
            ),
          ),
        );
      }
      lampSections.add(
        PieChartSectionData(
          radius: 150,
          title: (formatter.format(
            otherfc / totalPlayers,
          )).replaceAll('p', '+'),
          titlePositionPercentageOffset: 0.8,
          value: otherfc.toDouble(),
          color: _rankColor(rank: 'd'),
        ),
      );
      legendLampList.add(
        Padding(
          padding: EdgeInsetsGeometry.only(
            bottom: 3,
            top: 3,
            left: 5,
            right: 5,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  color: _rankColor(rank: 'd'),
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 4),
              Text(
                'Other ${(otherfc / totalPlayers * 100).toStringAsFixed(1)}%',
                style: TextStyle(fontSize: 12),
              ),
            ],
          ),
        ),
      );
      tabBarViews.add(
        LayoutBuilder(
          builder: (context, constraints) {
            return ListView(
              children: [
                Text(
                  'Rank',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
                Center(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: 400),
                    child: AspectRatio(
                      aspectRatio: 1,
                      child: PieChart(
                        PieChartData(
                          sectionsSpace: 3,
                          centerSpaceRadius: 0,
                          sections: rankSections,
                          pieTouchData: PieTouchData(
                            enabled: true,
                            touchCallback: (p0, p1) {},
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Wrap(alignment: WrapAlignment.center, children: legendRankList),
                Text(
                  'Lamp',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  textAlign: TextAlign.center,
                ),
                Center(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: 400),
                    child: AspectRatio(
                      aspectRatio: 1,
                      child: PieChart(
                        PieChartData(
                          sectionsSpace: 3,
                          centerSpaceRadius: 0,
                          sections: lampSections,
                          pieTouchData: PieTouchData(
                            enabled: true,
                            touchCallback: (p0, p1) {},
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                Wrap(alignment: WrapAlignment.center, children: legendLampList),
              ],
            );
          },
        ),
      );
    }

    return DefaultTabController(
      length: diffData.keys.length,
      initialIndex: index,
      child: Column(
        children: [
          TabBar(tabs: tabBars),
          Expanded(child: TabBarView(children: tabBarViews)),
        ],
      ),
    );
  } catch (e, strack) {
    log('$e\n$strack');
    return Text('错误，请检查网络或者在关于界面更新最新最热歌曲数据\n$e\n$strack');
  }
}

/// 从 chunirec HTML 中提取 urec_pdx 数据
Map<String, Map<String, dynamic>> parseUrecPdx(String html) {
  // 1. 用正则提取 <script id="urec_pdx"> 的内容
  final regex = RegExp(
    r'<script\s+id="urec_pdx"[^>]*>(.*?)</script>',
    dotAll: true,
  );
  final match = regex.firstMatch(html);
  if (match == null) throw Exception('未找到 urec_pdx 数据');

  final raw = match.group(1)!.trim();

  // 2. 按难度前缀拆分
  // 格式: B{...}'A{...}'E{...}'M{...}'
  final diffMap = <String, String>{};
  final diffRegex = RegExp(r"([BAEMUW])\{(.+?)\}'");
  for (final m in diffRegex.allMatches(raw)) {
    final diffKey = m.group(1)!; // B, A, E, M
    final jsonStr = '{${m.group(2)}}'; // 补全花括号
    diffMap[diffKey] = jsonStr;
  }

  // 3. 解析 JSON
  final result = <String, Map<String, dynamic>>{};
  const diffNames = {
    'B': 'BAS',
    'A': 'ADV',
    'E': 'EXP',
    'M': 'MAS',
    'U': 'ULT',
    'W': 'We',
  };
  for (final entry in diffMap.entries) {
    result[diffNames[entry.key]!] = jsonDecode(entry.value);
  }
  return result;
}

Color _rankColor({required String rank}) {
  if (rank == 'sssp') {
    return Colors.purple;
  } else if (rank == 'sss') {
    return Colors.purpleAccent;
  } else if (rank == 'ssp') {
    return Colors.pink;
  } else if (rank == 'ss') {
    return Colors.pinkAccent;
  } else if (rank == 'sp') {
    return Colors.lime;
  } else if (rank == 's') {
    return Colors.limeAccent;
  } else if (rank == 'aaa' || rank == 'aa' || rank == 'a') {
    return Colors.orange;
  } else if (rank == 'bbb' || rank == 'bb' || rank == 'b') {
    return Colors.lightBlue;
  } else if (rank == 'c') {
    return Colors.green;
  } else {
    return Colors.grey;
  }
}

Color _fullcombocolor({required String fullcombo}) {
  switch (fullcombo) {
    case 'fc':
      return Colors.yellow;
    case 'aj':
      return Colors.purpleAccent;
    case 'ajc':
      return Colors.deepPurpleAccent;
    default:
      return Colors.grey;
  }
}
