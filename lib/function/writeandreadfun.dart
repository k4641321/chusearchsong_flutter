import 'dart:convert';
import 'dart:developer';
import 'package:shared_preferences/shared_preferences.dart';
import 'request.dart';

class WriteData {
  final SharedPreferences prefs;

  WriteData._(this.prefs);

  static Future<WriteData> create() async {
    final prefs = await SharedPreferences.getInstance();
    return WriteData._(prefs);
  }

  Future<void> writeLinkedVerseData() async {
    String result = await requestLinkedVerseData();
    prefs.setString('LinkedVerseData', result);
    log('LinkedVerse完成');
  }

  Future<void> writePlateData() async {
    String result = await requestPlatesData();
    prefs.setString('PlatesData', result);
    log('名牌版完成');
  }

  Future<void> writeIconsData() async {
    String result = await requestIconsData();
    prefs.setString('IconsData', result);
    log('头像完成');
  }

  Future<void> writeTrophiesData() async {
    String result = await requestTrophiesData();
    prefs.setString('TrophiesData', result);
    log('称号完成');
  }

  Future<void> writeCharactersData() async {
    String result = await requestCharactersData();
    prefs.setString('CharactersData', result);
    log('角色完成');
  }

  Future<void> writeSongsData() async {
    String result = await requestSongData();
    prefs.setString('SongsData', result);
    log('歌曲数据完成');
  }

  Future<void> writeWahlapLobbyData() async {
    String result = await requestWahlapLobbyData();
    prefs.setString('WahlapLobbyData', result);
    log('华立机厅数据完成');
  }

  Future<void> writeAliasData() async {
    String result = await requestAliasData();
    prefs.setString('AliasData', result);
    log('别名完成');
  }

  Future<void> writezxzrSongsData() async {
    log('请求reiwaf5sisongs');
    List zxzrsongslist = await requestreiwaf5sisongs();
    List chunirecall = jsonDecode(zxzrsongslist[1]);
    List chunithmrecord = jsonDecode(zxzrsongslist[0]);
    log('请求beerpsisongs');
    List beerpsisongs = jsonDecode(await requestbeerpsisongs());

    log('添加未拥有的曲目');
    List intlidList = [];
    int idx = -1;
    for (var i in beerpsisongs) {
      intlidList.add(i['id']);
    }
    for (var i in chunirecall) {
      if (!(i['meta'] as Map).containsKey('idx')) {
        List chartsList = [];
        List chartdiffList = (i['data'] as Map).keys.toList();
        for (var j in chartdiffList) {
          chartsList.add({
            "difficulty": j,
            "level": "${i['data'][j]['level']}",
            "const": i['data'][j]['const'],
            "charter": null,
            "version": null,
            "sdvxin_url": null,
            "available": true,
            "notecounts": {
              "total": i['data'][j]['maxcombo'],
              "tap": null,
              "hold": null,
              "slide": null,
              "air": null,
              "flick": null,
            },
          });
        }
        beerpsisongs.add({
          "id": idx,
          "chunirec_id": i['meta']['id'],
          "title": i['meta']['title'],
          "aliases": [],
          "artist": i['meta']['artist'],
          "genre": i['meta']['genre'],
          "release": i['meta']['release'],
          "version": null,
          "jacket_url":
              "https://chunithm-net-eng.com/mobile/img/${i['meta']['img']}.jpg",
          "duration": null,
          "bpm": {
            "min": i['meta']['bpm'],
            "max": i['meta']['bpm'],
            "mode": i['meta']['bpm'],
          },
          "availability": {"intl": false, "jp": true},
          "charts": chartsList,
        });
        idx--;
        continue;
      }
      if (!intlidList.contains(int.parse(i['meta']['idx']))) {
        List chartsList = [];
        List chartdiffList = (i['data'] as Map).keys.toList();
        for (var j in chartdiffList) {
          chartsList.add({
            "difficulty": j,
            "level": "${i['data'][j]['level']}",
            "const": i['data'][j]['const'],
            "charter": null,
            "version": null,
            "sdvxin_url": null,
            "available": true,
            "notecounts": {
              "total": i['data'][j]['maxcombo'],
              "tap": null,
              "hold": null,
              "slide": null,
              "air": null,
              "flick": null,
            },
          });
        }
        beerpsisongs.add({
          "id": int.parse(i['meta']['idx']),
          "chunirec_id": i['meta']['id'],
          "title": i['meta']['title'],
          "aliases": [],
          "artist": i['meta']['artist'],
          "genre": i['meta']['genre'],
          "release_date": i['meta']['release'],
          "version": null,
          "jacket_url":
              "https://new.chunithm-net.com/chuni-mobile/html/mobile/img/${i['meta']['img']}.jpg",
          "duration": null,
          "bpm": {
            "min": i['meta']['bpm'],
            "max": i['meta']['bpm'],
            "mode": i['meta']['bpm'],
          },
          "availability": {"intl": false, "jp": true},
          "charts": chartsList,
        });
      }
    }
    for (var i in chunithmrecord) {
      if (!intlidList.contains(int.parse(i['idx']))) {
        for (var j in beerpsisongs) {
          if (j['id'] == int.parse(i['idx'])) {
            j['version'] = i['version'];
          }
        }
      }
    }
    prefs.setString('zxzrSongsData', jsonEncode(beerpsisongs));
    log('最新最热歌曲完成');
  }

