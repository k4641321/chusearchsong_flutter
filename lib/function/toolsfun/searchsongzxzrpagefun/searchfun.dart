import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:chusearchsong_flutter/pages/toolspages/searchsongzxzrpage/songinfopage.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:math' as math;
import 'package:cached_network_image/cached_network_image.dart';
//我操了，自己都快看力竭了，太石了，自己都要看不懂了

//生成组件
Future<List<Widget>> search({
  required List<dynamic> songresultMap,
  required BuildContext context,
}) async {
  //生成组件
  List<Widget> songresultWidget = [];
  log('添加组件');
  // print(songresult);

  for (var i in songresultMap) {
    List<dynamic> songInfoDiffs = [];
    // songresultWidget.add(const Divider());
    for (var j in i['charts']) {
      songInfoDiffs.add(j['const']);
    }
    songresultWidget.add(
      InkWell(
        // key: ValueKey(i['id']),
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => SongInfoPage(songdata: i)),
        ),

        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(0.0),
          ),
          child: Padding(
            padding: EdgeInsetsGeometry.all(10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CachedNetworkImage(
                  imageUrl: i['jacket_url'],
                  width: 75,
                  height: 75,
                  errorWidget: (context, url, error) {
                    // log('$url\n$error');
                    return Text('加载失败');
                  },
                ),
                Expanded(
                  child: Text(
                    '${i['id']} - ${i['title']}      ${i['genre']} - ${i['version']}  \n $songInfoDiffs',
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  // print(songresult);
  log('完成');
  return songresultWidget;
}

Future<List<dynamic>> filter(
  String title,
  String genre,
  String version,
  String difficultydown,
  String difficultyup,
  String ifplay,
  int? bpmup,
  int? bpmdown,
  bool isSearch,
  int? count,
) async {
  // 加载曲目数据
  final dataPath = await getApplicationSupportDirectory();
  String jsonString = await File(
    '${dataPath.path}/res/zxzrsongs.json',
  ).readAsString();
  List songData = json.decode(jsonString);

  log(
    '$title $genre $version $difficultydown $difficultyup $ifplay $bpmup $bpmdown',
  );

  //初步筛选
  Set<int> songresult = {};
  if (title == '' &&
      genre == '-1' &&
      version == '-1' &&
      difficultydown == '-1' &&
      difficultyup == '-1' &&
      ifplay == '-1' &&
      bpmup == null &&
      bpmdown == null &&
      isSearch == true) {
    log('未选择条件');
    return [];
  }
  for (var i in songData) {
    if (!(i as Map).containsKey('id') || i['id'] == null) {
      continue;
    }
    if (i['title'].toLowerCase().contains(title.toLowerCase())) {
      // log('匹配');
      songresult.add(i['id']);
    }
  }

  //曲师筛选

  for (var i in songData) {
    if (!(i as Map).containsKey('id') || i['id'] == null) {
      continue;
    }
    if (i['artist'].toLowerCase().contains(title.toLowerCase())) {
      // log('曲师匹配 ${i['artist']}');
      songresult.add(i['id']);
    }
  }

  //id筛选
  try {
    int.parse(title);
    for (var i in songData) {
      if (!(i as Map).containsKey('id') || i['id'] == null) {
        continue;
      }
      if (i['id'].toString().contains(title)) {
        songresult.add(i['id']);
      }
    }
  } catch (e) {
    log('跳过id筛选');
  }

  //别名筛选
  // Set<Map<String, dynamic>> aliasresult = {};
  for (var i in songData) {
    if (!(i as Map).containsKey('id') || i['id'] == null) {
      continue;
    }
    if ((i['aliases'] as List).contains(title.toLowerCase())) {
      songresult.add(i['id']);
      break;
    }
  }

  //bpm筛选
  if (bpmup == null && bpmdown == null) {
    log('跳过bpm筛选');
  } else {
    if (bpmup != null && bpmdown == null) {
      bpmdown = 0;
    } else if (bpmup == null && bpmdown != null) {
      bpmup = 9999;
    }
    for (var i in songData) {
      if (!(i as Map).containsKey('id') || i['id'] == null) {
        continue;
      }
      if (!(i['bpm']['mode'] <= bpmup && i['bpm']['mode'] >= bpmdown)) {
        songresult.remove(i['id']);
      } else {
        songresult.add(i['id']);
      }
    }
  }

  //谱师筛选
  if (title == '') {
    log('跳过谱师筛选');
  } else {
    for (var i in songData) {
      if (!(i as Map).containsKey('id') || i['id'] == null) {
        continue;
      }
      for (var j in i['charts']) {
        if (j['charter'] == null) continue;

        if (j['charter'].toLowerCase().contains(title.toLowerCase())) {
          songresult.add(i['id']);
        }
      }
    }
  }

  //特殊筛选
  //多种音符组合筛选
  if (title.contains('|')) {
    log('多种组合筛选');
    List notetypelist = title.split('|');
    List listtobefiltered = [];
    //筛选出正确的要筛选的音符种类
    for (var i in notetypelist) {
      if ([
        '\$total',
        '\$tap',
        '\$hold',
        '\$slide',
        '\$air',
        '\$flick',
      ].contains(title.split(' ')[0])) {
        listtobefiltered.add(i);
      }
    }
    // int listtobefilteredcount = listtobefiltered.length;
    for (var song in songData) {
      if (!(song as Map).containsKey('id') || song['id'] == null) {
        continue;
      }
      for (var chart in song['charts']) {
        // 检查这一张谱面是否满足 listtobefiltered 里的所有条件
        bool allMatch = listtobefiltered.every((cond) {
          String notetype = cond.split(' ')[0].replaceAll('\$', '');
          int? noteCount = chart['notecounts'][notetype];
          if (noteCount == null) return false;

          if (cond.split(' ').length == 2) {
            return noteCount == int.tryParse(cond.split(' ')[1]);
          } else if (int.tryParse(cond.split(' ')[1]) != null &&
              int.tryParse(cond.split(' ')[2]) != null) {
            return noteCount >= int.parse(cond.split(' ')[1]) &&
                noteCount <= int.parse(cond.split(' ')[2]);
          } else {
            return false;
          }
        });

        if (allMatch) {
          songresult.add(song['id']);
          break; // 这首歌已匹配，不用再看其他谱面
        }
      }
    }
  } else {
    //特殊筛选
    if ([
      '\$total',
      '\$tap',
      '\$hold',
      '\$slide',
      '\$air',
      '\$flick',
    ].contains(title.split(' ')[0])) {
      log('特殊筛选音符总量');
      String notetype = title.split(' ')[0].replaceAll('\$', '');
      if (title.split(' ').length == 2) {
        for (var i in songData) {
          for (var j in i['charts']) {
            if (j['notecounts'][notetype] ==
                int.tryParse(title.split(' ')[1])) {
              songresult.add(i['id']);
            }
          }
        }
      } else if (title.split(' ').length == 3 &&
          title.split(' ')[2] != '' &&
          [
            '\$total',
            '\$tap',
            '\$hold',
            '\$slide',
            '\$air',
            '\$flick',
          ].contains(title.split(' ')[0])) {
        for (var i in songData) {
          if (!(i as Map).containsKey('id') || i['id'] == null) {
            continue;
          }
          for (var j in i['charts']) {
            if (j['notecounts'][notetype] >=
                    int.tryParse(title.split(' ')[1]) &&
                j['notecounts'][notetype] <=
                    int.tryParse(title.split(' ')[2])) {
              songresult.add(i['id']);
            }
          }
        }
      }
    }
  }

  //Tap数量
  if (title.split(' ')[0] == '\$tap') {
    log('特殊筛选音符Tap');
    if (title.split(' ').length == 2) {
      for (var i in songData) {
        if (!(i as Map).containsKey('id') || i['id'] == null) {
          continue;
        }
        for (var j in i['charts']) {
          if (j['notecounts']['tap'] == int.tryParse(title.split(' ')[1])) {
            songresult.add(i['id']);
          }
        }
      }
    } else if (title.split(' ').length == 3 && title.split(' ')[2] != '') {
      log('特殊筛选音符Tap');
      for (var i in songData) {
        if (!(i as Map).containsKey('id') || i['id'] == null) {
          continue;
        }
        for (var j in i['charts']) {
          if (j['notecounts']['tap'] >= int.tryParse(title.split(' ')[1]) &&
              j['notecounts']['tap'] <= int.tryParse(title.split(' ')[2])) {
            songresult.add(i['id']);
          }
        }
      }
    }
  }

  //Hold数量
  if (title.split(' ')[0] == '\$hold') {
    log('特殊筛选音符Tap');
    if (title.split(' ').length == 2) {
      for (var i in songData) {
        if (!(i as Map).containsKey('id') || i['id'] == null) {
          continue;
        }
        for (var j in i['charts']) {
          if (j['notecounts']['hold'] == int.tryParse(title.split(' ')[1])) {
            songresult.add(i['id']);
          }
        }
      }
    } else if (title.split(' ').length == 3 && title.split(' ')[2] != '') {
      log('特殊筛选音符Tap');
      for (var i in songData) {
        if (!(i as Map).containsKey('id') || i['id'] == null) {
          continue;
        }
        for (var j in i['charts']) {
          if (j['notecounts']['hold'] >= int.tryParse(title.split(' ')[1]) &&
              j['notecounts']['hold'] <= int.tryParse(title.split(' ')[2])) {
            songresult.add(i['id']);
          }
        }
      }
    }
  }

  //Slide数量
  if (title.split(' ')[0] == '\$slide') {
    log('特殊筛选音符Slide');
    if (title.split(' ').length == 2) {
      for (var i in songData) {
        if (!(i as Map).containsKey('id') || i['id'] == null) {
          continue;
        }
        for (var j in i['charts']) {
          if (j['notecounts']['slide'] == int.tryParse(title.split(' ')[1])) {
            songresult.add(i['id']);
          }
        }
      }
    } else if (title.split(' ').length == 3 && title.split(' ')[2] != '') {
      log('特殊筛选音符Slide');
      for (var i in songData) {
        if (!(i as Map).containsKey('id') || i['id'] == null) {
          continue;
        }
        for (var j in i['charts']) {
          if (j['notecounts']['slide'] >= int.tryParse(title.split(' ')[1]) &&
              j['notecounts']['slide'] <= int.tryParse(title.split(' ')[2])) {
            songresult.add(i['id']);
          }
        }
      }
    }
  }

  //Air数量
  if (title.split(' ')[0] == '\$air') {
    log('特殊筛选音符Air');
    if (title.split(' ').length == 2) {
      for (var i in songData) {
        if (!(i as Map).containsKey('id') || i['id'] == null) {
          continue;
        }
        for (var j in i['charts']) {
          if (j['notecounts']['air'] == int.tryParse(title.split(' ')[1])) {
            songresult.add(i['id']);
          }
        }
      }
    } else if (title.split(' ').length == 3 && title.split(' ')[2] != '') {
      log('特殊筛选音符Air');
      for (var i in songData) {
        if (!(i as Map).containsKey('id') || i['id'] == null) {
          continue;
        }
        for (var j in i['charts']) {
          if (j['notecounts']['air'] >= int.tryParse(title.split(' ')[1]) &&
              j['notecounts']['air'] <= int.tryParse(title.split(' ')[2])) {
            songresult.add(i['id']);
          }
        }
      }
    }
  }

  //Flick数量
  if (title.split(' ')[0] == '\$flick') {
    log('特殊筛选音符Flick');
    if (title.split(' ').length == 2) {
      for (var i in songData) {
        if (!(i as Map).containsKey('id') || i['id'] == null) {
          continue;
        }
        for (var j in i['charts']) {
          if (j['notecounts']['flick'] == int.tryParse(title.split(' ')[1])) {
            songresult.add(i['id']);
          }
        }
      }
    } else if (title.split(' ').length == 3 && title.split(' ')[2] != '') {
      log('特殊筛选音符Air');
      for (var i in songData) {
        if (!(i as Map).containsKey('id') || i['id'] == null) {
          continue;
        }
        for (var j in i['charts']) {
          if (j['notecounts']['flick'] >= int.tryParse(title.split(' ')[1]) &&
              j['notecounts']['flick'] <= int.tryParse(title.split(' ')[2])) {
            songresult.add(i['id']);
          }
        }
      }
    }
  }

  List songresultMap = [];
  for (var i in songresult) {
    for (var j in songData) {
      if (i == j['id']) {
        songresultMap.add(j);
      }
    }
  }

  //筛选流派
  if (genre == '-1') {
    log('跳过流派');
  } else {
    List songresult2 = [];
    for (var i in songresultMap) {
      if (i['genre'] == genre) {
        songresult2.add(i);
      }
    }
    songresultMap = songresult2;
  }

  //筛选版本
  if (version == '-1') {
    log('跳过版本');
  } else {
    List songresult3 = [];
    for (var i in songresultMap) {
      if (i['version'] == version) {
        songresult3.add(i);
      }
    }
    songresultMap = songresult3;
  }

  //筛选难度
  if (difficultydown == '-1' && difficultyup == '-1') {
    log('跳过难度');
  } else {
    if (difficultyup == '-1') {
      difficultyup = '17';
    }
    List songresult4 = [];
    for (var i in songresultMap) {
      for (var j in i['charts']) {
        if (j['const'] != null &&
            double.parse(difficultydown) <= j['const'] &&
            j['const'] <= double.parse(difficultyup)) {
          songresult4.add(i);
          break;
        }
      }
    }
    songresultMap = songresult4;
  }

  if (isSearch == false) {
    List idlist = [];
    for (var i in songresultMap) {
      idlist.add(i['id']);
    }
    List<int> resultIds = [];
    final random = math.Random();
    if (count != null) {
      for (var i = 0; i < count; i++) {
        final randomId = random.nextInt(idlist.length);
        resultIds.add(idlist[randomId]);
      }
      List randomresult = [];
      for (var i in songData) {
        for (var j in resultIds) {
          if (i['id'] == j) {
            randomresult.add(i);
          }
        }
      }
      songresultMap = randomresult;
    }
  }

  return songresultMap;
}
