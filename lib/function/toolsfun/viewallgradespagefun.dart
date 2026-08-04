import 'dart:developer';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:chusearchsong_flutter/function/fun.dart';
import 'package:flutter/material.dart';
import 'generateb50fun/generateb50.dart';

Color returnColor(int score) {
  if (score >= 1009000) {
    return Colors.deepPurple;
  } else if (score >= 1007500) {
    return Colors.purple;
  } else if (score >= 975000) {
    return Colors.pink;
  } else if (score >= 900000) {
    return Colors.orange;
  } else if (score >= 600000) {
    return Colors.blue;
  } else if (score > 500000) {
    return Colors.green;
  } else {
    return Colors.grey;
  }
}

String returnDiffName(int diff) {
  switch (diff) {
    case 0:
      return 'Basic';
    case 1:
      return 'Advanced';
    case 2:
      return 'Expert';
    case 3:
      return 'Master';
    case 4:
      return 'ULtimate';
    case 5:
      return 'World\'s End';
    default:
      return '未知';
  }
}

//为了前面好看，后面只能再麻烦一点了（
String? returnfullcombo(String fc) {
  switch (fc) {
    case 'fc':
      return 'fullcombo';
    case 'aj':
      return 'alljustice';
    case 'ajc':
      return 'alljusticecritical';
    default:
      return null;
  }
}

List<List<Widget>> returnScoreList({
  required List allscoredata,
  required Map<String, dynamic> songsdata,
  required BuildContext context,
  required String sortingmethod,
  required int? versionfilter,
  required double levelfilterdown,
  required double levelfilterup,
  required int levelindexfilter,
  required int scoredownfilter,
  required int scoreupfilter,
  required String fcfilter,
}) {
  List<Widget> scorewidgetlist = [];
  List<List<Widget>> scorewidgetlistresult = [];
  List filtersongs = allscoredata;

  //排序方式
  if (sortingmethod == '默认') {
    log('跳过排序方式');
  } else {
    switch (sortingmethod) {
      case 'Rating':
        filtersongs.sort((a, b) => b['rating'].compareTo(a['rating']));
        break;
      case '超越之力':
        filtersongs.sort(
          (a, b) => (b['over_power'] ?? 0).compareTo(a['over_power'] ?? 0),
        );
        break;
      case '分数':
        filtersongs.sort((a, b) => b['score'].compareTo(a['score']));
        break;
      case '定数':
        filtersongs.sort((a, b) {
          double alevel = 0;
          double blevel = 0;
          for (var j in songsdata['songs']) {
            if (a['id'] == j['id']) {
              for (var k in j['difficulties']) {
                if (a['level_index'] == k['difficulty']) {
                  alevel = k['level_value'].toDouble();
                }
              }
            }
            if (b['id'] == j['id']) {
              for (var k in j['difficulties']) {
                if (b['level_index'] == k['difficulty']) {
                  blevel = k['level_value'].toDouble();
                }
              }
            }
          }
          return blevel.compareTo(alevel);
        });
        break;
    }
  }

  //版本筛选
  if (versionfilter == null) {
    log('跳过版本筛选');
  } else {
    List versionfilterresult = [];
    for (var i in filtersongs) {
      for (var j in songsdata['songs']) {
        if (i['id'] == j['id'] && j['version'] == versionfilter) {
          versionfilterresult.add(i);
        }
      }
    }
    filtersongs = versionfilterresult;
  }

  // 定数筛选
  List levelfilterresult = [];
  for (var i in filtersongs) {
    for (var j in songsdata['songs']) {
      for (var k in j['difficulties']) {
        if (i['id'] == j['id'] &&
            k['difficulty'] == i['level_index'] &&
            k['level_value'] >= levelfilterdown &&
            k['level_value'] <= levelfilterup) {
          levelfilterresult.add(i);
        }
      }
    }
  }
  filtersongs = levelfilterresult;

  //难度筛选
  if (levelindexfilter == -1) {
    log('跳过难度筛选');
  } else {
    List levelindexfilterresult = [];
    for (var i in filtersongs) {
      if (i['level_index'] == levelindexfilter) {
        levelindexfilterresult.add(i);
      }
    }
    filtersongs = levelindexfilterresult;
  }

  //分数筛选
  List scorefilterresult = [];
  for (var i in filtersongs) {
    if (i['score'] >= scoredownfilter && i['score'] <= scoreupfilter) {
      scorefilterresult.add(i);
    }
  }
  filtersongs = scorefilterresult;

  //连击筛选
  if (fcfilter == 'all') {
    log('跳过连击筛选');
  } else {
    List fcfilterresult = [];
    for (var i in filtersongs) {
      if (i['full_combo'] == returnfullcombo(fcfilter)) {
        fcfilterresult.add(i);
      }
    }
    filtersongs = fcfilterresult;
  }

  //生成组件
  int count = 0;
  for (var i in filtersongs) {
    int songid = i['id'];
    List<dynamic> songInfoDiffs = [];
    String versionname = '';
    for (var j in songsdata['songs']) {
      if (i['id'] == j['id']) {
        if (((j['difficulties'] as List).last as Map).containsKey(
          'origin_id',
        )) {
          songid = j['difficulties'][0]['origin_id'];
        }
        for (var k in j['difficulties']) {
          if (i['level_index'] == k['difficulty']) {
            songInfoDiffs.add(
              '${returnDiffName(i['level_index'])} - ${k['level_value']}',
            );
          }
        }
        for (var k in songsdata['versions']) {
          if (k['version'] == j['version']) {
            versionname = k['title'];
          }
        }
        scorewidgetlist.add(
          InkWell(
            onTap: () => interSongInfo(
              songbasedata: j,
              context: context,
              versionname: versionname,
            ),
            child: Card(
              child: Padding(
                padding: EdgeInsetsGeometry.all(8),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CachedNetworkImage(
                      imageUrl:
                          'https://assets2.lxns.net/chunithm/jacket/$songid.png',
                      width: 75,
                      height: 75,
                      errorWidget: (context, url, error) => Text('加载失败'),
                    ),
                    Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            '${j['id']} - ${j['title']}      ${j['genre']} - $versionname',
                            textAlign: TextAlign.center,
                          ),
                          Text(
                            '$songInfoDiffs',
                            style: TextStyle(
                              color: diffcolor(diffindex: i['level_index']),
                            ),
                          ),
                          Text(
                            '成绩：${i['score']} | Rating：${i['rating']} | 评级：${(i['rank'] as String).replaceAll('p', '+')}',
                            style: TextStyle(color: returnColor(i['score'])),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }
    }
    count++;
    if (count == 10) {
      scorewidgetlistresult.add(scorewidgetlist);
      scorewidgetlist = [];
      count = 0;
    }
  }
  if (scorewidgetlist.length <= 10) {
    scorewidgetlistresult.add(scorewidgetlist);
  }

  return scorewidgetlistresult;
}

Map<String, dynamic> returnScoreData(List scoredata) {
  int sssp = 0;
  int sss = 0;
  int fc = 0;
  int aj = 0;
  int ajc = 0;

  for (var i in scoredata) {
    if (i['rank'] == 'sssp') sssp++;
    if (i['rank'] == 'sss') sss++;
    if (i['full_combo'] == 'fullcombo') fc++;
    if (i['full_combo'] == 'alljustice') aj++;
    if (i['full_combo'] == 'alljusticecritical') ajc++;
  }

  Map<String, dynamic> result = {
    'totalchart': scoredata.length,
    'sssp': sssp,
    'sss': sss,
    'fc': fc,
    'aj': aj,
    'ajc': ajc,
  };
  return result;
}
