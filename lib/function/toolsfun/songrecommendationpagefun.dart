import 'dart:developer';
import 'dart:io';
import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:chusearchsong_flutter/function/fun.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import '../../function/toolsfun/ratingcalculatorpagefun.dart';
import 'generateb50fun/generateb50.dart';

Future<double?> initminRating({required bool isNew}) async {
  try {
    //获取b50
    final path = await getApplicationSupportDirectory();
    String b50str = await File("${path.path}/res/b50.json").readAsString();
    Map<String, dynamic> b50 = jsonDecode(b50str)['data'];
    //获取b30
    if (isNew == false) {
      List b30 = b50['bests'];
      double b30min = 0;
      //获取最低rat

      for (var i in b30) {
        if (b30min == 0) {
          b30min = i['rating'];
          // log(b30min.toString());
        } else if (b30min > i['rating']) {
          b30min = i['rating'];
          // log(b30min.toString());
        }
      }

      // while ((mindiff - b30min) <= 0) {
      //   mindiff += 0.1;
      // }
      log('最终b30最小Rating为：${b30min.toString()}');
      return b30min;
    } else if (isNew == true) {
      List b30 = b50['new_bests'];
      double b20min = 0;
      //获取最低rat

      for (var i in b30) {
        if (b20min == 0) {
          b20min = i['rating'];
          // log(b30min.toString());
        } else if (b20min > i['rating']) {
          b20min = i['rating'];
          // log(b30min.toString());
        }
      }

      // while ((mindiff - b20min) <= 0) {
      //   mindiff += 0.0001;
      // }
      log('最终b20最小Rating为：${b20min.toString()}');
      return b20min;
    } else {
      return null;
    }
  } catch (e) {
    return null;
  }
}

double rankScore({required String rank}) {
  switch (rank) {
    case 'sssp':
      return 1009000;
    case 'sss':
      return 1007500;
    case 'ssp':
      return 1005000;
    case 'ss':
      return 1000000;
    case 'sp':
      return 990000;
    case 's':
      return 975000;
    case 'aaa':
      return 950000;
    case 'aa':
      return 925000;
    case 'a':
      return 900000;
    case 'bbb':
      return 800000;
    case 'bb':
      return 700000;
    case 'b':
      return 600000;
    case 'c':
      return 500000;
    case 'd':
      return 000000;
    default:
      return 1009000;
  }
}

