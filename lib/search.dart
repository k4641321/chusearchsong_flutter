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
  // 注意：main 函数需加 async
  String jsonString = await rootBundle.loadString('res/list.json');
  Map<String, dynamic> songData = json.decode(jsonString);
  List<dynamic> songresult = [];

  for (var i in songData['genres']) {
    if (i['id'] == genre) {
      genre = i['genre'];
    }
  }
  //初步筛选
  for (var i in songData['songs']) {
    if (i['title'].toLowerCase().contains(title.toLowerCase())) {
      songresult.add(i);
    }
  }
  //筛选流派
  if (genre == '分类') {
    log('跳过流派');
  } else {
    List songresult2 = [];
    for (var i in songresult) {
      if (i['genre'] == genre) {
        songresult2.add(i);
      }
    }
    songresult = songresult2;
  }
  //筛选版本
  if (version == '-1') {
    log('跳过版本');
  } else {
    List songresult3 = [];
    for (var i in songresult) {
      if (i['version'] == version) {
        songresult3.add(i);
      }
    }
    songresult = songresult3;
  }

  List<Widget> songresultWidget = [];
  for (var i in songresult) {
    songresultWidget.add(Text(i['title']));
  }
  print(songresult);
  return songresultWidget;
}
