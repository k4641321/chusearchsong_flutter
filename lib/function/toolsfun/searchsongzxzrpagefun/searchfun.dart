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
                  errorWidget: (context, url, error) => Text('加载失败'),
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
    if (i['title'].toLowerCase().contains(title.toLowerCase())) {
      // log('匹配');
      songresult.add(i['id']);
    }
  }

  //曲师筛选

  for (var i in songData) {
    if (i['artist'].toLowerCase().contains(title.toLowerCase())) {
      // log('曲师匹配 ${i['artist']}');
      songresult.add(i['id']);
    }
  }

  //id筛选
  try {
    int.parse(title);
    for (var i in songData) {
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
      if (!(i['bpm']['mode'] <= bpmup && i['bpm']['mode'] >= bpmdown)) {
        songresult.remove(i['id']);
      }
    }
  }

  //谱师筛选
  if (title == '') {
    log('跳过谱师筛选');
  } else {
    for (var i in songData) {
      for (var j in i['charts']) {
        if (j['charter'].toLowerCase().contains(title.toLowerCase())) {
          songresult.add(i['id']);
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
        if (double.parse(difficultydown) <= j['const'] &&
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
