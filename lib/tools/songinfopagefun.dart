import 'dart:developer';
import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:path_provider/path_provider.dart';
import 'request.dart';

List<Widget> returnDiffTabBar({required Map song}) {
  List<Widget> result = [];
  List diff = song['difficulties'];
  for (var i in diff) {
    switch (i['difficulty']) {
      case 0:
        result.add(const Text('Basic'));
        break;
      case 1:
        result.add(const Text('Advanced'));
        break;
      case 2:
        result.add(const Text('Expert'));
        break;
      case 3:
        result.add(const Text('Master'));
        break;
      case 4:
        result.add(const Text('ULtima'));
        break;
      case 5:
        result.add(const Text('World\'s End'));
        break;
      default:
        result.add(const Text('Unknown'));
    }
  }
  return result;
}

Future<Widget> returnscore({
  required int song,
  required int i,
  required Color corlor,
}) async {
  //加载成绩
  final path = await getApplicationSupportDirectory();
  final file = File('${path.path}/res/allscore.json');
  Map<String, dynamic> allscore1 = json.decode(file.readAsStringSync());
  List allscore = allscore1['data'];
  Widget result = const Text('无成绩');
  print(i);
  try {
    for (var j in allscore) {
      // print('${j['id']},$song');
      if (j['id'] == song) {
        // print('${j['id']},$song');
        if (j['level_index'] == i) {
          result = InkWell(
            child: Card(
              color: corlor,
              child: Padding(
                padding: EdgeInsetsGeometry.all(8),
                child: Column(
                  children: [
                    Row(children: [Icon(Icons.star), Text('历史成绩')]),
                    Text('score:   ${j['score']}'),
                    const Divider(),
                    Text('rating:   ${j['rating']}'),
                    const Divider(),
                    Text('over_power:   ${j['over_power']}'),
                    const Divider(),
                    Text('clear:   ${j['clear']}'),
                    const Divider(),
                    Text('full_combo:   ${j['full_combo']}'),
                    const Divider(),
                    Text('full_chain:   ${j['full_chain']}'),
                    const Divider(),
                    Text('rank:   ${j['rank']}'),
                  ],
                ),
              ),
            ),
          );
        }
      }
    }
    return result;
  } catch (e) {
    return result;
  }
}

Future<List<Widget>> returnDiffTabBarView({
  required Map<String, dynamic> song,
  required Color color,
}) async {
  List<Widget> result = [];
  try {
    Map<String, dynamic> songInfo = await getSongInfo(song['id']);
    List diffs = songInfo['difficulties'];

    for (var i = 0; i < diffs.length; i++) {
      var song2 = diffs[i];
      List<Widget> result2 = [];
      result2.add(await returnscore(song: song['id'], i: i, corlor: color));
      result2.add(
        InkWell(
          child: Card(
            color: color,
            child: Padding(
              padding: EdgeInsetsGeometry.all(8),
              child: Column(
                children: [
                  Row(children: [Icon(Icons.queue_music), Text('谱面信息')]),
                  Text(
                    '谱师:       ${song2['note_designer']}',
                    textAlign: TextAlign.start,
                  ),
                  const Divider(),
                  Text(
                    '定数:      ${song2['level_value']}',
                    style: TextStyle(fontSize: 15),
                  ),
                  const Divider(),
                  Text(
                    'total:      ${song2['notes']['total']}',
                    style: TextStyle(fontSize: 15),
                  ),
                  const Divider(),
                  Text(
                    'tap:      ${song2['notes']['tap']}',
                    style: TextStyle(fontSize: 15),
                  ),
                  const Divider(),
                  Text(
                    'hold:      ${song2['notes']['hold']}',
                    style: TextStyle(fontSize: 15),
                  ),
                  const Divider(),
                  Text(
                    'slide:      ${song2['notes']['slide']}',
                    style: TextStyle(fontSize: 15),
                  ),
                  const Divider(),
                  Text(
                    'air:       ${song2['notes']['air']}',
                    style: TextStyle(fontSize: 15),
                  ),
                  const Divider(),
                  Text(
                    'flick:       ${song2['notes']['flick']}',
                    style: TextStyle(fontSize: 15),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
      result.add(Column(children: result2));
    }
  } catch (e) {
    int length = song['difficulties'].length;
    for (var i = 0; i < length; i++) {
      result.add(Row(children: [Text('获取谱面信息失败')]));
    }
    log('$e', name: 'songinfopagefun.dart', level: 1000);
    return result;
  }

  return result;
}
