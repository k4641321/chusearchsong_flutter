import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:marquee/marquee.dart';
import 'package:path_provider/path_provider.dart';

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

Widget returnScoreList({
  required List allscoredata,
  required Map<String, dynamic> songsdata,
  required BuildContext context,
}) {
  List<Widget> scorewidgetlist = [];

  for (var i in allscoredata) {
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
            songInfoDiffs.add(k['level_value']);
          }
        }
        for (var k in songsdata['versions']) {
          if (k['version'] == j['version']) {
            versionname = k['title'];
          }
        }
        scorewidgetlist.add(
          InkWell(
            child: Card(
              child: Padding(
                padding: EdgeInsetsGeometry.all(8),
                child: Row(
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
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Text(
                              '${j['id']} - ${j['title']}      ${j['genre']} - $versionname  \n $songInfoDiffs',
                              textAlign: TextAlign.center,
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
  }

  return ListView.builder(
    itemBuilder: (context, index) => scorewidgetlist[index],
    itemCount: scorewidgetlist.length,
  );
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
