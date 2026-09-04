import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:chusearchsong_flutter/function/toolsfun/generateb50fun/generateb50.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import '../fun.dart';
import 'dart:math' as math;
//我操了，自己都快看力竭了，太石了，自己都要看不懂了

//生成组件
Future<List<Widget>> search({
  required Map<String, dynamic> songsData,
  required Map<String, dynamic> songresultMap,
  required BuildContext context,
  Map<int, dynamic>? searchinfo,
}) async {
  //生成组件
  List<Widget> songresultWidget = [];
  log('添加组件');
  // print(songresult);
  if (songresultMap.isEmpty) return [];

  for (var i in songresultMap['songs']) {
    List<Widget> songInfoDiffs = [];
    String versionname = '';
    for (var j in songsData['versions']) {
      if (j['version'] == i['version']) {
        versionname = j['title'];
        if (versionname != 'CHUNITHM') {
          versionname = versionname.replaceAll('CHUNITHM', '');
        }
      }
    }
    for (var k in i['difficulties']) {
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
              k['level_value'].toString(),
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      );
    }
    // songresultWidget.add(const Divider());
    if (!context.mounted) return [];
    songresultWidget.add(
      returnSongCard(
        songbasedata: i,
        context: context,
        versionname: versionname,
        searchinfo: searchinfo,
      ),
      // InkWell(
      //   // key: ValueKey(i['id']),
      //   onTap: () async {
      //     interSongInfo(
      //       songbasedata: i,
      //       context: context,
      //       versionname: versionname,
      //     );
      //   },

      //   child: Card(
      //     shape: RoundedRectangleBorder(
      //       borderRadius: BorderRadius.circular(0.0),
      //     ),
      //     child: Padding(
      //       padding: EdgeInsetsGeometry.all(10.0),
      //       child: Row(
      //         mainAxisAlignment: MainAxisAlignment.center,
      //         children: [
      //           Padding(
      //             padding: EdgeInsetsGeometry.only(right: 10),
      //             child: CachedNetworkImage(
      //               imageUrl:
      //                   'https://assets2.lxns.net/chunithm/jacket/$songid.png',
      //               width: 95,
      //               height: 95,
      //               errorWidget: (context, url, error) => Text('加载失败'),
      //             ),
      //           ),
      //           Expanded(
      //             child: Column(
      //               children: [
      //                 Row(
      //                   children: [
      //                     Expanded(
      //                       child: Text(
      //                         '${i['title']}',
      //                         overflow: TextOverflow.ellipsis,
      //                         style: TextStyle(
      //                           fontSize: 20,
      //                           fontWeight: FontWeight.bold,
      //                         ),
      //                       ),
      //                     ),
      //                   ],
      //                 ),
      //                 Row(
      //                   children: [
      //                     Expanded(
      //                       child: Text(
      //                         '${i['artist']}',
      //                         overflow: TextOverflow.ellipsis,
      //                       ),
      //                     ),
      //                   ],
      //                 ),
      //                 Row(
      //                   children: [
      //                     Expanded(
      //                       child: Text(
      //                         '#${i['id']}   ${i['genre']} - $versionname',
      //                         overflow: TextOverflow.ellipsis,
      //                       ),
      //                     ),
      //                   ],
      //                 ),
      //                 Wrap(children: songInfoDiffs),
      //               ],
      //             ),
      //           ),
      //         ],
      //       ),
      //     ),
      //   ),
      // ),
    );
  }
  // print(songresult);
  log('完成');
  return songresultWidget;
}