  Future<void> writeNearcadeAllShopAndNearcadeGames() async {
    int page = 1;
    List shopsList = [];
    bool hasNext = true;
    while (hasNext) {
      final rawJson = await requestNearcadeAllShop(page: page); // 请求当前页
      final result = await jsonDecode(rawJson) as Map<String, dynamic>;

      if (result.containsKey('shops')) {
        shopsList.addAll(result['shops']);
      }
      hasNext = result['hasNextPage'];
      log('有下一页');
      page++;
    }
    Map<String, dynamic> gameList = {};
    for (var i in shopsList) {
      for (var j in i['games']) {
        gameList['${j['titleId']}'] = '${j['name']}';
      }
    }
    prefs.setString('NearcadeAllShopData', jsonEncode(shopsList));
    log('Nearcade店铺完成');
    prefs.setString('NearcadeGamesData', jsonEncode(gameList));
    log('Nearcade游戏完成');
  }

  Future<void> writeSegaCharaData() async {
    String result = await requestSegaCharaData();
    prefs.setString('SegaCharaData', result);
    log('Sega角色完成');
  }

  Future<void> writeConfig(Map<String, dynamic> config) async {
    prefs.setString('Config', jsonEncode(config));
  }

  Future<void> writeLatestVersion() async {
    String result = await requestLatestVersion();
    prefs.setString('LatestVersion', result);
    log('最新版本号获取完成');
  }

  Future<void> writePlayerB50Data() async {
    String result = await requestB50();
    prefs.setString('PlayerB50Data', result);
    log('B50完成');
  }

  Future<void> writePlayerInfoData() async {
    String result = await requestPlayerInfo();
    prefs.setString('PlayerInfoData', result);
    log('玩家信息完成');
  }

  Future<void> writePlayerRatingTrendData() async {
    String result = await requestTrend();
    prefs.setString('PlayerRatingTrendData', result);
    log('Rating趋势完成');
  }

  Future<void> writePlayerAllScoreData() async {
    String result = await requestPlayerAllScore();
    prefs.setString('PlayerAllScoreData', result);
    log('所有成绩完成');
  }

  Future<void> writeFavoriteSongs(Map<String, dynamic> favorite) async {
    prefs.setString('FavoriteSongs', jsonEncode(favorite));
  }

  Future<void> writeRandomMusicHistory(List history) async {
    prefs.setString('RandomMusicHistory', jsonEncode(history));
  }
}

class ReadData {
  final SharedPreferences prefs;

  ReadData._(this.prefs);

  static Future<ReadData> create() async {
    final prefs = await SharedPreferences.getInstance();
    return ReadData._(prefs);
  }

  Future<Map<String, dynamic>> readLinkedVerseData() async {
    final str = prefs.getString('LinkedVerseData');
    return str != null ? jsonDecode(str) as Map<String, dynamic> : {};
  }

