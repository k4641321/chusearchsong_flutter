import 'package:chusearchsong_flutter/function/writeandreadfun.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'dart:convert';

//热门歌曲
Future<String> requestHotSong(String type) async {
  final uri = Uri.parse(
    'https://maimai.lxns.net/api/v0/chunithm/song/popular?range=$type',
  );
  final response = await get(uri);
  if (response.statusCode != 200) {
    throw Exception('请求失败，状态码：${response.statusCode}');
  }

  return response.body;
}

//鸟率排行榜
Future<String> requestChunirecSongInfoPage(String chunirecid) async {
  final uri = Uri.parse('https://db.chunirec.net/music/$chunirecid');
  final response = await get(uri);
  if (response.statusCode != 200) {
    throw Exception('请求失败，状态码：${response.statusCode}');
  }

  return response.body;
}

//百合番
Future<String> requestLilyFan() async {
  final uri = Uri.parse('https://chusearchsong.devintom.top/api/lilyfan');
  final response = await get(uri);
  if (response.statusCode != 200) {
    throw Exception('请求失败，状态码：${response.statusCode}');
  }

  return response.body;
}

//Linked Verse
Future<String> requestLinkedVerseData() async {
  final uri = Uri.parse(
    'https://chusearchsong.devintom.top/api/linkedversedata',
  );
  final response = await get(uri);
  if (response.statusCode != 200) {
    throw Exception('请求失败，状态码：${response.statusCode}');
  }

  return response.body;
}

//赞助排行榜
Future<String> requestSponsorshipRanking() async {
  final uri = Uri.parse('https://chusearchsong.devintom.top/api/zxphb');
  final response = await get(uri);
  if (response.statusCode != 200) {
    throw Exception('请求失败，状态码：${response.statusCode}');
  }

  return response.body;
}

//请求reiwa.f5.si歌曲数据
Future<List> requestreiwaf5sisongs() async {
  late final Uri chunithmrecorduri;
  late final Uri chunirecalluri;
  Map<String, dynamic> config = await (await ReadData.create()).readConfig();
  if (config['chartproxy']) {
    chunithmrecorduri = Uri.parse(
      'https://chusearchsong.devintom.top/api/chunithmrecord',
    );
    chunirecalluri = Uri.parse(
      'https://chusearchsong.devintom.top/api/chunirecall',
    );
  } else {
    chunithmrecorduri = Uri.parse('https://reiwa.f5.si/chunithm_record.json');
    chunirecalluri = Uri.parse('https://reiwa.f5.si/chunirec_all.json');
  }
  final chunirecall = await get(chunirecalluri);
  final chunithmrecord = await get(chunithmrecorduri);
  if (chunirecall.statusCode != 200) {
    throw Exception('请求失败，状态码：${chunirecall.statusCode}');
  }
  if (chunithmrecord.statusCode != 200) {
    throw Exception('请求失败，状态码：${chunithmrecord.statusCode}');
  }
  return [chunithmrecord.body, chunirecall.body];
}

//请求Nearcade所有店铺数据
Future<String> requestNearcadeAllShop({required int page}) async {
  const hosts = ['nearcade.cn', 'nearca.de', 'nearcade.phizone.cn'];
  String? lastError;

  for (final host in hosts) {
    final uri = Uri.parse(
      'https://$host/api/shops/?regionId=CN&limit=100&page=$page',
    );
    try {
      final response = await get(uri).timeout(const Duration(seconds: 10));
      if (response.statusCode == 200) {
        return response.body;
      }
      lastError = '状态码 ${response.statusCode}';
    } catch (e) {
      lastError = e.toString();
    }
  }

  throw Exception('所有镜像请求失败，最后错误：$lastError');
}

//请求返回落雪Token
Future<String> requestOAuthCallbackToken(String code) async {
  final uri = Uri.parse(
    'https://chusearchsong.devintom.top/api/oauth/callback?code=$code',
  );
  final response = await get(uri);
  if (response.statusCode != 200) {
    throw Exception('请求失败，状态码：${response.statusCode}');
  }
  return response.body;
}

//请求其他玩家信息
Future<String> requestotherPlayerInfo(int friendcode) async {
  final uri = Uri.parse(
    'https://chusearchsong.devintom.top/api/playerinfo?friendcode=$friendcode',
  );
  final response = await get(uri);
  if (response.statusCode != 200) {
    throw Exception('请求失败，状态码：${response.statusCode}');
  }
  return response.body;
}

//上传玩家数据
Future<String> uploadplayerscore() async {
  final uri = Uri.parse(
    'https://chusearchsong.devintom.top/api/uploadallscore',
  );
  List score = await (await ReadData.create()).readPlayerAllScoreData();
  Map<String, dynamic> playerdata = (await (await ReadData.create())
      .readPlayerInfoData());

  final response = await post(
    uri,
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({'friendcode': playerdata['friend_code'], 'data': score}),
  );
  if (response.statusCode != 200) {
    throw Exception('请求失败，状态码：${response.statusCode}');
  }
  return response.body;
}

