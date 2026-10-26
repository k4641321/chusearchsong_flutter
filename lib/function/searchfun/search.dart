import 'dart:developer';
import 'package:chusearchsong_flutter/function/commonfun.dart';
import 'package:chusearchsong_flutter/function/toolsfun/generateb50fun/generateb50.dart';
import 'package:chusearchsong_flutter/function/writeandreadfun.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;
//我操了，自己都快看力竭了，太石了，自己都要看不懂了

//生成组件
Future<List<Widget>> search({
  required Map<String, dynamic> songsData,
  required Map<String, dynamic> songresultMap,
  required BuildContext context,
  Map<int, dynamic>? searchinfo,
  VoidCallback? voidCallbackFunction,
  bool issearch = true,
  Future<void> Function(int)? chartsharepagefun,
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
        songsData: songsData,
        searchinfo: searchinfo,
        issearch: issearch,
        chartsharepagefun: chartsharepagefun,
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
  songresultWidget.add(SizedBox(height: 80 + 25));
  return songresultWidget;
}

Future<Map<String, dynamic>> filter(
  Map<String, dynamic> songsData,
  Map<String, dynamic> aliasData,
  List zxzrSongsData,
  List playhistory,
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
  int? difficultyIndex,
) async {
  log(
    '$title $genre $version $difficultydown $difficultyup $ifplay $bpmup $bpmdown $isSearch $count $specialfilter $onlysearch $difficultyIndex',
  );

  //信息展示
  Map<int, dynamic> searchinfo = {};

  //初步筛选
  Set<int> songresult = {};
  final titleLower = title.toLowerCase();

  // BPM 条件
  final bool bpmSet = bpmup != null || bpmdown != null;
  final int bpmDown = bpmdown ?? 0;
  final int bpmUp = bpmup ?? 9999;

  // 是否设置了任何筛选条件（搜索框 + 各维度）
  final bool hasKeyword = title.isNotEmpty;
  final bool hasGenre = !genre.contains('-1');
  final bool hasVersion = !version.contains('-1');
  final bool hasDifficulty =
      !(difficultydown == '-1' && difficultyup == '-1') ||
      (difficultyIndex ?? -1) != -1;
  final bool hasPlay = ifplay != '-1';

  if (!hasKeyword &&
      !hasGenre &&
      !hasVersion &&
      !hasDifficulty &&
      !bpmSet &&
      !hasPlay &&
      isSearch == true) {
    log('未选择条件');
    return {};
  }

  // 关键词匹配：标题/曲师/Id/谱师，由 onlysearch 决定搜哪些字段
  bool keywordMatch(Map song) {
    if (title.isEmpty) return true;
    if (onlysearch == null || onlysearch == 0 || onlysearch == 1) {
      if (song['title'].toLowerCase().contains(titleLower)) return true;
    }
    if (onlysearch == null || onlysearch == 0 || onlysearch == 2) {
      if (song['artist'].toLowerCase().contains(titleLower)) return true;
    }
    if (onlysearch == null || onlysearch == 0 || onlysearch == 3) {
      if (int.tryParse(titleLower) != null &&
          song['id'].toString().contains(titleLower)) {
        return true;
      }
    }
    if (onlysearch == null || onlysearch == 0 || onlysearch == 5) {
      for (var j in song['difficulties']) {
        if (j['note_designer'].toLowerCase().contains(titleLower)) {
          return true;
        }
      }
    }
    return false;
  }

  // 关键词筛选（仅别名模式跳过，别名单独处理）
  if (onlysearch != 4) {
    for (var i in songsData['songs'] as List) {
      if (keywordMatch(i)) {
        songresult.add(i['id']);
      }
    }
  } else {
    log('跳过Id');
  }

  //别名筛选
  if ((onlysearch == null || onlysearch == 0 || onlysearch == 4) &&
      aliasData.isNotEmpty &&
      title.isNotEmpty) {
    for (var i in aliasData['aliases']) {
      for (var j in i['aliases']) {
        if (j.toLowerCase().contains(titleLower)) {
          songresult.add(i['song_id']);
          searchinfo[i['song_id']] ??= {};
          (searchinfo[i['song_id']] as Map)['alias'] = j;
          break;
        }
      }
    }
  } else {
    log("别名");
  }

  //多种音符组合筛选
  if (specialfilter == 1) {
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
          ].contains(i.split(' ')[0])) {
            listtobefiltered.add(i);
          }
        }
        // int listtobefilteredcount = listtobefiltered.length;
        for (var song in zxzrSongsData) {
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
            for (var i in zxzrSongsData) {
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
            for (var i in zxzrSongsData) {
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

  // 构建 id -> 歌曲 索引，避免双重循环
  final songsById = <int, dynamic>{};
  for (final song in songsData['songs'] as List) {
    songsById[song['id'] as int] = song;
  }

  // 组装候选列表
  List songresultMap = [];
  for (final id in songresult) {
    final song = songsById[id];
    if (song != null) {
      songresultMap.add(song);
    }
  }

  //筛选 BPM（与其它条件可任意组合）
  if (bpmSet) {
    songresultMap = songresultMap.where((song) {
      final bpm = song['bpm'];
      if (bpm is! num) return false;
      return bpm >= bpmDown && bpm <= bpmUp;
    }).toList();
  } else {
    log("跳过BPM筛选");
  }

  //筛选游玩记录
  if (ifplay != '-1' && playhistory.isNotEmpty) {
    final playedIds = <dynamic>{};
    for (var i in playhistory) {
      playedIds.add(i['id']);
    }
    songresultMap = songresultMap.where((song) {
      final played = playedIds.contains(song['id']);
      return ifplay == '1' ? played : !played;
    }).toList();
  } else {
    log("跳过游玩记录筛选");
  }

  //筛选流派
  if (!genre.contains('-1')) {
    final genreList = <dynamic>{};
    for (var j in songsData['genres']) {
      if (genre.contains(j['id'].toString())) {
        genreList.add(j['genre']);
      }
    }
    songresultMap = songresultMap
        .where((song) => genreList.contains(song['genre']))
        .toList();
  } else {
    log("跳过流派筛选");
  }

  //筛选版本
  if (!version.contains('-1')) {
    songresultMap = songresultMap
        .where((song) => version.contains(song['version'].toString()))
        .toList();
  } else {
    log("跳过版本筛选");
  }

  //筛选难度（可与难度类型 difficultyIndex 组合）
  final double? difficultyDownValue = double.tryParse(difficultydown);
  final double? difficultyUpValue = double.tryParse(difficultyup);
  if (difficultyDownValue != null && difficultyUpValue != null) {
    if (difficultydown == '-1' &&
        difficultyup == '-1' &&
        difficultyIndex == -1) {
      log('跳过难度');
    } else {
      final double down = difficultyDownValue;
      final double up = difficultyup == '-1' ? 17.0 : difficultyUpValue;
      songresultMap = songresultMap.where((song) {
        return song['difficulties'].any((j) {
          if (difficultyIndex != -1 && j['difficulty'] != difficultyIndex) {
            return false;
          }
          return down <= j['level_value'] && j['level_value'] <= up;
        });
      }).toList();
    }
  }

  //随机筛选
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
      List randomhistory = await (await ReadData.create())
          .readRandomMusicHistory();
      randomhistory.insert(0, {
        "time": DateTime.now().toString(),
        "ids": resultIds,
      });
      (await WriteData.create()).writeRandomMusicHistory(randomhistory);
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
