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
Future<Widget> randomSong({required BuildContext context}) async {
  Directory songDataPath = await getApplicationSupportDirectory();
  String jsonString = await File(
    '${songDataPath.path}/res/songs.json',
  ).readAsString();
  Map<String, dynamic> songData = json.decode(jsonString);

  List<int> idList = await returnidList();
  if (idList.isEmpty) {
    return Text('没有可用的歌曲');
  }

  final random = math.Random();
  final randomId = random.nextInt(idList.length);
  final selectId = idList[randomId];

  // 查找选中的歌曲
  Map<String, dynamic>? selectedSong;
  for (var i in songData['songs']) {
    if (i['id'] == selectId) {
      selectedSong = i;
      break;
    }
  }

  if (selectedSong == null) {
    return Text('未找到歌曲');
  }

  // 查找版本名称
  String versionname = '';
  for (var j in songData['versions']) {
    if (j['version'] == selectedSong['version']) {
      versionname = j['title'];
      break;
    }
  }

  return InkWell(
    key: ValueKey(selectedSong['id']),
    onTap: () async {
      interSongInfo(
        i: selectedSong!,
        context: context,
        versionname: versionname,
      );
    },
    child: Text(
      '${selectedSong['id']} - ${selectedSong['title']}      ${selectedSong['genre']} - $versionname',
      textAlign: TextAlign.center,
    ),
  );
}
// ... existing code ...

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
  Navigator.push(
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
