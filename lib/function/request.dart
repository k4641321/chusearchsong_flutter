import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

Future<void> saveNearcadeAllShop() async {
  final path = await getApplicationSupportDirectory();
  try {
    final rawJson = await requestNearcadeAllShop();
    // final decoded = json.decode(rawJson);
    await File(
      '${path.path}/res/segachara.json',
    ).writeAsString(rawJson, encoding: utf8);
  } catch (e) {
    log('$e', name: 'request.dart', level: 1000);
  }
}

Future<String> requestNearcadeAllShop() async {
  final uri = Uri.parse(
    'https://nearcade.phizone.cn/api/shops/?regionId=CN&limit=32767',
  );
  final response = await get(uri);
  return response.body;
}

Future<String> requestOAuthCallbackToken(String code) async {
  final uri = Uri.parse(
    'https://chusearchsong.4641321.xyz/api/oauth/callback?code=$code',
  );
  final response = await get(uri);
  return response.body;
}

Future<String> requestotherPlayerInfo(int friendcode) async {
  final uri = Uri.parse(
    'https://chusearchsong.4641321.xyz/api/playerinfo?friendcode=$friendcode',
  );
  final response = await get(uri);
  return response.body;
}

Future<String> loadSongsData() async {
  final path = await getApplicationSupportDirectory();
  return File('${path.path}/res/songs.json').readAsString();
}

Future<String> finduploadallscore(int friendcode) async {
  final uri = Uri.parse(
    'https://chusearchsong.4641321.xyz/api/finduploadallscore/$friendcode',
  );
  final response = await get(uri);
  // print(response.body);
  return response.body;
}

Future<String> uploadplayerscore() async {
  final uri = Uri.parse('https://chusearchsong.4641321.xyz/api/uploadallscore');
  List score = jsonDecode(
    await requestScore(token: await returnlxnstoken()),
  )['data'];
  Map<String, dynamic> playerdata = jsonDecode(
    await requestPlayerInfo(),
  )['data'];

  final response = await post(
    uri,
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({'friendcode': playerdata['friend_code'], 'data': score}),
  );
  return response.body;
}

Future<void> saveSegaCharaData() async {
  final path = await getApplicationSupportDirectory();
  try {
    final rawJson = await requestSegaCharaData();
    final decoded = json.decode(rawJson);
    await File(
      '${path.path}/res/segachara.json',
    ).writeAsString(json.encode(decoded), encoding: utf8);
  } catch (e) {
    log('$e', name: 'request.dart', level: 1000);
  }
}

Future<String> requestSegaCharaData() async {
  final response = await get(
    Uri.parse('https://chunithm.sega.jp/storage/json/chara.json'),
  );
  return response.body;
}

Future<String> requestuscount() async {
  final response = await get(
    Uri.parse('https://chusearchsong.4641321.xyz/api/usecount'),
  );
  return response.body;
}

Future<String> requestAnnouncement() async {
  final response = await get(
    Uri.parse('https://chusearchsong.4641321.xyz/api/announcement'),
  );
  return response.body;
}

Future<Map<String, dynamic>> readconfig() async {
  final path = await getApplicationSupportDirectory();
  String configstr = await File('${path.path}/config.json').readAsString();
  return json.decode(configstr);
}

Future<void> saveconfig(Map<String, dynamic> config) async {
  final path = await getApplicationSupportDirectory();
  await File('${path.path}/config.json').writeAsString(json.encode(config));
}

Future<String> requestChangeslog() async {
  final response = await get(
    Uri.parse('https://chusearchsong.4641321.xyz/api/changelog'),
  );
  return response.body;
}

Future<String> requestproxychartdata({
  required String charturl,
  required int levelindex,
}) async {
  final body = json.encode({"charturl": charturl, "level_index": levelindex});
  final response = await post(
    Uri.parse('https://chusearchsong.4641321.xyz/api/chart/'),
    headers: {'Content-Type': 'application/json'},
    body: body,
  );
  // log('status: ${response.statusCode}');
  // log('location: ${response.headers['location']}');
  // log('body: ${response.body}');
  return response.body;
}

Future<String> requestVersion() async {
  final response = await get(
    Uri.parse('https://chusearchsong.4641321.xyz/api/version'),
  );
  return response.body;
}