//请求Sega角色数据
Future<String> requestSegaCharaData() async {
  final response = await get(
    Uri.parse('https://chunithm.sega.jp/storage/json/chara.json'),
  );
  if (response.statusCode != 200) {
    throw Exception('请求失败，状态码：${response.statusCode}');
  }
  return response.body;
}

Future<String> requestuscount() async {
  final response = await get(
    Uri.parse('https://chusearchsong.devintom.top/api/usecount'),
  );
  if (response.statusCode != 200) {
    throw Exception('请求失败，状态码：${response.statusCode}');
  }
  return response.body;
}

//请求公告
Future<String> requestAnnouncement() async {
  final response = await get(
    Uri.parse('https://chusearchsong.devintom.top/api/announcement'),
  );
  if (response.statusCode != 200) {
    throw Exception('请求失败，状态码：${response.statusCode}');
  }
  return response.body;
}

//请求更新日志
Future<String> requestChangeslog() async {
  final response = await get(
    Uri.parse('https://chusearchsong.devintom.top/api/changelog'),
  );
  if (response.statusCode != 200) {
    throw Exception('请求失败，状态码：${response.statusCode}');
  }
  return response.body;
}

//通过Vercel获取谱面
Future<String> requestproxychartdata({
  required String charturl,
  required int levelindex,
}) async {
  final body = json.encode({"charturl": charturl, "level_index": levelindex});
  final response = await post(
    Uri.parse('https://chusearchsong.devintom.top/api/chart/'),
    headers: {'Content-Type': 'application/json'},
    body: body,
  );
  if (response.statusCode != 200) {
    throw Exception('请求失败，状态码：${response.statusCode}');
  }
  // log('status: ${response.statusCode}');
  // log('location: ${response.headers['location']}');
  // log('body: ${response.body}');
  return response.body;
}

//获取版本号
Future<String> requestVersion() async {
  final response = await get(
    Uri.parse('https://chusearchsong.devintom.top/api/version'),
  );
  if (response.statusCode != 200) {
    throw Exception('请求失败，状态码：${response.statusCode}');
  }
  return response.body;
}

//请求beerpsi歌曲数据
Future<String> requestbeerpsisongs() async {
  final response = await get(Uri.parse('https://chunithm.beerpsi.cc/songs'));
  if (response.statusCode != 200) {
    throw Exception('请求失败，状态码：${response.statusCode}');
  }
  return response.body;
}

//获取最新版本号
Future<String> requestLatestVersion() async {
  try {
    final response = await get(
      Uri.parse('https://chusearchsong.devintom.top/api/latest_version'),
    );
    if (response.statusCode != 200) {
      final response1 = await get(
        Uri.parse(
          'https://www.diving-fish.com/api/chunithmprober/latest_version',
        ),
      );
      if (response1.statusCode != 200) {
        throw Exception('请求失败，状态码：${response1.statusCode}');
      }
      return response1.body;
    }
    return response.body;
  } catch (e) {
    final response1 = await get(
      Uri.parse(
        'https://www.diving-fish.com/api/chunithmprober/latest_version',
      ),
    );
    if (response1.statusCode != 200) {
      throw Exception('请求失败，状态码：${response1.statusCode}');
    }
    return response1.body;
  }
}

//获取落雪排行榜
Future<String> requestRankingList({required int id, required int diff}) async {
  final headers = {'X-User-Token': await returnlxnstoken()};
  final response = await get(
    Uri.parse(
      'https://maimai.lxns.net/api/v0/user/chunithm/player/score/ranking?song_id=$id&level_index=$diff',
    ),
    headers: headers,
  );
  if (response.statusCode != 200) {
    throw Exception('请求失败，状态码：${response.statusCode}');
  }
  return response.body;
}

//请求关联收藏品
Future<String> requestRelatedCollectibles({required int id}) async {
  final response = await get(
    Uri.parse('https://maimai.lxns.net/api/v0/chunithm/song-collections/$id'),
  );
  if (response.statusCode != 200) {
    throw Exception('请求失败，状态码：${response.statusCode}');
  }
  return response.body;
}

//请求单曲成绩
Future<String> requestSongHistory({required int id, required int diff}) async {
  final headers = {'X-User-Token': await returnlxnstoken()};
  final response = await get(
    Uri.parse(
      'https://maimai.lxns.net/api/v0/user/chunithm/player/score/history?song_id=$id&level_index=$diff',
    ),
    headers: headers,
  );
  if (response.statusCode != 200) {
    throw Exception('请求失败，状态码：${response.statusCode}');
  }
  return response.body;
}

//获取收藏品进度
Future<String> requestTrendProgress({required int id}) async {
  final headers = {'X-User-Token': await returnlxnstoken()};
  final response = await get(
    Uri.parse('https://maimai.lxns.net/api/v0/user/chunithm/player/trophy/$id'),
    headers: headers,
  );
  if (response.statusCode != 200) {
    throw Exception('请求失败，状态码：${response.statusCode}');
  }
  return response.body;
}

//获取单曲最佳成绩
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
  if (response.statusCode != 200) {
    throw Exception('请求失败，状态码：${response.statusCode}');
  }
  return response.body;
}

