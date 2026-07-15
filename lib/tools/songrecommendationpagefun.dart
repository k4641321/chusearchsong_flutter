import 'dart:developer';
import 'dart:io';
import 'dart:convert';
import 'package:chusearchsong_flutter/tools/fun.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import '../tools/request.dart';

Future<Widget> oldSongRecommendation({
  required bool ifYueJi,
  required BuildContext context,
}) async {
  List<Widget> songresultWidget = [];
  double maxdiff;
  double mindiff = 0;
  try {
    //获取b50
    final path = await getApplicationSupportDirectory();
    String b50str = await File("${path.path}/res/b50.json").readAsString();
    Map<String, dynamic> b50 = jsonDecode(b50str)['data'];
    //获取b30
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
    if (ifYueJi == false) {
      while ((mindiff - b30min) <= 0) {
        mindiff += 0.1;
        // log(mindiff.toString());
      }
      log('最终最小难度为：${mindiff.toString()}');
    }
    //加载歌曲列表
    Map<String, dynamic> songsdata = jsonDecode(
      await File("${path.path}/res/songs.json").readAsString(),
    );
    // log(songsdata['songs'].length.toString());
    //找出符合条件的歌曲
    //获取旧版本号
    Map<String, dynamic> config = jsonDecode(
      await File("${path.path}/config.json").readAsString(),
    );
    List newversions = config['latest_version'];
    List<int> oldversion = [];
    for (var i in songsdata['versions']) {
      if (!newversions.contains(i['title'] as String)) {
        oldversion.add(i['version']);
      }
    }
    List resultsongs = [];
    for (var i in songsdata['songs']) {
      for (var j in i['difficulties']) {
        if ((j['level_value'] + 2) > mindiff &&
            oldversion.contains(j['version'])) {
          resultsongs.add(i);
        }
      }
    }
    log(resultsongs.length.toString());
    //构建组件

    for (var i in resultsongs) {
      List<dynamic> songInfoDiffs = [];
      String versionname = '';
      for (var j in songsdata['versions']) {
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
          // key: ValueKey(i['id']),
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
  } catch (e, strack) {
    return Text("$e\n$strack");
  }

  return ListView(children: songresultWidget);
}
