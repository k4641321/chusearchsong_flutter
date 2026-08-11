import 'package:cached_network_image/cached_network_image.dart';
import 'package:chusearchsong_flutter/function/fun.dart';
import 'package:chusearchsong_flutter/function/toolsfun/viewallgradespagefun.dart';
import 'package:flutter/material.dart';

import 'generateb50fun/generateb50.dart';

Map<String, dynamic> vsresult({
  required List myscore,
  required List friendscore,
}) {
  Map<String, dynamic> result = {};
  result['mychart'] = myscore.length;
  result['friendchart'] = friendscore.length;
  result['commonchart'] = 0;
  result['win'] = 0;
  result['lose'] = 0;
  result['draw'] = 0;
  result['commontsong'] = [];

  for (var i in myscore) {
    for (var j in friendscore) {
      if (i['id'] == j['id'] && i['level_index'] == j['level_index']) {
        result['commonchart']++;
        result['commontsong'].add([i, j]);
      }
      if (i['id'] == j['id'] && i['level_index'] == j['level_index']) {
        if (i['score'] > j['score']) {
          result['win']++;
        } else if (i['score'] < j['score']) {
          result['lose']++;
        } else if (i['score'] == j['score']) {
          result['draw']++;
        }
      }
    }
  }
  // print('${result['win']} ${result['lost']} ${result['draw']}');

  return result;
}

List<Widget> returnvsresultwidget({
  required List commonchart,
  required Map<String, dynamic> songsdata,
  required BuildContext context,
  String? winningandlosingstatus,
  int? levelindex,
}) {
  List<Widget> result = [];
  for (var i in commonchart) {
    Map<String, dynamic> songdata = {};
    late int songid;
    late double diffvalue;
    // late int diffindex;
    late Icon icon;
    late String versionname;
    if (levelindex != null) {
      if (i[0]['level_index'] != levelindex) {
        continue;
      }
    }
    for (var j in songsdata['songs']) {
      if (j['id'] == i[0]['id']) {
        songdata = j;
        songid = j['id'];
        for (var k in songsdata['versions']) {
          if (j['version'] == k['version']) {
            versionname = k['title'];
            break;
          }
        }

        if (((j['difficulties'] as List).last as Map).containsKey(
          'origin_id',
        )) {
          songid = (j['difficulties'] as List).last['origin_id'];
        }
        for (var k in j['difficulties']) {
          if (k['difficulty'] == i[0]['level_index']) {
            diffvalue = k['level_value'].toDouble();
            break;
          }
        }
        break;
      }
    }
    if (i[0]['score'] > i[1]['score']) {
      icon = Icon(Icons.arrow_forward);
    } else if (i[0]['score'] < i[1]['score']) {
      icon = Icon(Icons.arrow_back);
    } else if (i[0]['score'] == i[1]['score']) {
      icon = Icon(Icons.drag_handle);
    }
    if (winningandlosingstatus == 'win' && i[0]['score']! <= i[1]['score']) {
      continue;
    } else if (winningandlosingstatus == 'lose' &&
        i[0]['score']! >= i[1]['score']) {
      continue;
    } else if (winningandlosingstatus == 'draw' &&
        i[0]['score']! != i[1]['score']) {
      continue;
    }
    result.add(
      InkWell(
        onTap: () => interSongInfo(
          songbasedata: songdata,
          context: context,
          versionname: versionname,
        ),
        child: Card(
          child: Padding(
            padding: EdgeInsetsGeometry.all(8),
            child: Row(
              // mainAxisAlignment: MainAxisAlignment.end,
              children: [
                CachedNetworkImage(
                  height: 75,
                  width: 75,
                  imageUrl:
                      'https://assets2.lxns.net/chunithm/jacket/$songid.png',
                  errorWidget: (context, url, error) => Icon(Icons.error),
                ),
                Expanded(
                  child: Text.rich(
                    TextSpan(
                      text: '${songdata['title']}\n',
                      children: [
                        TextSpan(
                          text:
                              '${returnDiffName(i[0]['level_index'])} $diffvalue',
                          style: TextStyle(
                            color: diffcolor(diffindex: i[0]['level_index']),
                          ),
                        ),
                      ],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                Expanded(
                  child: Text.rich(
                    TextSpan(
                      text: '${i[0]['score']}\n',
                      children: [
                        TextSpan(
                          text: (i[0]['rank'] as String).replaceAll('p', '+'),
                        ),
                      ],
                    ),
                    textAlign: TextAlign.center,
                    style: TextStyle(color: returnColor(i[0]['score'])),
                  ),
                ),
                Expanded(child: icon),
                Expanded(
                  child: Text.rich(
                    TextSpan(
                      text: '${i[1]['score']}\n',
                      children: [
                        TextSpan(
                          text: (i[1]['rank'] as String).replaceAll('p', '+'),
                        ),
                      ],
                    ),
                    textAlign: TextAlign.center,
                    style: TextStyle(color: returnColor(i[0]['score'])),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  return result;
}