Future<void> savezxzrsongs() async {
  final path = await getApplicationSupportDirectory();
  try {
    final rawJson = await requestzxzrsongs();
    final decoded = json.decode(rawJson);
    await File(
      '${path.path}/res/zxzrsongs.json',
    ).writeAsString(json.encode(decoded), encoding: utf8);
  } catch (e) {
    log('$e', name: 'request.dart', level: 1000);
  }
}

Future<String> requestzxzrsongs() async {
  final response = await get(Uri.parse('https://chunithm.beerpsi.cc/songs'));
  return response.body;
}

Future<void> saveLatestVersion() async {
  final path = await getApplicationSupportDirectory();
  String configstr = await File('${path.path}/config.json').readAsString();
  Map<String, dynamic> config = json.decode(configstr);
  String latestversionstr = await requestLatestVersion();
  Map<String, dynamic> latestversion = json.decode(latestversionstr);
  config['latest_version'] = latestversion['version'];
  await File('${path.path}/config.json').writeAsString(json.encode(config));
}

Future<String> requestLatestVersion() async {
  final response = await get(
    Uri.parse('https://www.diving-fish.com/api/chunithmprober/latest_version'),
  );
  return response.body;
}

Future<String> requestRankingList({required int id, required int diff}) async {
  final headers = {'X-User-Token': await returnlxnstoken()};
  final response = await get(
    Uri.parse(
      'https://maimai.lxns.net/api/v0/user/chunithm/player/score/ranking?song_id=$id&level_index=$diff',
    ),
    headers: headers,
  );
  return response.body;
}

Future<String> requestRelatedCollectibles({required int id}) async {
  final response = await get(
    Uri.parse('https://maimai.lxns.net/api/v0/chunithm/song-collections/$id'),
  );
  return response.body;
}

Future<String> requestSongHistory({required int id, required int diff}) async {
  final headers = {'X-User-Token': await returnlxnstoken()};
  final response = await get(
    Uri.parse(
      'https://maimai.lxns.net/api/v0/user/chunithm/player/score/history?song_id=$id&level_index=$diff',
    ),
    headers: headers,
  );
  return response.body;
}

Future<String> requestTrendProgress({required int id}) async {
  final headers = {'X-User-Token': await returnlxnstoken()};
  final response = await get(
    Uri.parse('https://maimai.lxns.net/api/v0/user/chunithm/player/trophy/$id'),
    headers: headers,
  );
  return response.body;
}

Future<String> returnlxnstoken() async {
  final directory = await getApplicationSupportDirectory();

  final String configstr = await File(
    '${directory.path}/config.json',
  ).readAsString();
  Map<String, dynamic> config = json.decode(configstr);
  String token = config['lxns']['token'];
  return token;
}

Future<String> requestSongBests({
  required String token,
  required int songid,
}) async {
  final headers = {'X-User-Token': token};
  final response = await get(
    Uri.parse(
      'https://maimai.lxns.net/api/v0/user/chunithm/player/bests?song_id=$songid',
    ),
    headers: headers,
  );
  return response.body;
}

Future<String> requestB50() async {
  final headers = {'X-User-Token': await returnlxnstoken()};
  final response = await get(
    Uri.parse('https://maimai.lxns.net/api/v0/user/chunithm/player/bests'),
    headers: headers,
  );
  return response.body;
}

Future<void> saveB50() async {
  final directory = await getApplicationSupportDirectory();
  final file = File('${directory.path}/res/b50.json');
  try {
    String b50str = await requestB50();
    await file.writeAsString(b50str);
  } catch (e) {
    log('$e', name: 'settingspagefun.dart - request.dart', level: 1000);
  }
}

Future<String> requestPlayerInfo() async {
  final headers = {'X-User-Token': await returnlxnstoken()};
  final response = await get(
    Uri.parse('https://maimai.lxns.net/api/v0/user/chunithm/player'),
    headers: headers,
  );
  return response.body;
}

Future<void> savePlayerInfo() async {
  final directory = await getApplicationSupportDirectory();
  final file = File('${directory.path}/res/playerinfo.json');
  try {
    String playerinfostr = await requestPlayerInfo();
    await file.writeAsString(playerinfostr);
  } catch (e) {
    log('$e', name: 'settingspagefun.dart - request.dart', level: 1000);
  }
}

