import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

Future<List<Widget>> search(
  String title,
  String genre,
  String version,
  String difficultydown,
  String difficultyup,
) async {
  // 加载曲目数据
  String jsonString = await rootBundle.loadString('res/list.json');
  Map<String, dynamic> songData = json.decode(jsonString);
  List<dynamic> songresult = [];

  //加载别名
  String aliasString = await rootBundle.loadString('res/alias.json');
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
  print(aliasresult);
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
  print(aliasresult2);
  songresult.addAll(aliasresult2);
  print(songresult);

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
            print(genre);
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
      print('error $e');
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
          break;
        }
      }
      songresult4.add(i);
    }
    songresult = songresult4;
  }

  List<Widget> songresultWidget = [];
  log('添加组件');
  for (var i in songresult) {
    String versionname = '';
    for (var j in songData['versions']) {
      if (j['version'] == i['version']) {
        versionname = j['title'];
      }
    }
    songresultWidget.add(const Divider());
    songresultWidget.add(
      Text(
        '${i['id']} - ${i['title']}      ${i['genre']} - $versionname',
        textAlign: TextAlign.center,
      ),
    );
  }
  print(songresult);
  return songresultWidget;
}
