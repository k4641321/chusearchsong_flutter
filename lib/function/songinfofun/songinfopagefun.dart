import 'dart:developer';
import 'dart:io';
import 'dart:convert';
import 'package:chusearchsong_flutter/function/toolsfun/searchcollectiblespagefun.dart';
import 'package:flutter/material.dart';
import 'package:marquee/marquee.dart';
import 'package:path_provider/path_provider.dart';
import '../request.dart';
import '../../pages/toolspages/faulttoterantcomputationpage.dart';
import '../fun.dart';
import '../../pages/songinfopages/scorehistorypage.dart';
import '../../pages/songinfopages/rankinglistpage.dart';
import '../../pages/songinfopages/chartviewpage.dart';

List<Widget> returnDiffTabBar({required Map song}) {
  List<Widget> result = [];
  List diff = song['difficulties'];
  for (var i in diff) {
    switch (i['difficulty']) {
      case 0:
        result.add(const Text('BAS'));
        break;
      case 1:
        result.add(const Text('ADV'));
        break;
      case 2:
        result.add(const Text('EXP'));
        break;
      case 3:
        result.add(const Text('MAS'));
        break;
      case 4:
        result.add(const Text('ULT'));
        break;
      case 5:
        result.add(const Text('World\'s End'));
        break;
      default:
        result.add(const Text('Unknown'));
    }
  }
  return result;
}

Future<Widget> returnscore({
  required int song,
  required int i,
  required Color corlor,
  required BuildContext context,
}) async {
  //加载成绩
  Widget result = const Text('无成绩');
  try {
    final path = await getApplicationSupportDirectory();
    final file = File('${path.path}/res/allscore.json');
    Map<String, dynamic> allscore1 = json.decode(file.readAsStringSync());
    List allscore = allscore1['data'];

    // print(i);
    for (var j in allscore) {
      // print('${j['id']},$song');
      if (j['id'] == song) {
        // print('${j['id']},$song');
        if (j['level_index'] == i) {
          result = InkWell(
            onLongPress: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (builder) =>
                    ScoreHistoryPage(songid: song, diffindex: i),
              ),
            ),
            child: Card(
              color: corlor,
              child: Padding(
                padding: EdgeInsetsGeometry.all(8),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Icon(Icons.star),
                        Text(
                          '历史成绩',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Text('Score:   ${j['score']}'),
                    const Divider(),
                    Text('Rating:   ${j['rating']}'),
                    const Divider(),
                    Text('Over_power:   ${j['over_power']}'),
                    const Divider(),
                    Text('Clear:   ${j['clear']}'),
                    const Divider(),
                    Text('Full Combo:   ${j['full_combo']}'),
                    const Divider(),
                    Text('Full Chain:   ${j['full_chain']}'),
                    const Divider(),
                    Text(
                      'Rank:   ${(j['rank'] as String).replaceFirst('p', '+')}',
                    ),
                  ],
                ),
              ),
            ),
          );
        }
      }
    }
    return result;
  } catch (e) {
    return result;
  }
}