Future<void> saveTrend() async {
  final directory = await getApplicationSupportDirectory();
  final file = File('${directory.path}/res/trend.json');
  try {
    String allscorestr = await requestTrend(token: await returnlxnstoken());
    await file.writeAsString(allscorestr);
  } catch (e) {
    log('$e', name: 'settingspagefun.dart - request.dart', level: 1000);
  }
}

Future<void> saveAllScore() async {
  final directory = await getApplicationSupportDirectory();
  final file = File('${directory.path}/res/allscore.json');
  try {
    String allscorestr = await requestScore(token: await returnlxnstoken());
    await file.writeAsString(allscorestr);
  } catch (e) {
    log('$e', name: 'settingspagefun.dart - request.dart', level: 1000);
  }
}

Future<String> requestTrend({required String token}) async {
  final headers = {'X-User-Token': token};
  final response = await get(
    Uri.parse('https://maimai.lxns.net/api/v0/user/chunithm/player/trend'),
    headers: headers,
  );
  return response.body;
}

Future<String> requestScore({required String token}) async {
  final headers = {'X-User-Token': token};
  final response = await get(
    Uri.parse('https://maimai.lxns.net/api/v0/user/chunithm/player/scores'),
    headers: headers,
  );
  return response.body;
}

Future<String> requestPlatesData() async {
  final response = await get(
    Uri.parse('https://maimai.lxns.net/api/v0/chunithm/plate/list'),
  );
  return response.body;
}

Future<String> requestCharactersData() async {
  final response = await get(
    Uri.parse('https://maimai.lxns.net/api/v0/chunithm/character/list'),
  );
  return response.body;
}

Future<String> requestIconsData() async {
  final response = await get(
    Uri.parse('https://maimai.lxns.net/api/v0/chunithm/icon/list'),
  );
  return response.body;
}

Future<String> requestTrophiesData() async {
  final response = await get(
    Uri.parse('https://maimai.lxns.net/api/v0/chunithm/trophy/list'),
  );
  return response.body;
}

Future<String> requestLobbyData() async {
  final response = await get(
    Uri.parse('http://sega-register.wahlap.net/api/sega/midtr/rest/location'),
  );
  return response.body;
}

Future<String> requestAliasData() async {
  final response = await get(
    Uri.parse('https://maimai.lxns.net/api/v0/chunithm/alias/list'),
  );
  return response.body;
}

Future<String> requestSongData() async {
  final response = await get(
    Uri.parse('https://maimai.lxns.net/api/v0/chunithm/song/list'),
  );
  return response.body;
}

Future<Map<String, dynamic>> getSongInfo(int id) async {
  final response = await get(
    Uri.parse('https://maimai.lxns.net/api/v0/chunithm/song/$id'),
  );

  Map<String, dynamic> songInfo = jsonDecode(response.body);
  return songInfo;
}