  Future<Map<String, dynamic>> readPlateData() async {
    final str = prefs.getString('PlatesData');
    return str != null ? jsonDecode(str) : {};
  }

  Future<Map<String, dynamic>> readIconsData() async {
    final str = prefs.getString('IconsData');
    return str != null ? jsonDecode(str) : {};
  }

  Future<Map<String, dynamic>> readTrophiesData() async {
    final str = prefs.getString('TrophiesData');
    return str != null ? jsonDecode(str) : {};
  }

  Future<Map<String, dynamic>> readCharactersData() async {
    final str = prefs.getString('CharactersData');
    return str != null ? jsonDecode(str) : {};
  }

  Future<Map<String, dynamic>> readSongsData() async {
    final str = prefs.getString('SongsData');
    return str != null ? jsonDecode(str) as Map<String, dynamic> : {};
  }

  Future<List> readWahlapLobbyData() async {
    final str = prefs.getString('WahlapLobbyData');
    return str != null ? jsonDecode(str) : [];
  }

  Future<Map<String, dynamic>> readAliasData() async {
    final str = prefs.getString('AliasData');
    return str != null ? jsonDecode(str) as Map<String, dynamic> : {};
  }

  Future<List> readzxzrSongsData() async {
    final str = prefs.getString('zxzrSongsData');
    return str != null ? jsonDecode(str) : [];
  }

  Future<Map<String, dynamic>> readNearcadeAllShop() async {
    final str = prefs.getString('NearcadeAllShop');
    return str != null ? jsonDecode(str) as Map<String, dynamic> : {};
  }

  Future<Map<String, dynamic>> readNearcadeGamesMapData() async {
    final str = prefs.getString('NearcadeGamesMap');
    return str != null ? jsonDecode(str) as Map<String, dynamic> : {};
  }

  Future<List> readSegaCharaData() async {
    final str = prefs.getString('SegaCharaData');
    return str != null ? jsonDecode(str) as List : [];
  }

  Future<Map<String, dynamic>> readConfig() async {
    final str = prefs.getString('Config');
    return str != null ? jsonDecode(str) as Map<String, dynamic> : {};
  }

  Future<Map<String, dynamic>> readLatestVersion() async {
    final str = prefs.getString('LatestVersion');
    return str != null ? jsonDecode(str) as Map<String, dynamic> : {};
  }

  Future<Map<String, dynamic>> readPlayerB50Data() async {
    final str = prefs.getString('PlayerB50Data');
    return str != null ? (jsonDecode(str) as Map<String, dynamic>)['data'] : {};
  }

  Future<Map<String, dynamic>> readPlayerInfoData() async {
    final str = prefs.getString('PlayerInfoData');
    return str != null ? (jsonDecode(str) as Map<String, dynamic>)['data'] : {};
  }

  Future<List> readPlayerRatingTrendData() async {
    final str = prefs.getString('PlayerRatingTrendData');
    return str != null ? jsonDecode(str)['data'] : [];
  }

  Future<List> readPlayerAllScoreData() async {
    final str = prefs.getString('PlayerAllScoreData');
    return str != null ? jsonDecode(str)['data'] : [];
  }

  Future<Map<String, dynamic>> readFavoriteSongs() async {
    final str = prefs.getString('FavoriteSongs');
    return str != null ? jsonDecode(str) as Map<String, dynamic> : {};
  }

  Future<List> readRandomMusicHistory() async {
    final str = prefs.getString('RandomMusicHistory');
    return str != null ? jsonDecode(str) as List : [];
  }
}

class SongDataStore {
  SongDataStore._();
  static final SongDataStore instance = SongDataStore._();

  Map<String, dynamic> songs = {};
  Map<String, dynamic> alias = {};
  List zxzrSongs = [];
  bool loaded = false;

  /// 启动时调用一次，全部读进内存
  Future<void> loadAll() async {
    final read = await ReadData.create();
    songs = await read.readSongsData();
    alias = await read.readAliasData();
    zxzrSongs = await read.readzxzrSongsData();
    loaded = true;
  }
}
