import 'package:flutter/material.dart';
import 'package:http/http.dart';
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
        result.add(const Text('World\'end'));
        break;
      default:
        result.add(const Text('Unknown'));
    }
  }
  return result;
}

Future<List<Widget>> returnDiffTabBarView({required Map song}) async {
  List<Widget> result = [];
  try {
    Map<String, dynamic> songInfo = await getSongInfo(song['id']);
    List diffs = songInfo['difficulties'];
    for (var i in diffs) {
      result.add(
        Column(
          children: [
            Text('定数: ${i['level_value']}'),
            Text('total: ${i['notes']['total']}'),
            Text('tap: ${i['notes']['tap']}'),
            Text('hold: ${i['notes']['hold']}'),
            Text('slide: ${i['notes']['slide']}'),
            Text('air: ${i['notes']['air']}'),
            Text('flick: ${i['notes']['flick']}'),
            Text('谱师: ${i['note_designer']}'),
          ],
        ),
      );
    }
  } catch (e) {
    int length = song['difficulties'].length;
    for (var i = 0; i < length; i++) {
      result.add(Row(children: [Text('获取谱面信息失败')]));
    }

    return result;
  }

  return result;
}