Future<List<DataRow>> returnSongInfo(int id) async {
  List<DataCell> diff0 = [];
  List<DataCell> diff1 = [];
  List<DataCell> diff2 = [];
  List<DataCell> diff3 = [];
  List<DataCell> diff4 = [];
  List<DataCell> diff5 = [];
  List<DataRow> rowsData = [];
  try {
    Map<String, dynamic> songInfo = await getSongInfo(id);
    // print(songInfo);
    for (var i in songInfo['difficulties']) {
      switch (i['difficulty']) {
        case 0:
          diff0.add(DataCell(Text('${i['level_value']}')));
          diff0.add(DataCell(Text('${i['notes']['tap']}')));
          diff0.add(DataCell(Text('${i['notes']['hold']}')));
          diff0.add(DataCell(Text('${i['notes']['slide']}')));
          diff0.add(DataCell(Text('${i['notes']['air']}')));
          diff0.add(DataCell(Text('${i['notes']['flick']}')));
          diff0.add(DataCell(Text('${i['notes']['total']}')));
          diff0.add(DataCell(Text('${i['note_designer']}')));
          rowsData.add(DataRow(cells: diff0));
        case 1:
          diff1.add(DataCell(Text('${i['level_value']}')));
          diff1.add(DataCell(Text('${i['notes']['tap']}')));
          diff1.add(DataCell(Text('${i['notes']['hold']}')));
          diff1.add(DataCell(Text('${i['notes']['slide']}')));
          diff1.add(DataCell(Text('${i['notes']['air']}')));
          diff1.add(DataCell(Text('${i['notes']['flick']}')));
          diff1.add(DataCell(Text('${i['notes']['total']}')));
          diff1.add(DataCell(Text('${i['note_designer']}')));
          rowsData.add(DataRow(cells: diff1));
        case 2:
          diff2.add(DataCell(Text('${i['level_value']}')));
          diff2.add(DataCell(Text('${i['notes']['tap']}')));
          diff2.add(DataCell(Text('${i['notes']['hold']}')));
          diff2.add(DataCell(Text('${i['notes']['slide']}')));
          diff2.add(DataCell(Text('${i['notes']['air']}')));
          diff2.add(DataCell(Text('${i['notes']['flick']}')));
          diff2.add(DataCell(Text('${i['notes']['total']}')));
          diff2.add(DataCell(Text('${i['note_designer']}')));
          rowsData.add(DataRow(cells: diff2));
        case 3:
          diff3.add(DataCell(Text('${i['level_value']}')));
          diff3.add(DataCell(Text('${i['notes']['tap']}')));
          diff3.add(DataCell(Text('${i['notes']['hold']}')));
          diff3.add(DataCell(Text('${i['notes']['slide']}')));
          diff3.add(DataCell(Text('${i['notes']['air']}')));
          diff3.add(DataCell(Text('${i['notes']['flick']}')));
          diff3.add(DataCell(Text('${i['notes']['total']}')));
          diff3.add(DataCell(Text('${i['note_designer']}')));
          rowsData.add(DataRow(cells: diff3));
        case 4:
          diff4.add(DataCell(Text('${i['level_value']}')));
          diff4.add(DataCell(Text('${i['notes']['tap']}')));
          diff4.add(DataCell(Text('${i['notes']['hold']}')));
          diff4.add(DataCell(Text('${i['notes']['slide']}')));
          diff4.add(DataCell(Text('${i['notes']['air']}')));
          diff4.add(DataCell(Text('${i['notes']['flick']}')));
          diff4.add(DataCell(Text('${i['notes']['total']}')));
          diff4.add(DataCell(Text('${i['note_designer']}')));
          rowsData.add(DataRow(cells: diff4));
        case 5:
          diff5.add(DataCell(Text('${i['level_value']}')));
          diff5.add(DataCell(Text('${i['notes']['tap']}')));
          diff5.add(DataCell(Text('${i['notes']['hold']}')));
          diff5.add(DataCell(Text('${i['notes']['slide']}')));
          diff5.add(DataCell(Text('${i['notes']['air']}')));
          diff5.add(DataCell(Text('${i['notes']['flick']}')));
          diff5.add(DataCell(Text('${i['notes']['total']}')));
          diff5.add(DataCell(Text('${i['note_designer']}')));
          rowsData.add(DataRow(cells: diff5));
        default:
          List<DataCell> nodata = [
            DataCell(Text('无数据')),
            DataCell(Text('或者')),
            DataCell(Text('网络')),
            DataCell(Text('错误')),
            DataCell(Text('又或者')),
            DataCell(Text('请求')),
            DataCell(Text('过于')),
            DataCell(Text('频繁')),
          ];
          rowsData.add(DataRow(cells: nodata));
      }
    }
  } catch (e) {
    List<DataCell> nodata = [
      DataCell(Text('无数据')),
      DataCell(Text('或者')),
      DataCell(Text('网络')),
      DataCell(Text('错误')),
      DataCell(Text('又或者')),
      DataCell(Text('请求')),
      DataCell(Text('过于')),
      DataCell(Text('频繁')),
    ];
    rowsData.add(DataRow(cells: nodata));
    log('error $e', name: 'songinfopage.dart', level: 1000);
    return rowsData;
  }
  return rowsData;
}

double getNavBarHeight(BuildContext context) {
  return MediaQuery.of(context).viewInsets.bottom;
}