Future<List<Widget>> returnDiffTabBarView({
  required Map<String, dynamic> song,
  required Color color,
  required BuildContext context,
}) async {
  List<Widget> result = [];
  try {
    Map<String, dynamic> songInfo = await getSongInfo(song['id']);
    List diffs = songInfo['difficulties'];
    //添加谱面信息
    for (var i = 0; i < diffs.length; i++) {
      var song2 = diffs[i];
      List<Widget> result2 = [];
      result2.add(
        InkWell(
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => ChartViewPage(
                songid: song['id'],
                diffindex: song2['difficulty'],
              ),
            ),
          ),
          onLongPress: () => Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => FaulttoterantcomputationPage(
                totaltap: song2['notes']['total'],
              ),
            ),
          ),
          child: Card(
            color: color,
            child: Padding(
              padding: EdgeInsetsGeometry.all(8),
              child: Column(
                children: [
                  Row(
                    children: [
                      Icon(Icons.queue_music),
                      Text(
                        '谱面信息',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  InkWell(
                    onLongPress: () => copytext(
                      text: song2['note_designer'].toString(),
                      context: context,
                    ),
                    child: Text(
                      '谱师:       ${song2['note_designer']}',
                      textAlign: TextAlign.start,
                    ),
                  ),
                  const Divider(),
                  Text(
                    '定数:      ${song2['level_value']}',
                    style: TextStyle(fontSize: 15),
                  ),
                  const Divider(),
                  Text(
                    'Total:      ${song2['notes']['total']}',
                    style: TextStyle(fontSize: 15),
                  ),
                  const Divider(),
                  Text(
                    'Tap:      ${song2['notes']['tap']}',
                    style: TextStyle(fontSize: 15),
                  ),
                  const Divider(),
                  Text(
                    'Hold:      ${song2['notes']['hold']}',
                    style: TextStyle(fontSize: 15),
                  ),
                  const Divider(),
                  Text(
                    'Slide:      ${song2['notes']['slide']}',
                    style: TextStyle(fontSize: 15),
                  ),
                  const Divider(),
                  Text(
                    'Air:       ${song2['notes']['air']}',
                    style: TextStyle(fontSize: 15),
                  ),
                  const Divider(),
                  Text(
                    'Flick:       ${song2['notes']['flick']}',
                    style: TextStyle(fontSize: 15),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
      if (!context.mounted) {
        result.add(Column(children: result2));
        return result;
      }
      //添加成绩信息
      result2.insert(
        0,
        await returnscore(
          song: song['id'],
          i: i,
          corlor: color,
          context: context,
        ),
      );
      //排行榜按钮
      if (!context.mounted) {
        result.add(Column(children: result2));
        return result;
      }
      result2.insert(
        0,
        Row(
          children: [
            Expanded(
              child: TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (builder) =>
                          RankingListPage(songid: song['id'], levelindex: i),
                    ),
                  );
                },
                child: Text(
                  '查看排行榜',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
      result.add(Column(children: result2));
    }
  } catch (e, strack) {
    int length = song['difficulties'].length;
    for (var i = 0; i < length; i++) {
      List<Widget> result2 = [];
      result2.add(Row(children: [Text('获取谱面信息失败,$e\n $strack')]));
      if (!context.mounted) {
        result.add(Column(children: result2));
        return result;
      }
      result2.insert(
        0,
        await returnscore(
          song: song['id'],
          i: i,
          corlor: color,
          context: context,
        ),
      );
      if (!context.mounted) {
        result.add(Column(children: result2));
        return result;
      }
      result2.insert(
        0,
        Row(
          children: [
            Expanded(
              child: TextButton(
                onPressed: () {
                  log('message');
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (builder) =>
                          RankingListPage(songid: song['id'], levelindex: i),
                    ),
                  );
                },
                child: Text(
                  '查看排行榜',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
      result.add(Column(children: result2));
    }
    log('$e', name: 'songinfopagefun.dart', level: 1000);
    return result;
  }

  return result;
}

Future<List<Widget>> returnSongInformation({
  required int songid,
  required BuildContext context,
  required Color color,
}) async {
  try {
    List<Widget> information = [];
    Map<String, dynamic> songInfo = {};
    songInfo = await getSongInfo(songid);
    if (songInfo.isNotEmpty) {
      if (songInfo.keys.contains('map')) {
        information.add(const Divider());
        information.add(
          InkWell(
            onLongPress: () =>
                copytext(text: songInfo['map'], context: context),
            child: Row(
              children: [
                Icon(Icons.map, size: 18, color: color),
                SizedBox(width: 4),
                SizedBox(
                  width: 100,
                  child: const Text('所属地图: ', style: TextStyle(fontSize: 15)),
                ),
                SizedBox(width: 50),
                Expanded(
                  child: Text(
                    songInfo['map'],
                    style: const TextStyle(fontSize: 15),
                  ),
                ),
              ],
            ),
          ),
        );
      }
      if (songInfo.keys.contains('locked')) {
        late String iflock;
        late IconData lockicon;
        if (songInfo['locked'] == true) {
          iflock = '需解锁';
          lockicon = Icons.lock;
        } else {
          iflock = '无需解锁';
          lockicon = Icons.lock_open;
        }
        information.add(const Divider());
        information.add(
          Row(
            children: [
              Icon(lockicon, size: 18, color: color),
              SizedBox(width: 4),
              SizedBox(
                width: 100,
                child: const Text('是否需要解锁: ', style: TextStyle(fontSize: 15)),
              ),
              SizedBox(width: 50),
              Expanded(
                child: Text(iflock, style: const TextStyle(fontSize: 15)),
              ),
            ],
          ),
        );
      }
      if (songInfo.keys.contains('rights')) {
        information.add(const Divider());
        information.add(
          InkWell(
            onLongPress: () =>
                copytext(text: songInfo['rights'], context: context),
            child: Row(
              children: [
                Icon(Icons.copyright, size: 18, color: color),
                SizedBox(width: 4),
                SizedBox(
                  width: 80,
                  child: const Text('版权: ', style: TextStyle(fontSize: 15)),
                ),
                SizedBox(width: 50),
                Expanded(
                  child: Text(
                    '${songInfo['rights']}',
                    style: const TextStyle(fontSize: 15),
                  ),
                ),
              ],
            ),
          ),
        );
      }
      if (information.isEmpty) {
        information.add(Text('无'));
      }
      information.insert(0, SizedBox(height: 10));
      information.insert(
        0,
        Row(
          children: [
            Text(
              '其余信息',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      );
      return information;
    } else {
      return [
        Row(
          children: [
            Text(
              '其余信息',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        Text('获取其余信息失败'),
      ];
    }
  } catch (e, strack) {
    log('error $e', name: 'fun.dart', level: 1000);
    return [
      Row(
        children: [
          Text(
            '其余信息',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ],
      ),
      Text('请求失败 $e\n $strack', style: const TextStyle(fontSize: 15)),
    ];
  }
}

//别名
Future<List<Widget>> returnAlias({
  required int id,
  required BuildContext context,
  required Color color,
}) async {
  List<Widget> result = [];
  try {
    final path = await getApplicationSupportDirectory();
    final aliasstr = File('${path.path}/res/alias.json').readAsStringSync();
    Map<String, dynamic> aliasjson = await json.decode(aliasstr);
    List alias = aliasjson['aliases'];
    for (var i in alias) {
      if (i['song_id'] == id) {
        List songalias = i['aliases'];
        for (var j in songalias) {
          result.add(
            InkWell(
              onLongPress: () => copytext(text: j.toString(), context: context),
              child: Container(
                padding: EdgeInsets.all(4),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: color),
                ),
                child: Text('$j'),
              ),
            ),
          );
          // result.add(const Divider());
        }
      }
    }
    if (result.isEmpty) {
      result.add(Text('无'));
    }
    result.insert(0, SizedBox(height: 10));
    result.insert(
      0,
      Row(
        children: [
          Text(
            '别名',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  } catch (e) {
    log('$e', name: 'songinfopagefun.dart', level: 1000);
    result = [
      Row(
        children: [
          Text(
            '别名',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ],
      ),
      Text('获取别名失败'),
    ];
  }

  return result;
}

Future<List<Widget>> returnRelatedCollectibles({
  required int id,
  required BuildContext context,
}) async {
  List<Widget> result = [];
  try {
    String requestresultstr = await requestRelatedCollectibles(id: id);
    List requestresult = json.decode(requestresultstr);
    if (requestresult.isEmpty) {
      result.add(Text('无'));
    } else {
      if (!context.mounted) {
        result = [
          Row(
            children: [
              Text(
                '关联收藏品',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          SizedBox(height: 10),
          const Divider(),
          Text('无'),
        ];
        return result;
      }
      for (var i in requestresult) {
        List<Widget> result2 = await searchCollectibles(
          searchtext: i['id'].toString(),
          context: context,
          searchtype: i['type'],
          isSonginfo: true,
        );
        // result2.insert(0, const Divider());
        result.addAll(result2);
        // log('执行');
      }
    }
  } catch (e, strack) {
    result.add(Text('错误 $e\n $strack'));
  }
  result.insert(0, SizedBox(height: 10));
  result.insert(
    0,
    Row(
      children: [
        Text(
          '关联收藏品',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ],
    ),
  );
  return result;
}

Future<Widget> returnChartInfoAndSocre({
  required int songid,
  required Color color,
  required BuildContext context,
}) async {
  Map<String, dynamic> songdata = await getSongInfo(songid);

  if (!context.mounted) {
    return const Text('加载失败');
  }
  Widget result = DefaultTabController(
    length: songdata['difficulties'].length,

    child: Column(
      children: [
        TabBar(tabs: returnDiffTabBar(song: songdata)),
        SizedBox(
          height: 700, //MediaQuery.of(context).size.height * 0.8,
          child: TabBarView(
            children: await returnDiffTabBarView(
              song: songdata,
              color: color,
              context: context,
            ),
          ),
        ),
      ],
    ),
  );
  return result;
}

Widget autoMarqueeText(String text) {
  return LayoutBuilder(
    builder: (context, constraints) {
      final String titleText = text;
      final TextStyle titleStyle =
          Theme.of(context).appBarTheme.titleTextStyle ??
          const TextStyle(fontWeight: FontWeight.bold);

      // 测量文字实际宽度
      final TextPainter painter = TextPainter(
        text: TextSpan(text: titleText, style: titleStyle),
        maxLines: 1,
        textDirection: TextDirection.ltr,
      )..layout();
      final bool isOverflow = painter.width > constraints.maxWidth;

      return SizedBox(
        height: kToolbarHeight,
        child: isOverflow
            ? Marquee(
                text: titleText,
                style: titleStyle,
                velocity: 40, // 滚动速度
                blankSpace: 50, // 首尾间隔
                pauseAfterRound: const Duration(seconds: 1),
              )
            : Center(
                child: Text(
                  titleText,
                  style: titleStyle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
      );
    },
  );
}

// Widget returnappropriateimagewidget({
//   required BuildContext context,
//   required String url,
// }) {
//   if (MediaQuery.of(context).size.width > MediaQuery.of(context).size.height) {
//     return
//   }
// }
