import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:convert';
import './request.dart';
import 'dart:developer';
import '../pages/songinfopage.dart';
import 'dart:math' as math;

Future<List<int>> returnidList() async {
  List<int> idList = [];
  Directory songDataPath = await getApplicationSupportDirectory();
  String jsonString = await File(
    '${songDataPath.path}/res/songs.json',
  ).readAsString();
  Map<String, dynamic> songData = json.decode(jsonString);
  for (var i in songData['songs']) {
    idList.add(i['id']);
  }
  return idList;
}

// ... existing code ...
Future<List<Widget>> randomSong({
  required BuildContext context,
  required int count,
}) async {
  try {
    Directory songDataPath = await getApplicationSupportDirectory();
    String jsonString = await File(
      '${songDataPath.path}/res/songs.json',
    ).readAsString();
    Map<String, dynamic> songData = json.decode(jsonString);

    List<int> idList = await returnidList();
    List<Widget> songWidgets = [];
    final random = math.Random();
    List<int> resultIds = [];
    for (var i=0;i<count;i++) {
      final randomId = random.nextInt(idList.length);
      resultIds.add(idList[randomId]);
    }
    // final randomId = random.nextInt(idList.length);
    // final selectId = idList[randomId];

    // 查找选中的歌曲
    List selectedSong = [];
    for (var i in songData['songs']) {
      for (var j in resultIds) {
        if (i['id'] == j) {
          selectedSong.add(i);
        }
      }
    }

    // 查找版本名称
    String versionname = '';
    for (var i in selectedSong) {
      for (var j in songData['versions']) {
        if (j['version'] == i['version']) {
          versionname = j['title'];
          songWidgets.add(
            Row(
              children: [
                Expanded(
                  child: InkWell(
                    key: ValueKey(i['id']),
                    onTap: () async {
                      interSongInfo(
                        i: i!,
                        context: context,
                        versionname: versionname,
                      );
                    },
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          '${i['id']} - ${i['title']}      ${i['genre']} - $versionname',
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        }
      }
    }
    return songWidgets;
  } catch (e) {
    if (!context.mounted) return [Text('无结果')];
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('错误: $e')));
    log('error $e', name: 'search.dart', level: 1000);
    return [Text('无结果')];
  }
}

Future<void> interSongInfo({
  required Map<String, dynamic> i,
  required BuildContext context,
  required String versionname,
}) async {
  List<DataRow> songData = [];
  Map<String, dynamic> songInfo = {};
  List<dynamic> songInfoDiffs = [];
  try {
    songData = await returnSongInfo(i['id']);
  } catch (e) {
    log('error $e', name: 'search.dart', level: 1000);
  }
  try {
    songInfo = await getSongInfo(i['id']);
    songInfoDiffs = songInfo['difficulties'];
  } catch (e) {
    log('error $e', name: 'search.dart', level: 1000);
  }

  List<Widget> information = [];
  int songid = i['id'];
  if (songInfo.keys.contains('map')) {
    information.add(
      Text('地图: ${songInfo['map']}', style: const TextStyle(fontSize: 20)),
    );
  }
  if (songInfo.keys.contains('locked')) {
    if (songInfo['locked'] == true) {
      information.add(Text('需解锁', style: const TextStyle(fontSize: 20)));
    } else {
      information.add(Text('无需解锁', style: const TextStyle(fontSize: 20)));
    }
  }
  if (songInfo.keys.contains('rights')) {
    information.add(
      Text('版权: ${songInfo['rights']}', style: const TextStyle(fontSize: 20)),
    );
  }

  final kanji = songInfoDiffs.lastWhere(
    (d) => d.keys.contains('kanji'),
    orElse: () => null,
  );
  if (kanji != null) {
    final kanjiText = kanji['kanji'];
    information.add(
      Text('谱面属性: $kanjiText', style: const TextStyle(fontSize: 20)),
    );
  }

  final star = songInfoDiffs.lastWhere(
    (d) => d.keys.contains('star'),
    orElse: () => null,
  );
  if (star != null) {
    final starValue = star['star'];
    information.add(
      Text('星数: $starValue', style: const TextStyle(fontSize: 20)),
    );
  }

  if (information.isEmpty) {
    information.add(Text('无信息', style: const TextStyle(fontSize: 20)));
  }

  final originid = songInfoDiffs.lastWhere(
    (d) => d.keys.contains('origin_id'),
    orElse: () => null,
  );
  if (originid != null) {
    songid = originid['origin_id'];
  }

  if (!context.mounted) return;
  await Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => SongInfoPage(
        song: i,
        versionname: versionname,
        rowsData: songData,
        information: information,
        songid: songid,
      ),
    ),
  );
  // log('未完成 ${i['id']}');
}