Future<List<List<Widget>>> songRecommendation({
  required bool isNew,
  required List<dynamic> filterSongs,
  required String rank,
  required String minRating,
  required BuildContext context,
  required String expectedScore,
}) async {
  List<Widget> songresultWidget = [];
  List<List<Widget>> songresultWidgetList = [];
  try {
    final path = await getApplicationSupportDirectory();
    //加载歌曲列表
    Map<String, dynamic> songsdata = jsonDecode(
      await File("${path.path}/res/songs.json").readAsString(),
    );
    // log(songsdata['songs'].length.toString());

    //获取旧版本号
    Map<String, dynamic> config = jsonDecode(
      await File("${path.path}/config.json").readAsString(),
    );
    List newversions = config['latest_version'];
    List<int> version = [];
    if (isNew == true) {
      for (var i in songsdata['versions']) {
        if (newversions.contains(i['title'] as String)) {
          version.add(i['version']);
        }
      }
    } else {
      for (var i in songsdata['versions']) {
        if (!newversions.contains(i['title'] as String)) {
          version.add(i['version']);
        }
      }
    }

    //找出符合条件的歌曲
    List resultsongs = [];
    for (var i in filterSongs) {
      for (var j in i['difficulties']) {
        if (expectedScore == '' &&
            //大于最低Rating
            calculatorRating(
                  scorestr: rankScore(rank: rank).toString(),
                  diffstr: j['level_value'].toString(),
                ) >
                double.parse(minRating) &&
            //版本号符合
            version.contains(j['version'])) {
          resultsongs.add(i);
        } else if (expectedScore != '' &&
            //大于最低Rating
            calculatorRating(
                  scorestr: rankScore(rank: rank).toString(),
                  diffstr: j['level_value'].toString(),
                ) >
                double.parse(minRating) &&
            //版本号符合
            version.contains(j['version']) &&
            //大于预吃分数
            (calculatorRating(
                      scorestr: rankScore(rank: rank).toString(),
                      diffstr: j['level_value'].toString(),
                    ) -
                    double.parse(minRating)) >=
                double.parse(expectedScore)) {
          resultsongs.add(i);
        }
      }
    }
    resultsongs = resultsongs.toSet().toList();
    log('结果有：${resultsongs.length.toString()}');
    // print(resultsongs);
    //构建组件
    int widgetlistcout = 0;
    if (expectedScore == '') {
      expectedScore = '0';
    }

    for (var i in resultsongs) {
      List<Widget> songInfoDiffs = [];
      String versionname = '';
      int songid = i['id'];
      for (var j in songsdata['versions']) {
        if (j['version'] == i['version']) {
          versionname = j['title'];
          if (versionname != 'CHUNITHM') {
            versionname = versionname.replaceAll('CHUNITHM', '');
          }
        }
      }
      for (var k in i['difficulties']) {
        if ((k as Map<String, dynamic>).containsKey('origin_id')) {
          songid = k['origin_id'];
        }
        if (
        //大于最低Rating
        (calculatorRating(
                  scorestr: rankScore(rank: rank).toString(),
                  diffstr: k['level_value'].toString(),
                )) >
                double.parse(minRating) &&
            //大于预吃分数
            calculatorRating(
                      scorestr: rankScore(rank: rank).toString(),
                      diffstr: k['level_value'].toString(),
                    ) -
                    double.parse(minRating) >=
                double.parse(expectedScore)) {
          songInfoDiffs.add(
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadiusGeometry.all(Radius.circular(5)),
              ),
              color: diffcolor(diffindex: k['difficulty']),
              child: Padding(
                padding: EdgeInsetsGeometry.only(
                  left: 8,
                  right: 8,
                  top: 3,
                  bottom: 3,
                ),

                child: Text(
                  '${k['level_value']} -> ${calculatorRating(
                    scorestr: rankScore(rank: rank).toString(),
                    diffstr: k['level_value'].toString(),
                  ).toStringAsFixed(2)}(+${(calculatorRating(
                        scorestr: rankScore(rank: rank).toString(),
                        diffstr: k['level_value'].toString(),
                      ) - double.parse(minRating)).toStringAsFixed(2)})',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          );
        }
      }
      // songresultWidget.add(const Divider());
      songresultWidget.add(
        InkWell(
          // key: ValueKey(i['id']),
          onTap: () async {
            interSongInfo(
              songbasedata: i,
              context: context,
              versionname: versionname,
            );
          },

          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(0.0),
            ),
            child: Padding(
              padding: EdgeInsetsGeometry.all(10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsetsGeometry.only(right: 10),
                    child: CachedNetworkImage(
                      imageUrl:
                          'https://assets2.lxns.net/chunithm/jacket/$songid.png',
                      width: 95,
                      height: 95,
                      errorWidget: (context, url, error) => Text('加载失败'),
                    ),
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                '${i['title']}',
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                '${i['artist']}',
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                '#${i['id']}   ${i['genre']} - $versionname',
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        Wrap(children: songInfoDiffs),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
      widgetlistcout++;
      // print(songresultWidget);
      if (widgetlistcout == 10) {
        // print(songresultWidget);
        songresultWidgetList.add(songresultWidget);
        songresultWidget = [];
        widgetlistcout = 0;
      }
    }
    songresultWidgetList.add(songresultWidget);
    if (songresultWidgetList.isEmpty) {
      songresultWidgetList.add([Text('没有结果')]);
    }
  } catch (e, strack) {
    return [
      [Text("$e\n$strack")],
    ];
  }

  return songresultWidgetList;
}