//获取B50
Future<String> requestB50() async {
  final headers = {'X-User-Token': await returnlxnstoken()};
  final response = await get(
    Uri.parse('https://maimai.lxns.net/api/v0/user/chunithm/player/bests'),
    headers: headers,
  );
  if (response.statusCode != 200) {
    throw Exception('请求失败，状态码：${response.statusCode}');
  }
  return response.body;
}

//获取玩家信息
Future<String> requestPlayerInfo() async {
  final headers = {'X-User-Token': await returnlxnstoken()};
  final response = await get(
    Uri.parse('https://maimai.lxns.net/api/v0/user/chunithm/player'),
    headers: headers,
  );
  if (response.statusCode != 200) {
    throw Exception('请求失败，状态码：${response.statusCode}');
  }
  return response.body;
}

//获取玩家Rating趋势
Future<String> requestTrend() async {
  final headers = {'X-User-Token': await returnlxnstoken()};
  final response = await get(
    Uri.parse('https://maimai.lxns.net/api/v0/user/chunithm/player/trend'),
    headers: headers,
  );
  if (response.statusCode != 200) {
    throw Exception('请求失败，状态码：${response.statusCode}');
  }
  return response.body;
}

//获取全部成绩
Future<String> requestPlayerAllScore() async {
  final headers = {'X-User-Token': await returnlxnstoken()};
  final response = await get(
    Uri.parse('https://maimai.lxns.net/api/v0/user/chunithm/player/scores'),
    headers: headers,
  );
  if (response.statusCode != 200) {
    throw Exception('请求失败，状态码：${response.statusCode}');
  }
  return response.body;
}

//获取名牌版
Future<String> requestPlatesData() async {
  final response = await get(
    Uri.parse('https://maimai.lxns.net/api/v0/chunithm/plate/list'),
  );
  if (response.statusCode != 200) {
    throw Exception('请求失败，状态码：${response.statusCode}');
  }
  return response.body;
}

//获取角色
Future<String> requestCharactersData() async {
  final response = await get(
    Uri.parse('https://maimai.lxns.net/api/v0/chunithm/character/list'),
  );
  if (response.statusCode != 200) {
    throw Exception('请求失败，状态码：${response.statusCode}');
  }
  return response.body;
}

//获取头像
Future<String> requestIconsData() async {
  final response = await get(
    Uri.parse('https://maimai.lxns.net/api/v0/chunithm/icon/list'),
  );
  if (response.statusCode != 200) {
    throw Exception('请求失败，状态码：${response.statusCode}');
  }
  return response.body;
}

//获取称号
Future<String> requestTrophiesData() async {
  final response = await get(
    Uri.parse('https://maimai.lxns.net/api/v0/chunithm/trophy/list'),
  );
  if (response.statusCode != 200) {
    throw Exception('请求失败，状态码：${response.statusCode}');
  }
  return response.body;
}

//获取华立机厅数据
Future<String> requestWahlapLobbyData() async {
  final response = await get(
    Uri.parse('http://sega-register.wahlap.net/api/sega/midtr/rest/location'),
  );
  if (response.statusCode != 200) {
    throw Exception('请求失败，状态码：${response.statusCode}');
  }
  return response.body;
}

//获取别名数据
Future<String> requestAliasData() async {
  final response = await get(
    Uri.parse('https://maimai.lxns.net/api/v0/chunithm/alias/list'),
  );
  if (response.statusCode != 200) {
    throw Exception('请求失败，状态码：${response.statusCode}');
  }
  return response.body;
}

//获取歌曲数据
Future<String> requestSongData() async {
  final response = await get(
    Uri.parse('https://maimai.lxns.net/api/v0/chunithm/song/list'),
  );
  if (response.statusCode != 200) {
    throw Exception('请求失败，状态码：${response.statusCode}');
  }
  return response.body;
}

//获取单曲歌曲详细信息
Future<Map<String, dynamic>> getSongInfo(int id) async {
  final response = await get(
    Uri.parse('https://maimai.lxns.net/api/v0/chunithm/song/$id'),
  );
  if (response.statusCode != 200) {
    throw Exception('请求失败，状态码：${response.statusCode}');
  }

  Map<String, dynamic> songInfo = jsonDecode(response.body);
  return songInfo;
}

//获取落雪Token
Future<String> returnlxnstoken() async {
  Map<String, dynamic> config = await (await ReadData.create()).readConfig();
  if (config['lxns'] == null) {
    return 'null';
  }
  String token = config['lxns']['token'];
  return token;
}

double getNavBarHeight(BuildContext context) {
  return MediaQuery.of(context).viewInsets.bottom;
}

//请求玩家信息
Future<String> finduploadallscore(int friendcode) async {
  final uri = Uri.parse(
    'https://chusearchsong.devintom.top/api/finduploadallscore/$friendcode',
  );
  final response = await get(uri);
  if (response.statusCode != 200) {
    throw Exception('请求失败，状态码：${response.statusCode}');
  }
  // print(response.body);
  return response.body;
}