Future<Map<String, dynamic>> filter(
  Map<String, dynamic> songsData,
  Map<String, dynamic> aliasData,
  String title,
  List genre,
  List version,
  String difficultydown,
  String difficultyup,
  String ifplay,
  int? bpmdown,
  int? bpmup,
  bool isSearch,
  int? count,
  int? specialfilter,
  int? onlysearch,
) async {
  // 加载曲目数据
  final dataPath = await getApplicationSupportDirectory();

  //加载游玩记录
  List playhistory = [];
  if (File('${dataPath.path}/res/allscore.json').existsSync()) {
    String playhistorystr = await File(
      '${dataPath.path}/res/allscore.json',
    ).readAsString();
    Map<String, dynamic> playhistoryjson = json.decode(playhistorystr);
    playhistory = playhistoryjson['data'];
  } else {
    log('无游玩记录文件');
  }

  log(
    '$title $genre $version $difficultydown $difficultyup $ifplay $bpmup $bpmdown $specialfilter $onlysearch',
  );

  //信息展示
  Map<int, dynamic> searchinfo = {};

  //初步筛选
  Set<int> songresult = {};
  if (onlysearch == 0 || onlysearch == 1 || onlysearch == null) {
    if (title == '' &&
        genre.contains('-1') &&
        version.contains('-1') &&
        difficultydown == '-1' &&
        difficultyup == '-1' &&
        ifplay == '-1' &&
        bpmup == null &&
        bpmdown == null &&
        isSearch == true) {
      log('未选择条件');
      return {};
    }
    for (var i in songsData['songs']) {
      if (i['title'].toLowerCase().contains(title.toLowerCase())) {
        // log('匹配');
        songresult.add(i['id']);
      }
    }
  }

  //曲师筛选

  if (onlysearch == 0 || onlysearch == 2 || onlysearch == null) {
    for (var i in songsData['songs']) {
      if (i['artist'].toLowerCase().contains(title.toLowerCase())) {
        // log('曲师匹配 ${i['artist']}');
        songresult.add(i['id']);
      }
    }
  }

  //id筛选
  if (onlysearch == 0 || onlysearch == 3 || onlysearch == null) {
    try {
      int.parse(title);
      for (var i in songsData['songs']) {
        if (i['id'].toString().contains(title)) {
          songresult.add(i['id']);
        }
      }
    } catch (e) {
      log('跳过id筛选');
    }
  }

  //别名筛选
  // Set<Map<String, dynamic>> aliasresult = {};
  if (onlysearch == 0 || onlysearch == 4 || onlysearch == null) {
    for (var i in aliasData['aliases']) {
      for (var j in i['aliases']) {
        if (j.toLowerCase().contains(title.toLowerCase())) {
          songresult.add(i['song_id']);
          if (title != '') {
            searchinfo[i['song_id']] ??= {};
            (searchinfo[i['song_id']] as Map)['alias'] = j;
          }
          break;
        }
      }
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
    for (var i in songsData['songs']) {
      if (!(i['bpm'] <= bpmup && i['bpm'] >= bpmdown)) {
        songresult.remove(i['id']);
      } else {
        songresult.add(i['id']);
        searchinfo[i['id']] ??= {};
        (searchinfo[i['id']] as Map)['BPM'] = i['bpm'];
      }
    }
  }

  //谱师筛选
  if (onlysearch == 0 || onlysearch == 5 || onlysearch == null) {
    if (title == '') {
      log('跳过谱师筛选');
    } else {
      for (var i in songsData['songs']) {
        for (var j in i['difficulties']) {
          if (j['note_designer'].toLowerCase().contains(title.toLowerCase())) {
            songresult.add(i['id']);
            searchinfo[i['id']] ??= {};
            (searchinfo[i['id']] as Map)['note_designer'] = j['note_designer'];
          }
        }
      }
    }
  }

  if (specialfilter == 1) {
    List songData = json.decode(
      File('${dataPath.path}/res/zxzrsongs.json').readAsStringSync(),
    );
    try {
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
                  searchinfo[i['id']] ??= {};
                  (searchinfo[i['id']] as Map)['notecounts'] ??= {};
                  (searchinfo[i['id']] as Map)['notecounts'] = {
                    notetype: j['notecounts'][notetype],
                  };
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
              for (var j in i['charts']) {
                if (j['notecounts'][notetype] >=
                        int.tryParse(title.split(' ')[1]) &&
                    j['notecounts'][notetype] <=
                        int.tryParse(title.split(' ')[2])) {
                  songresult.add(i['id']);
                  searchinfo[i['id']] ??= {};
                  (searchinfo[i['id']] as Map)['notecounts'] ??= {};
                  (searchinfo[i['id']] as Map)['notecounts'] = {
                    notetype: j['notecounts'][notetype],
                  };
                }
              }
            }
          }
        }
      }
    } catch (e, strack) {
      log('特殊筛选失败');
      log('$e \n$strack', name: 'search.dart', level: 1000);
    }
  } else {
    log('跳过特殊筛选');
  }

  //筛选游玩记录
  if (ifplay == '-1') {
    log('跳过游玩记录筛选');
  } else if (ifplay == '1') {
    //已游玩
    log('已游玩');
    List<int> songresult5 = [];
    List playhistoryid = [];
    for (var i in playhistory) {
      if (!playhistoryid.contains(i['id'])) {
        playhistoryid.add(i['id']);
      }
    }

    for (var i in songresult) {
      if (playhistoryid.contains(i)) {
        songresult5.add(i);
      }
    }
    songresult = songresult5.toSet();
  } else if (ifplay == '0') {
    //未游玩
    log('未游玩');
    List<int> songresult5 = [];
    List playhistoryid = [];
    for (var i in playhistory) {
      if (!playhistoryid.contains(i['id'])) {
        playhistoryid.add(i['id']);
      }
    }
    for (var i in songresult) {
      if (!playhistoryid.contains(i)) {
        songresult5.add(i);
      }
    }
    songresult = songresult5.toSet();
  }

  List songresultMap = [];
  for (var i in songresult) {
    for (var j in songsData['songs']) {
      if (i == j['id']) {
        songresultMap.add(j);
      }
    }
  }

  //筛选流派
  if (genre.contains('-1')) {
    log('跳过流派');
  } else {
    List songresult2 = [];
    try {
      List genreList = [];
      for (var j in songsData['genres']) {
        if (genre.contains(j['id'].toString())) {
          genreList.add(j['genre']);
        }
      }

      for (var i in songresultMap) {
        if (genreList.contains(i['genre'])) {
          songresult2.add(i);
        }
      }
    } catch (e) {
      log('error $e', name: 'search.dart', level: 1000);
    }
    songresultMap = songresult2;
  }

  //筛选版本
  if (version.contains('-1')) {
    log('跳过版本');
  } else {
    List songresult3 = [];
    for (var i in songresultMap) {
      if (version.contains(i['version'].toString())) {
        songresult3.add(i);
      }
    }
    songresultMap = songresult3;
  }

  //筛选难度
  if (double.tryParse(difficultydown) != null &&
      double.tryParse(difficultyup) != null) {
    if (difficultydown == '-1' && difficultyup == '-1') {
      log('跳过难度');
    } else {
      if (difficultyup == '-1') {
        difficultyup = '17';
      }
      List songresult4 = [];
      for (var i in songresultMap) {
        for (var j in i['difficulties']) {
          if (double.parse(difficultydown) <= j['level_value'] &&
              j['level_value'] <= double.parse(difficultyup)) {
            songresult4.add(i);
            break;
          }
        }
      }
      songresultMap = songresult4;
    }
  }

  if (isSearch == false) {
    List idlist = [];
    for (var i in songresultMap) {
      idlist.add(i['id']);
    }
    if (idlist.isEmpty) return {};
    List<int> resultIds = [];
    final random = math.Random();
    if (count != null) {
      for (var i = 0; i < count; i++) {
        final randomId = random.nextInt(idlist.length);
        resultIds.add(idlist[randomId]);
      }
      List randomresult = [];
      for (var i in songsData['songs']) {
        for (var j in resultIds) {
          if (i['id'] == j) {
            randomresult.add(i);
          }
        }
      }
      songresultMap = randomresult;
    }
  }
  log('结果：${songresultMap.length}');
  return {"songs": songresultMap, "searchinfo": searchinfo};
}
