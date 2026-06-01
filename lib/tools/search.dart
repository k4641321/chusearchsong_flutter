import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import '../tools/fun.dart';

Future<List<Widget>> search(
  String title,
  String genre,
  String version,
  String difficultydown,
  String difficultyup,
  BuildContext context,
) async {
  // 加载曲目数据
  final dataPath = await getApplicationSupportDirectory();
  String jsonString = await File(
    '${dataPath.path}/res/songs.json',
  ).readAsString();
  Map<String, dynamic> songData = json.decode(jsonString);
  List<dynamic> songresult = [];

  //加载别名
  String aliasString = await File(
    '${dataPath.path}/res/alias.json',
  ).readAsString();
  Map<String, dynamic> aliasData = json.decode(aliasString);
  List aliasresult = [];

  log('$title $genre $version $difficultydown $difficultyup');

  //初步筛选
  if (title == '' &&
      genre == '-1' &&
      version == '-1' &&
      difficultydown == '-1' &&
      difficultyup == '-1') {
    log('未选择条件');
    return [];
  }
  for (var i in songData['songs']) {
    if (i['title'].toLowerCase().contains(title.toLowerCase())) {
      songresult.add(i);
    }
  }
  List songresultids = [];
  for (var i in songresult) {
    songresultids.add(i['id']);
  }

  //曲师筛选
  List artistresult = [];
  for (var i in songData['songs']) {
    if (i['artist'].toLowerCase().contains(title.toLowerCase())) {
      log('曲师匹配 ${i['artist']}');
      artistresult.add(i['id']);
    }
  }
  List artistresult2 = [];
  for (var i in artistresult) {
    if (!songresultids.contains(i)) {
      for (var j in songData['songs']) {
        if (i == j['id']) {
          artistresult2.add(j);
        }
      }
    }
  }
  songresult.addAll(artistresult2);

  //id筛选

  for (var i in songData['songs']) {
    if (i['id'].toString().contains(title)) {
      songresult.add(i);
    }
  }

  //别名筛选
  for (var i in aliasData['aliases']) {
    for (var j in i['aliases']) {
      if (j.toLowerCase().contains(title.toLowerCase())) {
        aliasresult.add(i['song_id']);
        log('别名匹配 $j');
        break;
      }
    }
  }
  // print(aliasresult);
  List aliasresult2 = [];
  for (var i in aliasresult) {
    if (!songresultids.contains(i)) {
      for (var j in songData['songs']) {
        if (i == j['id']) {
          aliasresult2.add(j);
        }
      }
    }
  }
  // print(aliasresult2);
  songresult.addAll(aliasresult2);
  // print(songresult);

  //筛选流派
  if (genre == '-1') {
    log('跳过流派');
  } else {
    List songresult2 = [];
    try {
      if (genre.isNotEmpty && RegExp(r'^-?\d+$').hasMatch(genre.trim())) {
        int genreId = int.parse(genre.trim());
        for (var j in songData['genres']) {
          if (j['id'] == genreId) {
            genre = j['genre'];
            // print(genre);
            break; // 找到后就跳出循环
          }
        }
      }
      // 如果 genre 不是有效的ID，就直接当作流派名称使用

      for (var i in songresult) {
        if (i['genre'] == genre) {
          songresult2.add(i);
        }
      }
    } catch (e) {
      log('error $e', name: 'search.dart', level: 1000);
    }
    songresult = songresult2;
  }
  //筛选版本
  if (version == '-1') {
    log('跳过版本');
  } else {
    List songresult3 = [];
    for (var i in songresult) {
      if (i['version'] == int.parse(version)) {
        songresult3.add(i);
      }
    }
    songresult = songresult3;
  }

  //筛选难度
  if (difficultydown == '-1' && difficultyup == '-1') {
    log('跳过难度');
  } else {
    List songresult4 = [];
    for (var i in songresult) {
      for (var j in i['difficulties']) {
        if (double.parse(difficultydown) <= j['level_value'] &&
            j['level_value'] <= double.parse(difficultyup)) {
          songresult4.add(i);
          break;
        }
      }
    }
    songresult = songresult4;
  }

  List<Widget> songresultWidget = [];
  log('添加组件');
  for (var i in songresult) {
    List<dynamic> songInfoDiffs = [];
    String versionname = '';
    for (var j in songData['versions']) {
      if (j['version'] == i['version']) {
        versionname = j['title'];
      }
    }
    for (var k in i['difficulties']) {
      songInfoDiffs.add(k['level_value']);
    }
    // songresultWidget.add(const Divider());
    songresultWidget.add(
      InkWell(
        key: ValueKey(i['id']),
        onTap: () async {
          interSongInfo(i: i, context: context, versionname: versionname);
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
                // Image.network(
                //   'https://assets2.lxns.net/chunithm/jacket/${i['id']}.png',
                //   errorBuilder: (context, error, stackTrace) => Text('图片加载失败'),
                //   width: 55,
                //   height: 55,
                // ),
                Expanded(
                  child: Text(
                    '${i['id']} - ${i['title']}      ${i['genre']} - $versionname  \n $songInfoDiffs',
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





// List<DataRow> songData = [];
        // Map<String, dynamic> songInfo = {};
        // List<dynamic> songInfoDiffs = [];
        // try {
        //   songData = await returnSongInfo(i['id']);
        // } catch (e) {
        //   log('error $e', name: 'search.dart', level: 1000);
        // }
        // try {
        //   songInfo = await getSongInfo(i['id']);
        //   songInfoDiffs = songInfo['difficulties'];
        // } catch (e) {
        //   log('error $e', name: 'search.dart', level: 1000);
        // }

        // List<Widget> information = [];
        // int songid = i['id'];
        // if (songInfo.keys.contains('map')) {
        //   information.add(
        //     Text(
        //       '地图: ${songInfo['map']}',
        //       style: const TextStyle(fontSize: 20),
        //     ),
        //   );
        // }
        // if (songInfo.keys.contains('locked')) {
        //   if (songInfo['locked'] == true) {
        //     information.add(
        //       Text('需解锁', style: const TextStyle(fontSize: 20)),
        //     );
        //   } else {
        //     information.add(
        //       Text('无需解锁', style: const TextStyle(fontSize: 20)),
        //     );
        //   }
        // }
        // if (songInfo.keys.contains('rights')) {
        //   information.add(
        //     Text(
        //       '版权: ${songInfo['rights']}',
        //       style: const TextStyle(fontSize: 20),
        //     ),
        //   );
        // }

        // final kanji = songInfoDiffs.lastWhere(
        //   (d) => d.keys.contains('kanji'),
        //   orElse: () => null,
        // );
        // if (kanji != null) {
        //   final kanjiText = kanji['kanji'];
        //   information.add(
        //     Text('谱面属性: $kanjiText', style: const TextStyle(fontSize: 20)),
        //   );
        // }

        // final star = songInfoDiffs.lastWhere(
        //   (d) => d.keys.contains('star'),
        //   orElse: () => null,
        // );
        // if (star != null) {
        //   final starValue = star['star'];
        //   information.add(
        //     Text('星数: $starValue', style: const TextStyle(fontSize: 20)),
        //   );
        // }

        // if (information.isEmpty) {
        //   information.add(Text('无信息', style: const TextStyle(fontSize: 20)));
        // }

        // final originid = songInfoDiffs.lastWhere(
        //   (d) => d.keys.contains('origin_id'),
        //   orElse: () => null,
        // );
        // if (originid != null) {
        //   songid = originid['origin_id'];
        // }

        // if (!context.mounted) return;
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(
        //     builder: (context) => SongInfoPage(
        //       song: i,
        //       versionname: versionname,
        //       rowsData: songData,
        //       information: information,
        //       songid: songid,
        //     ),
        //   ),
        // );
        // // log('未完成 ${i['id']}');